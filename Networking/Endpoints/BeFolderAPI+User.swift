//
//  BeFolderAPI+User.swift
//  Networking
//
//  Created by Dorian on 16/11/2022.
//

import Foundation

public extension BeFolderAPI {
    class User: BeFolderEndpoint<Networking.User> {
        override public var path: String? {
            return "/me"
        }
    }
}

