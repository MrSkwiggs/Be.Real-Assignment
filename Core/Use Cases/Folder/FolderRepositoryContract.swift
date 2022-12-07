//
//  FolderRepositoryContract.swift
//  Core
//
//  Created by Dorian on 07/12/2022.
//

import Foundation
import Combine
import Networking

/// Protocol that dictates the Folder handling logic
public protocol FolderRepositoryContract: AnyObject {
    
    /// Asynchronously retrieves the contents of the given folder.
    /// - parameter folderID: The folder ID for which we wish to retrieve contents
    /// - returns: A publisher that emits the contents of the folder as an `Inode` array if the operation succeeded, or a `Core.Error` otherwise.
    func fetchFolderContents(folderID: Inode.ID) -> AnyPublisher<[Inode], Error>
    
    /// Asynchronously creates a folder with the given folder name, nested in the given folder.
    /// - parameters:
    ///     - name: The name of the new folder to create.
    ///     - parentFolderID: The parent folder's ID.
    /// - returns: A publisher that emits the new folder as an `Inode` if the operation succeeded, or a `Core.Error` otherwise.
    func createFolder(name: String, parentFolderID: Inode.ID) -> AnyPublisher<Inode, Error>
    
    /// Asynchronously uploads the given file data, nested under the given folder.
    /// - parameters:
    ///     - name: The name of the new file to upload.
    ///     - parentFolderID: The parent folder's ID.
    /// - returns: A publisher that emits the new file as an `Inode` if the operation succeeded, or a `Core.Error` otherwise.
    func uploadFile(name: String, data: Data, parentFolderID: Inode.ID) -> AnyPublisher<Inode, Error>
    
    /// Asynchronously deletes the given file/folder by its ID.
    /// - parameter itemID: The item's ID.
    /// - returns: A publisher that emits `Void` if the operation succeeded, or a `Core.Error` otherwise.
    func deleteItem(itemID: Inode.ID) -> AnyPublisher<Void, Error>
}
