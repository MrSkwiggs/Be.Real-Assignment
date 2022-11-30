//
//  File.swift
//  Networking
//
//  Created by Dorian on 16/11/2022.
//

import Foundation

public class File: Inode {
    public let size: Int
    public let contentType: ContentType
    
    private enum CodingKeys: String, CodingKey {
        case size = "size"
        case contentType = "contentType"
    }
    
    internal init(size: Int,
                  contentType: File.ContentType,
                  id: ID,
                  parentID: ID? = nil,
                  name: String,
                  modificationDate: Date) {
        self.size = size
        self.contentType = contentType
        super.init(id: id, parentID: parentID, name: name, modificationDate: modificationDate)
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.size = try container.decode(Int.self, forKey: .size)
        self.contentType = try container.decode(ContentType.self, forKey: .contentType)
        try super.init(from: decoder)
    }
    
    override func equals(_ other: Inode) -> Bool {
        guard let file = other as? File else { return false }
        
        return super.equals(other)
            && size == file.size
            && contentType == file.contentType
    }
}

public extension File {
    enum ContentType: String, Codable, Equatable {
        case jpg = "image/jpeg"
        case png = "image/png"
        case octetStream = "application/octet-stream"
    }
}
