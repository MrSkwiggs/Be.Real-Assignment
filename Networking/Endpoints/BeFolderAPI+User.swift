//
//  BeFolderAPI+User.swift
//  Networking
//
//  Created by Dorian on 16/11/2022.
//

import Foundation

public extension BeFolderAPI {
    
    /// API Request that fetches user info for the given token.
    class User: BeFolderAuthenticatedEndpoint {
        public typealias Response = Networking.User
        
        public let token: String
        
        /// Fetches the User info for the given token.
        ///
        /// - parameter token: The authentication token.
        public init(token: String) {
            self.token = token
        }
        
        public var path: String? {
            return "/me"
        }
    }
}

