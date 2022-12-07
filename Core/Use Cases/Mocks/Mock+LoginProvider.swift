//
//  Mock+LoginProvider.swift
//  Core
//
//  Created by Dorian on 16/11/2022.
//

import Foundation
import Combine
import Networking

extension Mock {
    open class LoginProvider: LoginContract {
        
        private let sessionSubject: PassthroughSubject<Session, Never> = .init()
        private let loginResult: Result<Session, Login.Error>
        
        /// Whether or not login attempts should succeed (fails with the given error, if any. Succeeds otherwise)
        public init(loginResult: Result<Session, Login.Error> = .success(Mock.session)) {
            self.loginResult = loginResult
        }
        
        public lazy var sessionPublisher: AnyPublisher<Session, Never> = sessionSubject.eraseToAnyPublisher()
        
        public func login(username: String, password: String) -> AnyPublisher<Bool, Login.Error> {
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
}
