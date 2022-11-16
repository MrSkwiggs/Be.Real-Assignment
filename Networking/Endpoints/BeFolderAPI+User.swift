//
//  BeFolderAPI+User.swift
//  Networking
//
//  Created by Dorian on 16/11/2022.
//

import Foundation

public extension BeFolderAPI {
    class User: BeFolderEndpoint<Networking.User> {
        public enum Request {
            /// Returns the current user
            case me
        }
        
        let request: Request
        
        init(token: String, request: Request) {
            self.request = request
            super.init(token: token)
        }
        
        override public var path: String? {
            switch request {
            case .me: return "/me"
            }
        }
    }
}

