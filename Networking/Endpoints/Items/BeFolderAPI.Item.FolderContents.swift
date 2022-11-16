//
//  BeFolderAPI.Item.FolderContents.swift
//  Networking
//
//  Created by Dorian on 16/11/2022.
//

import Foundation

public extension BeFolderAPI.Item {
    class FolderContents: Item<[Inode]> {
        
        internal init(id: Inode.ID, token: String) {
            self.id = id
            super.init(token: token)
        }
        
        let id: Inode.ID
        
        public override var path: String? { "\(super.path!)/\(id)" }
    }
}
