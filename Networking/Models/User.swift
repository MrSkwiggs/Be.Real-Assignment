//
//  User.swift
//  Networking
//
//  Created by Dorian on 16/11/2022.
//

import Foundation

/// A User object.
public struct User: Codable, Equatable {
    
    /// The user's first name
    public let firstName: String
    /// The user's last name
    public let lastName: String
    /// The user's root folder
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
