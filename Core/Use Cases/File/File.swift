//
//  File.swift
//  Core
//
//  Created by Dorian on 07/12/2022.
//

import Foundation

/// File namespace
public enum File {}

public extension File {
    /// Defines what underlying Data type a File handles.
    enum Data {
        case image(data: Foundation.Data)
        case text(string: String)
        case raw(data: Foundation.Data)
    }
}
