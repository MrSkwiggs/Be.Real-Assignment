//
//  RootView+ViewModel.swift
//  Be.Folder
//
//  Created by Dorian on 16/11/2022.
//

import Foundation
import Combine
import Core

extension RootView {
    class ViewModel: ObservableObject {
        
        private let loginProvider: LoginContract
        
        private var subscriptions: [AnyCancellable] = []
        
        @Published
        var session: Session?
        
        init(loginProvider: LoginContract) {
            self.loginProvider = loginProvider
            
            setupSubscriptions()
        }
        
        private func setupSubscriptions() {
            loginProvider
                .sessionPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] session in
                    guard let self else { return }
                    self.session = session
                }
                .store(in: &subscriptions)
            
        }
    }
}
