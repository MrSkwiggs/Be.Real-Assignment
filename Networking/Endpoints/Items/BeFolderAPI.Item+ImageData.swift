//
//  BeFolderAPI.Item+ImageData.swift
//  Networking
//
//  Created by Dorian on 30/11/2022.
//

import Foundation
import Netswift

public extension BeFolderAPI.Item {
    class ImageData: BeFolderEndpoint<Data> {
        internal init(id: Inode.ID, token: String) {
            self.id = id
            super.init(token: token)
        }
        
        let id: File.ID
        
        public override var path: String? { "\(Item.path!)/\(id)/data" }
        
        public override func deserialise(_ incomingData: Data) -> NetswiftResult<Data> {
            .success(incomingData)
        }
    }
}
