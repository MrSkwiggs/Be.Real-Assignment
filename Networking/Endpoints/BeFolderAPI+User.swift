//
//  BeFolderAPI+User.swift
//  Networking
//
//  Created by Dorian on 16/11/2022.
//

import Foundation

public extension BeFolderAPI {
    class User: BeFolderAuthenticatedEndpoint {
        public typealias Response = Networking.User
        
        public let token: String
        
        public init(token: String) {
            self.token = token
        }
        
        public var path: String? {
            return "/me"
        }
    }
}

