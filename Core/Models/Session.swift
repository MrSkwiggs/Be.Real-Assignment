//
//  Session.swift
//  Core
//
//  Created by Dorian on 16/11/2022.
//

import Foundation
import Networking

/// A representation of an app Session.
public class Session: Codable {
    
    /// The logged-in user.
    public let user: User
    /// The user's authentication token.
    public let token: String
    
    init(user: User, token: String) {
        self.user = user
        self.token = token
    }
}

public extension Mock {
    static let session: Session = .init(user: Networking.Mock.user, token: "123")
}
