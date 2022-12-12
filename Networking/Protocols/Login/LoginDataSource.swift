//
//  LoginDataSource.swift
//  Networking
//
//  Created by Dorian on 08/12/2022.
//

import Netswift

/// A type that implements a LogIn functionality, which can be used to retrieve a `User` object.
public protocol LoginDataSourceContract {
    /// Attempts a login with the given authentication token.
    ///
    /// - parameters:
    ///     - token: The authentication token.
    ///     - callback: A completion block called when the call finishes.
    ///     - result: The result of the authentication call.
    func login(token: String, callback: @escaping NetswiftHandler<User>) -> NetswiftTask?
}
