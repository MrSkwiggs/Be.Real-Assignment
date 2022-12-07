//
//  Publisher+Convenience.swift
//  Be.Folder
//
//  Created by Dorian on 05/12/2022.
//

import Foundation
import Combine

public extension Subject {
    
    /// Maps the given Result type to its corresponding success or failure state, then sends that to the subject accordingly.
    /// - important: This sends a completion signal to the subject.
    func complete(with result: Result<Output, Failure>) {
        switch result {
        case .success(let success):
            complete(with: success)
        case .failure(let failure):
            send(completion: .failure(failure))
        }
    }
    
    /// Sends the given output along with a `.finished` completion signal.
    func complete(with output: Output) {
        send(output)
        send(completion: .finished)
    }
}
