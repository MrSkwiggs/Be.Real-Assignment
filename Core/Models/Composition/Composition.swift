//
//  Composition.swift
//  Core
//
//  Created by Dorian on 16/11/2022.
//

import Foundation

public class Composition {
    
    public let loginProvider: LoginContract
    
    let compositionFactory: CompositionFactoryContract
    
    init(loginProvider: LoginContract, compositionFactory: CompositionFactoryContract) {
        self.loginProvider = loginProvider
        self.compositionFactory = compositionFactory
    }
    
    public func authenticatedComposition(for session: Session) -> AuthenticatedComposition {
        compositionFactory.authenticatedComposition(from: session, with: self)
    }
}

public extension Composition {
    /// Main composition root for production environment
    static let main: Composition = .init(loginProvider: LoginProvider(),
                                         compositionFactory: CompositionFactory())
}

public extension Mock {
    /// Mock composition root for testing purposes
    static let composition: Composition = .init(loginProvider: Mock.LoginProvider(),
                                                compositionFactory: Mock.CompositionFactory())
}
