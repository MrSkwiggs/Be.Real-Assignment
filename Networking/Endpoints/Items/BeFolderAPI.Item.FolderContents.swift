//
//  BeFolderAPI.Item.FolderContents.swift
//  Networking
//
//  Created by Dorian on 16/11/2022.
//

import Foundation
import Netswift

public extension BeFolderAPI.Item {
    class FolderContents: BeFolderAuthenticatedEndpoint {
        public typealias Response = [Inode]
        
        public let id: Inode.ID
        public let token: String
        
        public init(id: Inode.ID, token: String) {
            self.id = id
            self.token = token
        }
        
        public var path: String? { "\(BeFolderAPI.Item.path)/\(id)" }
        
        public func deserialise(_ incomingData: Data) -> NetswiftResult<Response> {
            Self.defaultDeserialise(type: Container.self, incomingData: incomingData)
                .map(\.inodes)
        }
    }
}

fileprivate extension BeFolderAPI.Item.FolderContents {
    class Container: Codable {
        public let inodes: [Inode]
        
        enum CustomCodingKeys: String, CodingKey {
            case isDirectory = "isDir"
        }
        
        required public init(from decoder: Decoder) throws {
            var container = try decoder.unkeyedContainer()
            var containerCopy = container
            
            var result: [Inode] = []
            
            while !container.isAtEnd {
                let object = try container.nestedContainer(keyedBy: CustomCodingKeys.self)
                
                if try object.decode(Bool.self, forKey: .isDirectory) {
                    result.append(try containerCopy.decode(Inode.self))
                } else {
                    result.append(try containerCopy.decode(File.self))
                }
            }
            self.inodes = result
        }
    }
}
