//
//  FolderRepository.swift
//  Core
//
//  Created by Dorian on 16/11/2022.
//

import Foundation
import Combine
import Networking

public class FolderRepository {
    private let token: String
    
    public init(token: String) {
        self.token = token
    }
    
    public func fetchFolderContents(folderID: Inode.ID) -> AnyPublisher<[Inode], Error> {
        let publisher = PassthroughSubject<[Inode], Error>()
        
        BeFolderAPI
            .Item
            .FolderContents(id: folderID, token: token)
            .perform { result in
                switch result {
                case let .failure(error):
                    print(error)
                    publisher.send(completion: .failure(.networkError))
                    
                case let .success(inodes):
                    publisher.send(inodes)
                }
            }
        
        return publisher.eraseToAnyPublisher()
    }
    
    public func createFolder(name: String, parentFolderID: Inode.ID) -> AnyPublisher<Inode, Error> {
        let publisher = PassthroughSubject<Inode, Error>()
        
        BeFolderAPI
            .Item
            .CreateItem(currentFolderID: parentFolderID, itemType: .folder(name: name), token: token)
            .perform { result in
                switch result {
                case let .failure(error):
                    print(error)
                    publisher.send(completion: .failure(.networkError))
                    publisher.send(completion: .finished)
                    
                case let .success(inode):
                    publisher.send(inode)
                    publisher.send(completion: .finished)
                }
            }
        
        return publisher.eraseToAnyPublisher()
    }
    
    public func uploadFile(name: String, data: Data, parentFolderID: Inode.ID) -> AnyPublisher<Inode, Error> {
        let publisher = PassthroughSubject<Inode, Error>()
        
        BeFolderAPI
            .Item
            .CreateItem(currentFolderID: parentFolderID, itemType: .image(name: name, data: data), token: token)
            .perform { result in
                switch result {
                case let .failure(error):
                    print(error)
                    publisher.send(completion: .failure(.networkError))
                    publisher.send(completion: .finished)
                    
                case let .success(inode):
                    publisher.send(inode)
                    publisher.send(completion: .finished)
                }
            }
        
        return publisher.eraseToAnyPublisher()
    }
}
