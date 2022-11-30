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
        let date: Date
        do {
            date = try container.decode(Date.self, forKey: .modificationDate)
        } catch {
            // This is needed for inodes that store their modification date as an ISO-8601
            // with milliseconds (which is not handled by the native Decoder implementation)
            // cf. https://stackoverflow.com/a/46538423/3929910
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .iso8601)
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
            
            let dateString = try container.decode(String.self, forKey: .modificationDate)
            
            if let formatterDate = formatter.date(from: dateString) {
                date = formatterDate
            } else {
                date = try container.decode(Date.self, forKey: .modificationDate) // will fail but propagates the initial error back up the call chain
            }
        }
        
        self.modificationDate = date
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
