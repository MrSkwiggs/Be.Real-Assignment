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
            complete(success)
        case .failure(let failure):
            send(completion: .failure(failure))
        }
    }
    
    /// Sends the given output along with a `.finished` completion signal.
    func complete(_ output: Output) {
        send(output)
        self.send(completion: .finished)
    }
    
    /// Sends a void value along with a `.finished` completion signal.
    func complete() where Output == Void {
        send()
        self.send(completion: .finished)
    }
}
