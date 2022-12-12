//
//  RequestHeader+Convenience.swift
//  Networking
//
//  Created by Dorian on 16/11/2022.
//

import Foundation
import Netswift

extension RequestHeader {
    
    /// `Authorization: Basic <token>`
    static func basicAuthentication(token: String) -> RequestHeader {
        .custom(key: "Authorization", value: "Basic \(token)")
    }
}
