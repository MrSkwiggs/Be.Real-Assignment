//
//  LoginViewModelTests.swift
//  Be.FolderTests
//
//  Created by Dorian on 07/12/2022.
//

import XCTest
import Combine
@testable import Be_Folder
@testable import Core

final class LoginViewModelTests: XCTestCase {
    typealias VM = LoginView.ViewModel
    
    var subscriptions: [AnyCancellable] = []
    
    var loginProvider: Mock.LoginProvider!
    var viewModel: VM!
    
    override func setUp() {
        loginProvider = .init(loginResult: .success(Mock.session))
        viewModel = .init(loginProvider: loginProvider)
    }
    
    override func tearDown() {
        subscriptions.forEach { $0.cancel() }
        subscriptions = []
        viewModel = nil
        loginProvider = nil
    }
    
    func zipCanLoginUsernameErrorAndPasswordErrorPublishers(then callback: @escaping (Bool, Bool, Bool) -> Void) {
        // Debounces are needed as setting credentials will emit for each letter, which prompts all publishers to re-emit every time
        Publishers.Zip3(viewModel.$canLogin.dropFirst().debounce(for: 0.5, scheduler: RunLoop.main),
                                 viewModel.$usernameFieldHasError.dropFirst().debounce(for: 0.5, scheduler: RunLoop.main),
                                 viewModel.$passwordFieldHasError.dropFirst().debounce(for: 0.5, scheduler: RunLoop.main))
        .sink(receiveValue: callback)
        .store(in: &subscriptions)
    }
    
    func testCanLoginWithEmptyCredentials() {
        let expectation = expectation(description: "ViewModel should emit canLogin, usernameFieldHasError and passwordFieldHasError values")
        
        let username = ""
        let password = ""
        let expectedCanLogin = false
        let expectedUsernameHasError = false
        let expectedPasswordHasError = false
        
        zipCanLoginUsernameErrorAndPasswordErrorPublishers { canLogin, usernameHasError, pwHasError in
            expectation.fulfill()
            XCTAssertEqual(canLogin, expectedCanLogin, "Can login")
            XCTAssertEqual(usernameHasError, expectedUsernameHasError, "Username has error")
            XCTAssertEqual(pwHasError, expectedPasswordHasError, "Password has error")
        }
        
        viewModel.username = username
        viewModel.password = password
        
        waitForExpectations(timeout: 2)
    }
    
    func testCanLoginWithEmptyUsername() {
        let expectation = expectation(description: "ViewModel should emit canLogin, usernameFieldHasError and passwordFieldHasError values")
        
        let username = ""
        let password = "myPassword"
        let expectedCanLogin = false
        let expectedUsernameHasError = false
        let expectedPasswordHasError = false
        
        zipCanLoginUsernameErrorAndPasswordErrorPublishers { canLogin, usernameHasError, pwHasError in
            expectation.fulfill()
            XCTAssertEqual(canLogin, expectedCanLogin, "Can login")
            XCTAssertEqual(usernameHasError, expectedUsernameHasError, "Username has error")
            XCTAssertEqual(pwHasError, expectedPasswordHasError, "Password has error")
        }
        
        viewModel.username = username
        viewModel.password = password
        
        waitForExpectations(timeout: 2)
    }
    
    func testCanLoginWithEmptyPassword() {
        let expectation = expectation(description: "ViewModel should emit canLogin, usernameFieldHasError and passwordFieldHasError values")
        
        let username = "username"
        let password = ""
        let expectedCanLogin = false
        let expectedUsernameHasError = false
        let expectedPasswordHasError = false
        
        zipCanLoginUsernameErrorAndPasswordErrorPublishers { canLogin, usernameHasError, pwHasError in
            expectation.fulfill()
            XCTAssertEqual(canLogin, expectedCanLogin, "Can login")
            XCTAssertEqual(usernameHasError, expectedUsernameHasError, "Username has error")
            XCTAssertEqual(pwHasError, expectedPasswordHasError, "Password has error")
        }
        
        viewModel.username = username
        viewModel.password = password
        
        waitForExpectations(timeout: 2)
    }
    
    func testCanLoginWithInvalidUsername() {
        let expectation = expectation(description: "ViewModel should emit canLogin, usernameFieldHasError and passwordFieldHasError values")
        
        let username = "user:name"
        let password = "myPassword"
        let expectedCanLogin = false
        let expectedUsernameHasError = true
        let expectedPasswordHasError = false
        
        zipCanLoginUsernameErrorAndPasswordErrorPublishers { canLogin, usernameHasError, pwHasError in
            expectation.fulfill()
            XCTAssertEqual(canLogin, expectedCanLogin, "Can login")
            XCTAssertEqual(usernameHasError, expectedUsernameHasError, "Username has error")
            XCTAssertEqual(pwHasError, expectedPasswordHasError, "Password has error")
        }
        
        viewModel.username = username
        viewModel.password = password
        
        waitForExpectations(timeout: 2)
    }
    
    func testCanLoginWithInvalidPassword() {
        let expectation = expectation(description: "ViewModel should emit canLogin, usernameFieldHasError and passwordFieldHasError values")
        
        let username = "username"
        let password = "myPa:ssword"
        let expectedCanLogin = false
        let expectedUsernameHasError = false
        let expectedPasswordHasError = true
        
        zipCanLoginUsernameErrorAndPasswordErrorPublishers { canLogin, usernameHasError, pwHasError in
            expectation.fulfill()
            XCTAssertEqual(canLogin, expectedCanLogin, "Can login")
            XCTAssertEqual(usernameHasError, expectedUsernameHasError, "Username has error")
            XCTAssertEqual(pwHasError, expectedPasswordHasError, "Password has error")
        }
        
        viewModel.username = username
        viewModel.password = password
        
        waitForExpectations(timeout: 2)
    }
    
    func testCanLoginWithInvalidCredentials() {
        let expectation = expectation(description: "ViewModel should emit canLogin, usernameFieldHasError and passwordFieldHasError values")
        
        let username = "user:name"
        let password = "myPa:ssword"
        let expectedCanLogin = false
        let expectedUsernameHasError = true
        let expectedPasswordHasError = true
        
        zipCanLoginUsernameErrorAndPasswordErrorPublishers { canLogin, usernameHasError, pwHasError in
            expectation.fulfill()
            XCTAssertEqual(canLogin, expectedCanLogin, "Can login")
            XCTAssertEqual(usernameHasError, expectedUsernameHasError, "Username has error")
            XCTAssertEqual(pwHasError, expectedPasswordHasError, "Password has error")
        }
        
        viewModel.username = username
        viewModel.password = password
        
        waitForExpectations(timeout: 2)
    }
    
    func testCanLoginWithValidCredentials() {
        let expectation = expectation(description: "ViewModel should emit canLogin, usernameFieldHasError and passwordFieldHasError values")
        
        let username = "username"
        let password = "myPassword"
        let expectedCanLogin = true
        let expectedUsernameHasError = false
        let expectedPasswordHasError = false
        
        zipCanLoginUsernameErrorAndPasswordErrorPublishers { canLogin, usernameHasError, pwHasError in
            expectation.fulfill()
            XCTAssertEqual(canLogin, expectedCanLogin, "Can login")
            XCTAssertEqual(usernameHasError, expectedUsernameHasError, "Username has error")
            XCTAssertEqual(pwHasError, expectedPasswordHasError, "Password has error")
        }
        
        viewModel.username = username
        viewModel.password = password
        
        waitForExpectations(timeout: 2)
    }
    
    func testAttemptsLogInAfterButtonTap() {
        let loginAttemptExpectation = expectation(description: "ViewModel should attempt login")
        
        loginProvider
            .loginAttemptsPublisher
            .sink {
                loginAttemptExpectation.fulfill()
            }
            .store(in: &subscriptions)
            
        
        viewModel.userDidTapLoginButton()
        waitForExpectations(timeout: 2)
    }
    
    func testEmitsErrorOnFailedLogin() {
        let expectation = expectation(description: "ViewModel should emit error message")
        
        loginProvider = .init(loginResult: .failure(.authFailed))
        viewModel = .init(loginProvider: loginProvider)
        
        viewModel
            .$error
            .dropFirst()
            .sink { error in
                expectation.fulfill()
                XCTAssertNotNil(error, "Error should have been emitted")
            }
            .store(in: &subscriptions)
        
        viewModel.userDidTapLoginButton()
        
        waitForExpectations(timeout: 2)
    }
}
