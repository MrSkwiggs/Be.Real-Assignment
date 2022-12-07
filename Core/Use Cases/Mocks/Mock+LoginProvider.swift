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
        
        private let error: Login.Error?
        private let sessionSubject: PassthroughSubject<Session, Never> = .init()
        
        /// Whether or not login attempts should succeed (fails with the given error, if any. Succeeds otherwise)
        public init(error: Login.Error? = nil) {
            self.error = error
        }
        
        public lazy var sessionPublisher: AnyPublisher<Session, Never> = sessionSubject.eraseToAnyPublisher()
        
        public func login(username: String, password: String) -> AnyPublisher<Bool, Login.Error> {
            let publisher = PassthroughSubject<Bool, Login.Error>()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                guard let error = self.error else {
                    publisher.complete(with: true)
                    self.sessionSubject.send(.init(user: Networking.Mock.user, token: "MuchS3cr3t"))
                    return
                }
                
                publisher.send(completion: .failure(error))
            }
            
            return publisher.eraseToAnyPublisher()
        }
    }
}
