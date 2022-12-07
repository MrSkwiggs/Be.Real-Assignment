//
//  User.swift
//  Networking
//
//  Created by Dorian on 16/11/2022.
//

import Foundation

public struct User: Codable, Equatable {
    
    public let firstName: String
    public let lastName: String
    public let rootFolder: Folder
    
    internal init(firstName: String, lastName: String, rootFolder: Folder) {
        self.firstName = firstName
        self.lastName = lastName
        self.rootFolder = rootFolder
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.firstName = try container.decode(String.self, forKey: .firstName)
        self.lastName = try container.decode(String.self, forKey: .lastName)
        self.rootFolder = try container.decode(Folder.self, forKey: .rootFolder)
    }
    
    private enum CodingKeys: String, CodingKey {
        case firstName = "firstName"
        case lastName = "lastName"
        case rootFolder = "rootItem"
    }
}
