//
//  Composition.swift
//  Core
//
//  Created by Dorian on 16/11/2022.
//

import Foundation

public class Composition {
    public init() {}
}

public extension Composition {
    
    /// Main composition root for production environment
    static let main: Composition = .init()
}
