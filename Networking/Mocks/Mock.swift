//
//  Mock.swift
//  Networking
//
//  Created by Dorian on 16/11/2022.
//

import Foundation

/// Mock namespace
public enum Mock {
    /// John Doe, `rootFolder: Self.folder`
    public static let user: User = .init(firstName: "John",
                                         lastName: "Doe",
                                         rootFolder: folder)
    
    /// id: 1, name: RootFolder, modificationName: .now
    public static let folder: Folder = .init(id: "1",
                                             name: "Root Folder",
                                             modificationDate: .now)
    
    /// size: 42, contentType: JPG, id: 2, parentID: Self.folder.id, name: "Life.jpg", modificationDate: .now
    public static let file: File = .init(size: 42,
                                         contentType: .jpg,
                                         id: "2",
                                         parentID: folder.id,
                                         name: "Life.jpg",
                                         modificationDate: .now)
    
    /// A collection of mock folders, nested under the given folder
    public static func folders(from parent: Folder = folder) -> [Folder] {
        var result: [Folder] = []
        for index in 2...10 {
            result.append(.init(id: "\(index)", parentID: parent.id, name: "SubFolder \(index)", modificationDate: .now))
        }
        return result
    }
}
