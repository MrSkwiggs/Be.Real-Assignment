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
    enum Error: Swift.Error, Equatable {
        /// Username and/or password contains an invalid character (such as `:`)
        case invalidCharacter
        /// Unable to generate a base-64 encoded token
        case failedTokenEncoding
        /// Authentication failed because of credentials
        case authFailed
        /// Something went wrong with the network request
        case networkError(error: Swift.Error)
        
        public static func == (lhs: Login.Error, rhs: Login.Error) -> Bool {
            switch (lhs, rhs) {
            case (.invalidCharacter, .invalidCharacter): return true
            case (.failedTokenEncoding, .failedTokenEncoding): return true
            case (.authFailed, .authFailed): return true
            case (.networkError, .networkError): return true
                
            default: return false
            }
        }
    }
}
