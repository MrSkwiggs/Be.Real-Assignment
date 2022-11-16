//
//  LoginView+ViewModel.swift
//  Be.Folder
//
//  Created by Dorian on 16/11/2022.
//

import Foundation
import Combine
import Core

extension LoginView {
    class ViewModel: ObservableObject {
        
        private let loginProvider: LoginContract
        
        @Published
        var username: String = ""
        
        @Published
        var password: String = ""
        
        @Published
        var canLogin: Bool = false
        
        @Published
        var isBusyLoggingIn: Bool = false
        
        @Published
        var error: String?
        
        private var subscriptions: [AnyCancellable] = []
        private var loginAttempt: AnyCancellable?
        
        init(loginProvider: LoginContract) {
            self.loginProvider = loginProvider
            
            $username
                .zip($password)
                .sink { (username, password) in
                    self.canLogin = !username.isEmpty && !password.isEmpty
                }
                .store(in: &subscriptions)
            
            self.loginProvider
                .sessionPublisher
                .sink { session in
                    print(session)
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
                            self.showError("Invalid character contained in username/password\nMake sure not to include any \":\" in either.")
                        case .failedTokenEncoding:
                            self.showError("Something went wrong")
                        case .loginFailed:
                            self.showError("Invalid username and/or password\nMake sure you typed both correctly and try again")
                        }
                    }
                    self.isBusyLoggingIn = false
                } receiveValue: { [weak self] _ in
                    self?.isBusyLoggingIn = false
                }
        }
        
        private func showError(_ error: String) {
            self.error = error
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(10)) {
                self.error = nil
            }
        }
    }
}
