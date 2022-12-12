//
//  BeFolderAPI.Item+TextData.swift
//  Networking
//
//  Created by Dorian on 06/12/2022.
//

import Foundation
import Netswift

public extension BeFolderAPI.Item {
    
    /// API Request that retrieves a text file's contents.
    class TextData: BeFolderAuthenticatedEndpoint {
        public typealias Response = String
        
        public let id: File.ID
        public let token: String
        
        /// Fetches the contents of a text file by its ID.
        ///
        /// - parameters:
        ///     - id: The file's ID.
        ///     - token: The authentication token.
        public init(id: Inode.ID, token: String) {
            self.id = id
            self.token = token
        }
        
        public var path: String? { "\(BeFolderAPI.Item.path)/\(id)/data" }
        
        public func deserialise(_ incomingData: Data) -> NetswiftResult<String> {
            String(data: incomingData, encoding: .utf8).map { .success($0) } ?? .failure(NetswiftError(.unexpectedResponseError))
        }
    }
}
