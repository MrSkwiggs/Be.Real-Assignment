//
//  Session.swift
//  Core
//
//  Created by Dorian on 16/11/2022.
//

import Foundation
import Networking

public class Session: Codable {
    public let user: User
    public let token: String
    
    init(user: User, token: String) {
        self.user = user
        self.token = token
    }
}
