//
//  BeFolderAPI.Item.CreateItem.swift
//  Networking
//
//  Created by Dorian on 30/11/2022.
//

import Foundation
import Netswift

public extension BeFolderAPI.Item {
    
    /// API Request that allows creating a folder or file on the server.
    class Create: BeFolderAuthenticatedEndpoint {
        public typealias Response = Inode
        
        public let currentFolderID: Inode.ID
        public let itemType: ItemType
        public let token: String
        
        /// The type of item to create
        public enum ItemType {
            /// The name of the folder to create.
            case folder(name: String)
            /// The name & data blob of the image to upload.
            case image(name: String, data: Data)
        }
        
        /// Creates the given item in the given folder.
        ///
        /// - parameters:
        ///     - itemType: The type of item to create.
        ///     - currentFolderID: The id of the folder in which the item should be created.
        ///     - token: The authentication token.
        public init(_ itemType: ItemType, currentFolderID: Inode.ID, token: String) {
            self.itemType = itemType
            self.currentFolderID = currentFolderID
            self.token = token
        }
        
        public var path: String? { "\(BeFolderAPI.Item.path)/\(currentFolderID)" }
        
        public var method: NetswiftHTTPMethod { .post }
        
        public var additionalHeaders: [RequestHeader] {
            switch itemType {
            case let .image(name, _):
                return [
                    .custom(key: "Content-Disposition", value: "attachment;filename*=utf-8''\(name)")
                ]
            default:
                return []
            }
        }
        
        public var contentType: MimeType {
            switch itemType {
            case .folder:
                return .json
            case .image:
                return .custom(type: "application/octet-stream")
            }
        }
        
        public var bodyEncoder: NetswiftEncoder? { JSONEncoder() }
        
        public func body(encodedBy encoder: NetswiftEncoder?) throws -> Data? {
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
