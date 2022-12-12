# Be.Real-Assignment

![Logo](/Be.Folder/Assets.xcassets/AppIcon.appiconset/180.png)

This is my implementation of the assignment for the Sr. iOS Engineer position at BeReal.

The app is built using `Swift`, `SwiftUI` & `Combine`.

# Documentation
Included with this assignment, as DocC files (but can also very easily be re-generated from Xcode)

![docc](/Screenshots/docc.png)

Almost all classes and struct have documentation written. This also spans all 3 frameworks (UI, Core & Networking), as well as the Netswift dependency

# Architecture
The app is built using an MVVM architecture, where Models & other controllers (business logic) are nested in separate targets (Core & Networking).
This enforces separation of duties & helps mitigate code-spaghettification, but also allows for reuse in other projects.
Additionally, each framework is tested internally without requiring to expose private or internal APIs publicly.

For the Networking layer, I am using a 3rd-party dependency as a Swift Package ([Netswift](https://github.com/MrSkwiggs/Netswift)), which I wrote myself a couple years ago. More info [here](#networking).

## UI
There are 8 Views (Scenes) and ViewModels, as well as 2 non-view related controllers/managers.

### Root

The top-most view of the app, and the first thing the user sees (without _actually_ seeing it).

It essentially decides what the user sees; the login view if not logged in yet, or the root folder contents.

Like the `Root View`, the `Root ViewModel` is relatively simple as well, as it only listens to an emitted `Session` object from the LoginViewModel, to which is hooks into.

### Login
A simple Login view, that allows the user to enter their credentials & log in.

Its Viewmodel does a little bit of input validation (checks fields don't contain any `:`) and error handling.

![login](/Screenshots/login.gif)

### Root Folder

A view that allows the user to display files & folders, and navigate to subfolders.

It also displays the User navigation icon, which navigates to the User view.

Finally, it provides two navigation items that allow the creation of new folders & to upload files.

![folder-contents](/Screenshots/folder-contents.png)

### User View

A simple list of the user's information

![user](/Screenshots/user.gif)

### Navigating Folders & Displaying Images

Each folder listed in the folder view allows the user to navigate to it, and displays its underlying contents.

Images (and certain other files like text) can be displayed by tapping on them.

![image](/Screenshots/image.gif)
![text](/Screenshots/text.gif)

### Creating a new folder

Tapping the first navigation bar item allows the user to create a new folder.

![new-folder](/Screenshots/new-folder.gif)

The newly created folder is immediately visible, as the folder contents are refreshed whenever the API call returns.

### Uploading an image

Tapping the second navigation bar item allows the user to pick and upload a new image.

![new-image](/Screenshots/upload.gif)

Likewise, the newly uploaded image shows up in the list right away, and can be displayed fullscreen.

### Deleting folders & files

Finally, the user can delete files & folders by simply dragging on the row of the item to delete, to the left and pressing "Delete".

![delete](/Screenshots/delete.gif)

As with creating, deleting takes effect immediately and folder contents are refreshed as soon as the API call returns.

## Core

Contains most `UseCases` and their implementations, as well as mocks for testing & debugging.

Use cases represent a piece of business logic or responsibility.

Each use case is defined in 3 formats;

### Protocol
This defines the scope of the use case, what it does, how it should be used.

For instance, the login use case is defined as such:

```swift
/// Protocol that dictates the Login business logic
public protocol LoginContract: AnyObject {
    
    /// Publishes an authenticated session upon successful login
    var sessionPublisher: AnyPublisher<Session, Never> { get }
    
    ///  Attempts to log in a user with the given credentials.
    ///  - parameters:
    ///     - username: The username credential.
    ///     - password: The password credential.
    /// - returns: A publisher that either emits `true` if the call succeeded (and then completes), or a failure with a Login Error.
    func login(username: String, password: String) -> AnyPublisher<Bool, Login.Error>
}
```

This is what enables dependency injection, as the UI layer's view models refer to use cases only as protocols. (Which means the actual implementation can be injected at will, either using the real, production logic or a mock/testing implementation)

### Implementation
Then, once the protocol is defined, I implement the main controller/class/struct and make it conform to the protocol.

I then use this implementation in the App Composition object; the main App Composition will provide use case implementations, and that's where I decided which implementation fullfills which use case.

### Mock

Additionally, I implement a Mock implementation of the use case, which allows me to control exactly what to return.

For instance, the Mock LoginProvider is implemented as such:

```swift
/// A Mock implementation of the Login Contract. Can be configured to succeed or fail as necessary.
open class LoginProvider: LoginContract {
    
    private let sessionSubject: PassthroughSubject<Session, Never> = .init()
    private let loginAttemptsSubject: PassthroughSubject<Void, Never> = .init()
    private let loginResult: Result<Session, Login.Error>
    
    /// Whether or not login attempts should succeed (fails with the given error, if any. Succeeds otherwise)
    public init(loginResult: Result<Session, Login.Error> = .success(Mock.session)) {
        self.loginResult = loginResult
    }
    
    public lazy var sessionPublisher: AnyPublisher<Session, Never> = sessionSubject.eraseToAnyPublisher()
    
    /// Emits whenever this provider's login(_:) function is called
    public lazy var loginAttemptsPublisher: AnyPublisher<Void, Never> = loginAttemptsSubject.eraseToAnyPublisher()
    
    public func login(username: String, password: String) -> AnyPublisher<Bool, Login.Error> {
        loginAttemptsSubject.send(())
        
        let publisher = PassthroughSubject<Bool, Login.Error>()
        
        RunLoop.main.perform { [weak self] in
            guard let self else { return }
            
            publisher.complete(with: self.loginResult.map { _ in true })
            
            if case let .success(session) = self.loginResult {
                self.sessionSubject.send(session)
            }
        }
        
        return publisher.eraseToAnyPublisher()
    }
}
```

What you will see is that, underlying operation results are actually defined upon initialisation, and those are effectively used when calling the `login(_:)` function.

In essence, the mock implementation does do any meaningful work, is completely detached from the Networking layer and does not depend on anything.

## Networking

Contains the config files for API requests as well as mocks for testing & debugging, and is built on top of my own, open-source, networking package [Netswift](https://github.com/MrSkwiggs/Netswift).
It's an opinionated framework I've built myself over the last couple of years and have used in my own apps as well as at [OneFit](https://one.fit), which allows me to be very structured but flexible when it comes to implemented an app's networking layer.

# Tests

As mentioned in [Architecture](#architecture), each framework is tested individually, and while I have implemented _some_ amount of tests, for the sake of time I have not covered 100% of the codebase.

## UI

In the interest of time, I've only written tests for both the RootViewModel & the LoginViewModel.

![ui-tests](/Screenshots/ui-tests.png)

## Core

Likewise, Core tests only cover the LoginProvider implementation, as well as some public-facing Combine extensions

![core-tests](/Screenshots/core-tests.png)

As you might have noticed from the screenshot above however, one test fails at the moment.

I've handled this as an expected failure, as I was completely unable to identify why this did not succeed. I've added a comment as to what I have attempted to get this to work and why it's failing.

At the very least, this test failure would not block any CI pipelines since it is using the `XCTExpectFailure` api.

## Networking

And finally, as an example of testing that could be implemented for the Networking layer, I have implemented a single test here to show how the networking dependency part can be mocked and injected.

![networking-tests](/Screenshots/networking-tests.png)

# Error Handling & Asynchronous updates

The app is built to handle errors & asynchronous data flows. Loading indicators are used whenever asynchronous operations are performed, letting the user know something is happening.

Likewise, errors and issues are relayed to the user, and more often that not, let the user retry failed operations.

# App shortcomings

The app does not to persist any data (such as user session). This was a conscious decision, but because the app is written in a way that permits dependency injection, implementing this would not be too much work.

Also, since I implemented support for text files, it would be very easy to provide a text-editing functionality to the user; 
- load up the text file's contents in a text field
- let the user change and edit the text to their wish
- when the user wishes to "save" their edits, delete the old text file, and reupload it with the same name but modified contents.

