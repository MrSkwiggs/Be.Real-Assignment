//
//  BeFolderAPI.swift
//  Networking
//
//  Created by Dorian on 16/11/2022.
//

import Foundation
import Netswift

public class BeFolderAPI {
    static let domain: String = "163.172.147.216"
    
    internal let performer: NetswiftNetworkPerformer
    
    public init(performer: NetswiftNetworkPerformer = NetswiftPerformer()) {
        self.performer = performer
    }
    
    internal func perform<Response: Decodable,
                            Endpoint: BeFolderEndpoint<Response>>(_ endpoint: Endpoint,
                                                       deadline: DispatchTime? = nil,
                                                       _ handler: @escaping NetswiftHandler<Endpoint.Response>) -> NetswiftTask? {
        return performer.perform(endpoint, deadline: deadline) { result in
            DispatchQueue.main.async {
                handler(result)
            }
        }
    }
    
    internal func perform<Response: Decodable,
                          Endpoint: BeFolderEndpoint<Response>>(_ endpoint: Endpoint) async -> NetswiftResult<Endpoint.Response> {
        return await performer.perform(endpoint)
    }
}

public extension BeFolderAPI {
    func user(token: String) -> User {
        User(token: token)
    }
    
    enum Items {
        public static func folderContents(folderID: Inode.ID, token: String) -> Item.FolderContents {
            .init(id: folderID, token: token)
        }
        
        public static func imageData(imageID: File.ID, token: String) -> Item.ImageData {
            .init(id: imageID, token: token)
        }
    }
}
