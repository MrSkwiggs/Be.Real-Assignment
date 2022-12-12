//
//  BeFolderAPI.Item+ImageData.swift
//  Networking
//
//  Created by Dorian on 30/11/2022.
//

import Foundation
import Netswift

public extension BeFolderAPI.Item {
    
    /// API Request that retrieves an image's raw data.
    class ImageData: BeFolderAuthenticatedEndpoint {
        public typealias Response = Data
        
        public let id: File.ID
        public let token: String
        
        /// Fetches the raw data of an image by its ID.
        ///
        /// - parameters:
        ///     - id: The image's ID.
        ///     - token: The authentication token.
        public init(id: Inode.ID, token: String) {
            self.id = id
            self.token = token
        }
        
        public var path: String? { "\(BeFolderAPI.Item.path)/\(id)/data" }
        
        public func deserialise(_ incomingData: Data) -> NetswiftResult<Data> {
            .success(incomingData)
        }
    }
}
