//
//  Inode.swift
//  Networking
//
//  Created by Dorian on 16/11/2022.
//

import Foundation

public class Inode: Identifiable, Codable, Equatable {
    public typealias ID = String
    
    public let id: ID
    public let parentID: ID?
    public let name: String
    public let modificationDate: Date
    
    internal init(id: Inode.ID, parentID: Inode.ID? = nil, name: String, modificationDate: Date) {
        self.id = id
        self.parentID = parentID
        self.name = name
        self.modificationDate = modificationDate
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Inode.ID.self, forKey: .id)
        self.parentID = try container.decodeIfPresent(Inode.ID.self, forKey: .parentID)
        self.name = try container.decode(String.self, forKey: .name)
        self.modificationDate = try container.decode(Date.self, forKey: .modificationDate)
    }
    
    public static func == (lhs: Inode, rhs: Inode) -> Bool {
        lhs.equals(rhs)
    }
    
    internal func equals(_ other: Inode) -> Bool {
        id == other.id
        && parentID == other.parentID
        && name == other.name
        && modificationDate == other.modificationDate
    }
}
