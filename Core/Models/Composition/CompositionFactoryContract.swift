//
//  CompositionFactoryContract.swift
//  Core
//
//  Created by Dorian on 07/12/2022.
//

import Foundation

/// Bridges between Composition and AuthenticatedComposition
protocol CompositionFactoryContract: AnyObject {
    
    /// Generates an `AuthenticatedComposition` from the given session, according to the given `Composition` object.
    func authenticatedComposition(from session: Session, with root: Composition) -> AuthenticatedComposition
}
