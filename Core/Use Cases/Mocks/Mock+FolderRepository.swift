//
//  Mock+FolderRepository.swift
//  Core
//
//  Created by Dorian on 07/12/2022.
//

import Foundation
import Combine
import Networking

extension Mock {
    
    /// A mock implementation of the FolderRepositoryContract, which can be configured to succeed or fail as necessary
    open class FolderRepository: FolderRepositoryContract {
        
        public var folderContentsResult: Result<[Inode], Error>
        public var createFolderResult: Result<Inode, Error>
        public var uploadFileResult: Result<Inode, Error>
        public var deleteItemResult: Result<Void, Error>
        
        /// Creates an instance of this Mock with pre-defined results for each of its functions.
        ///
        /// Defaults to `.success` results for all functions.
        public init(folderContentsResult: Result<[Inode], Error> = .success(Networking.Mock.folders()),
                    createFolderResult: Result<Inode, Error> = .success(Networking.Mock.folder),
                    uploadFileResult: Result<Inode, Error> = .success(Networking.Mock.file),
                    deleteItemResult: Result<Void, Error> = .success(())) {
            self.folderContentsResult = folderContentsResult
            self.createFolderResult = createFolderResult
            self.uploadFileResult = uploadFileResult
            self.deleteItemResult = deleteItemResult
        }
        
        public func fetchFolderContents(folderID: Inode.ID) -> AnyPublisher<[Inode], Error> {
            let publisher = PassthroughSubject<[Inode], Error>()
            publisher.complete(with: folderContentsResult)
            return publisher.eraseToAnyPublisher()
        }
        
        public func createFolder(name: String, parentFolderID: Inode.ID) -> AnyPublisher<Inode, Error> {
            let publisher = PassthroughSubject<Inode, Error>()
            publisher.complete(with: createFolderResult)
            return publisher.eraseToAnyPublisher()
        }
        
        public func uploadFile(name: String, data: Data, parentFolderID: Inode.ID) -> AnyPublisher<Inode, Error> {
            let publisher = PassthroughSubject<Inode, Error>()
            publisher.complete(with: uploadFileResult)
            return publisher.eraseToAnyPublisher()
        }
        
        public func deleteItem(itemID: Inode.ID) -> AnyPublisher<Void, Error> {
            let publisher = PassthroughSubject<Void, Error>()
            publisher.complete(with: deleteItemResult)
            return publisher.eraseToAnyPublisher()
        }
    }
}
