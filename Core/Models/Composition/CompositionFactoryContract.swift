//
//  CompositionFactoryContract.swift
//  Core
//
//  Created by Dorian on 07/12/2022.
//

import Foundation

/// Bridges between Composition and AuthenticatedComposition
protocol CompositionFactoryContract: AnyObject {
    func authenticatedComposition(from session: Session, with root: Composition) -> AuthenticatedComposition
}
