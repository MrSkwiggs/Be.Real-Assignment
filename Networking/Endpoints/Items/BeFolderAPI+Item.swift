//
//  BeFolderAPI+Item.swift
//  Networking
//
//  Created by Dorian on 16/11/2022.
//

import Foundation

public extension BeFolderAPI {
    class Item<Response: Decodable>: BeFolderEndpoint<Response> {
        
        public override var path: String? { "/items" }
    }
}
