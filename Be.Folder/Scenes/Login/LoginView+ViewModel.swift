//
//  LoginView+ViewModel.swift
//  Be.Folder
//
//  Created by Dorian on 16/11/2022.
//

import Foundation
import Combine
import Core
import UIKit

extension LoginView {
    /// The ViewModel for the LoginView
    class ViewModel: ObservableObject {
        
        private let loginProvider: LoginContract
        
        /// The user's username credential
        @Published
        var username: String = ""
        
        /// Whether or not the username field has an error
        @Published
        var usernameFieldHasError: Bool = false
        
        /// The user's password credential
        @Published
        var password: String = ""
        
        /// Whether or not the password field has an error
        @Published
        var passwordFieldHasError: Bool = false
        
        /// Whether or not the user can press the login button
        @Published
        var canLogin: Bool = false
        
        /// Whether or not the view model is busy with logging in the user.
        @Published
        var isBusyLoggingIn: Bool = false
        
        /// Whether or not the view model ran into an error while logging the user in.
        @Published
        var error: String?
        
        private var errorDispatchItem: DispatchWorkItem?
        
        private var subscriptions: [AnyCancellable] = []
        private var loginAttempt: AnyCancellable?
        
        init(loginProvider: LoginContract) {
            self.loginProvider = loginProvider
            
            $username
                .combineLatest($password)
                .sink { (username, password) in
                    self.usernameFieldHasError = username.contains(":")
                    self.passwordFieldHasError = password.contains(":")
                    self.canLogin = !username.isEmpty
                        && !password.isEmpty
                        && !self.usernameFieldHasError
                        && !self.passwordFieldHasError
                }
                .store(in: &subscriptions)
        }
        
        func userDidTapLoginButton() {
            guard !isBusyLoggingIn else { return }
            isBusyLoggingIn = true
            loginAttempt?.cancel()
            
            loginAttempt = loginProvider.login(username: username, password: password)
                .sink { [weak self] completion in
                    guard let self else { return }
                    switch completion {
                    case .finished:
                        break // do nothing
                        
                    case .failure(let error):
                        switch error {
                        case .invalidCharacter:
                            self.showError("Invalid character contained in username/password.\nMake sure not to include any \":\" in either.")
                        case .failedTokenEncoding:
                            self.showError("Unable to use these credentials.")
                        case .authFailed:
                            self.showError("Invalid username and/or password.\nMake sure you typed both correctly and try again.")
                        case let .networkError(error):
                            self.showError("Something went wrong while processing this request.\n\(error.localizedDescription).")
                        }
                    }
                    self.isBusyLoggingIn = false
                } receiveValue: { [weak self] _ in
                    self?.isBusyLoggingIn = false
                }
        }
        
        private func showError(_ error: String) {
            errorDispatchItem?.cancel()
            
            self.error = error
            
            let task = DispatchWorkItem {
                self.error = nil
            }
            
            errorDispatchItem = task
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(10), execute: task)
            
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
    }
}
