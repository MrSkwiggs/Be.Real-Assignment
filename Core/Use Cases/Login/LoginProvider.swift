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
    
    public func login(username: String, password: String) -> AnyPublisher<Bool, Login.Error> {
        let publisher = PassthroughSubject<Bool, Login.Error>()
        
        guard username.contains(/:/) == false && password.contains(/:/) == false else {
            publisher.send(.failure(.invalidCharacter))
            return publisher.eraseToAnyPublisher()
        }
        
        guard let token = "\(username):\(password)".data(using: .utf8)?.base64EncodedString() else {
            publisher.send(.failure(.failedTokenEncoding))
            return publisher.eraseToAnyPublisher()
        }
        BeFolderAPI.User(token: token).perform { [weak self] result in
            publisher.send(
                result
                    .mapError({ error in
                        guard error.category.httpStatusCode == 401 else {
                            return .networkError(error: error)
                        }
                        return .authFailed
                    })
                    .map({
                        self!.sessionSubject.send(.init(user: $0, token: token))
                        return true
                    })
            )
        }
        
        return publisher.eraseToAnyPublisher()
    }
}

extension Subject {
    func send(_ result: Result<Output, Failure>) {
        switch result {
        case .success(let success):
            send(success)
        case .failure(let failure):
            send(completion: .failure(failure))
        }
    }
}
