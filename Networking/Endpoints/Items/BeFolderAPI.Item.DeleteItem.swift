//
//  BeFolderAPI.Item.DeleteItem.swift
//  Networking
//
//  Created by Dorian on 30/11/2022.
//

import Foundation
import Netswift

public extension BeFolderAPI.Item {
    class DeleteItem: BeFolderAuthenticatedEndpoint {
        public typealias Response = Void
        
        public let itemID: Inode.ID
        public let token: String
        
        public var method: NetswiftHTTPMethod { .delete }
        public var path: String? { "\(BeFolderAPI.Item.path)/\(itemID)" }
        
        public init(itemID: Inode.ID, token: String) {
            self.itemID = itemID
            self.token = token
        }
        
        public func deserialise(_ incomingData: Data) -> NetswiftResult<Void> {
            .success(())
        }
    }
}
