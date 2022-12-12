//
//  BeFolderAPI.Item.DeleteItem.swift
//  Networking
//
//  Created by Dorian on 30/11/2022.
//

import Foundation
import Netswift

public extension BeFolderAPI.Item {
    
    /// API Request that allows deleting any item on the server.
    class DeleteItem: BeFolderAuthenticatedEndpoint {
        public typealias Response = Void
        
        public let itemID: Inode.ID
        public let token: String
        
        public var method: NetswiftHTTPMethod { .delete }
        public var path: String? { "\(BeFolderAPI.Item.path)/\(itemID)" }
        
        /// Deletes the given item.
        ///
        /// - parameters:
        ///     - itemID: The ID of the item to delete.
        ///     - token: The authentication token.
        public init(itemID: Inode.ID, token: String) {
            self.itemID = itemID
            self.token = token
        }
        
        public func deserialise(_ incomingData: Data) -> NetswiftResult<Void> {
            .success(())
        }
    }
}
