//
//  ViewModelProvider.swift
//  Be.Folder
//
//  Created by Dorian on 16/11/2022.
//

import Foundation
import Combine
import Core
import Networking

/// App-wide object that provides configured view models.
///
/// This should be passed as an environment object on the root view, so that underlying views may construct and navigate to other views.
class ViewModelProvider: ObservableObject {
    private let root: Composition
    
    init(root: Composition) {
        self.root = root
    }
    
    /// Provides a RootView ViewModel
    var rootViewModel: RootView.ViewModel {
        .init(loginProvider: root.loginProvider)
    }
    
    /// Provides a LoginView ViewModel
    var loginViewModel: LoginView.ViewModel {
        .init(loginProvider: root.loginProvider)
    }
    
    /// Generates a Session ViewModel Provider from the given session
    func sessionViewModelProvider(session: Session) -> SessionViewModelProvider {
        .init(root: root.authenticatedComposition(for: session))
    }
}
