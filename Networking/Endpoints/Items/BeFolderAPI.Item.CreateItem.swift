//
//  BeFolderAPI.Item.CreateItem.swift
//  Networking
//
//  Created by Dorian on 30/11/2022.
//

import Foundation
import Netswift

public extension BeFolderAPI.Item {
    class CreateItem: BeFolderEndpoint<Inode> {
        let currentFolderID: Inode.ID
        let itemType: ItemType
        
        public init(currentFolderID: Inode.ID, itemType: ItemType, token: String) {
            self.currentFolderID = currentFolderID
            self.itemType = itemType
            super.init(token: token)
        }
        
        public enum ItemType {
            case folder(name: String)
            case image(name: String, data: Data)
        }
        
        public override var path: String? { "\(Item.path!)/\(currentFolderID)" }
        public override var method: NetswiftHTTPMethod { .post }
        public override var additionalHeaders: [RequestHeader] {
            switch itemType {
            case let .image(name, _):
                return [
                    .custom(key: "Content-Disposition", value: "attachment;filename*=utf-8''\(name)")
                ]
            default:
                return []
            }
        }
        public override var contentType: MimeType {
            switch itemType {
            case .folder:
                return .json
            case .image:
                return .custom(type: "application/octet-stream")
            }
        }
        
        public override func body(encodedBy encoder: NetswiftEncoder?) throws -> Data? {
            switch itemType {
            case let .folder(name):
                return try encoder?.encode(FolderNameBody(name: name))
                
            case let .image(_, data):
                return data
            }
        }
        
        private struct FolderNameBody: Codable {
            let name: String
        }
    }
}
