//
//  BeFolderAPI.Item+TextData.swift
//  Networking
//
//  Created by Dorian on 06/12/2022.
//

import Foundation
import Netswift

public extension BeFolderAPI.Item {
    class TextData: BeFolderAuthenticatedEndpoint {
        public typealias Response = String
        
        public let id: File.ID
        public let token: String
        
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
