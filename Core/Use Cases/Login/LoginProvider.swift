//
//  LoginProvider.swift
//  Core
//
//  Created by Dorian on 16/11/2022.
//

import Foundation
import Combine
import Networking

public class LoginProvider: LoginContract {
    
    private let sessionSubject: PassthroughSubject<Session, Never> = .init()
    
    public var sessionPublisher: AnyPublisher<Session, Never> { sessionSubject.eraseToAnyPublisher() }
    
    private let dataSource: LoginDataSourceContract
    
    init(dataSource: LoginDataSourceContract) {
        self.dataSource = dataSource
    }
    
    public func login(username: String, password: String) -> AnyPublisher<Bool, Login.Error> {
        let publisher = PassthroughSubject<Bool, Login.Error>()
        
        guard username.contains(/:/) == false && password.contains(/:/) == false else {
            publisher.complete(with: .failure(.invalidCharacter))
            return publisher.eraseToAnyPublisher()
        }
        
        guard let token = "\(username):\(password)".data(using: .utf8)?.base64EncodedString() else {
            publisher.complete(with: .failure(.failedTokenEncoding))
            return publisher.eraseToAnyPublisher()
        }
        
        _ = dataSource.login(token: token) { [weak self] result in
            publisher.complete(
                with: result
                    .mapError({ error in
                        guard error.category.httpStatusCode == 401 else {
                            return .networkError(error: error)
                        }
                        return .authFailed
                    })
                    .map({
                        guard let self else { return false }
                        self.sessionSubject.send(.init(user: $0, token: token))
                        return true
                    })
            )
        }
        
        return publisher.eraseToAnyPublisher()
    }
}
