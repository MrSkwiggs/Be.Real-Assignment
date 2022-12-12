//
//  Composition.swift
//  Core
//
//  Created by Dorian on 16/11/2022.
//

import Foundation
import Networking

/// App composition layer.
///
/// Defines & holds references to dependencies.
public class Composition {
    
    /// Login Contract Dependency
    public let loginProvider: LoginContract
    
    /// Factory dependency, which can be used to generate authenticated composition objects.
    let compositionFactory: CompositionFactoryContract
    
    init(loginProvider: LoginContract, compositionFactory: CompositionFactoryContract) {
        self.loginProvider = loginProvider
        self.compositionFactory = compositionFactory
    }
    
    /// Generates an `AuthenticatedComposition` object from the given `Session` object
    public func authenticatedComposition(for session: Session) -> AuthenticatedComposition {
        compositionFactory.authenticatedComposition(from: session, with: self)
    }
}

public extension Composition {
    /// Main composition root for production environment
    static let main: Composition = .init(loginProvider: LoginProvider(dataSource: BeFolderAPI.main),
                                         compositionFactory: CompositionFactory())
}

public extension Mock {
    /// Mock composition root for testing purposes
    static let composition: Composition = .init(loginProvider: Mock.LoginProvider(),
                                                compositionFactory: Mock.CompositionFactory())
}
