//
//  Composition.swift
//  Core
//
//  Created by Dorian on 16/11/2022.
//

import Foundation

public class Composition {
    
    public let loginProvider: LoginContract
    
    init(loginProvider: LoginContract) {
        self.loginProvider = loginProvider
    }
}

public extension Composition {
    
    /// Main composition root for production environment
    static func main() -> Composition {
        .init(loginProvider: LoginProvider())
    }
    
    /// Mock composition root for testing purposes
    static func mock() -> Composition {
        .init(loginProvider: Mock.LoginProvider())
    }
}
