//
//  ViewModelProvider.swift
//  Be.Folder
//
//  Created by Dorian on 16/11/2022.
//

import Foundation
import Combine
import Core

class ViewModelProvider: ObservableObject {
    private let root: Composition
    
    init(root: Composition) {
        self.root = root
    }
    
    var rootViewModel: RootView.ViewModel {
        .init(loginProvider: root.loginProvider)
    }
    
    var loginViewModel: LoginView.ViewModel {
        .init(loginProvider: root.loginProvider)
    }
    
    func sessionViewModelProvider(session: Session) -> SessionViewModelProvider {
        .init(session: session, root: root)
    }
}

extension ViewModelProvider {
    class SessionViewModelProvider: ObservableObject {
        private let session: Session
        private let root: Composition
        
        init(session: Session, root: Composition) {
            self.session = session
            self.root = root
        }
    }
}
