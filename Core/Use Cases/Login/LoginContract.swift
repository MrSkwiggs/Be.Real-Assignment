//
//  LoginContract.swift
//  Core
//
//  Created by Dorian on 16/11/2022.
//

import Foundation
import Combine
import Networking

/// Protocol that dictates the Login business logic
public protocol LoginContract: AnyObject {
    
    /// Publishes an authenticated session upon successful login
    var sessionPublisher: AnyPublisher<Session, Never> { get }
    
    ///  Attempts to log in a user with the given credentials.
    ///  - parameters:
    ///     - username: The username credential.
    ///     - password: The password credential.
    /// - returns: A publisher that either emits `true` if the call succeeded (and then completes), or a failure with a Login Error.
    func login(username: String, password: String) -> AnyPublisher<Bool, Login.Error>
}
