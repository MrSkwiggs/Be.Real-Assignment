//
//  Login.swift
//  Core
//
//  Created by Dorian on 16/11/2022.
//

import Foundation

/// Login Namespace
public enum Login {}

public extension Login {
    enum Error: Swift.Error {
        /// Username and/or password contains an invalid character (such as `:`)
        case invalidCharacter
        /// Unable to generate a base-64 encoded token
        case failedTokenEncoding
        /// Authentication failed because of credentials
        case loginFailed
    }
}
