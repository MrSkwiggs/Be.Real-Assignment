//
//  Composition.swift
//  Core
//
//  Created by Dorian on 16/11/2022.
//

import Foundation

public class Composition {
    
    public let loginProvider: LoginContract
    public let folderContentsProvider: FolderContentsProvider
    
    init(loginProvider: LoginContract, folderContentsProvider: FolderContentsProvider) {
        self.loginProvider = loginProvider
        self.folderContentsProvider = folderContentsProvider
    }
}

public extension Composition {
    
    /// Main composition root for production environment
    static func main() -> Composition {
        .init(loginProvider: LoginProvider(),
              folderContentsProvider: .init())
    }
    
    /// Mock composition root for testing purposes
    static func mock() -> Composition {
        .init(loginProvider: Mock.LoginProvider(),
              folderContentsProvider: .init())
    }
}
