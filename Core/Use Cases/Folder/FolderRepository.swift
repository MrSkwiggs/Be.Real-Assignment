//
//  FolderRepository.swift
//  Core
//
//  Created by Dorian on 16/11/2022.
//

import Foundation
import Combine
import Networking

public class FolderRepository: FolderRepositoryContract {
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
                    publisher.complete(inodes)
                }
            }
        
        return publisher.eraseToAnyPublisher()
    }
    
    public func createFolder(name: String, parentFolderID: Inode.ID) -> AnyPublisher<Inode, Error> {
        let publisher = PassthroughSubject<Inode, Error>()
        
        BeFolderAPI
            .Item
            .Create(.folder(name: name), currentFolderID: parentFolderID, token: token)
            .perform { result in
                switch result {
                case let .failure(error):
                    print(error)
                    publisher.send(completion: .failure(.networkError))
                    publisher.send(completion: .finished)
                    
                case let .success(inode):
                    publisher.complete(inode)
                }
            }
        
        return publisher.eraseToAnyPublisher()
    }
    
    public func uploadFile(name: String, data: Data, parentFolderID: Inode.ID) -> AnyPublisher<Inode, Error> {
        let publisher = PassthroughSubject<Inode, Error>()
        
        BeFolderAPI
            .Item
            .Create(.image(name: name, data: data), currentFolderID: parentFolderID, token: token)
            .perform { result in
                switch result {
                case let .failure(error):
                    print(error)
                    publisher.send(completion: .failure(.networkError))
                    
                case let .success(inode):
                    publisher.complete(inode)
                }
            }
        
        return publisher.eraseToAnyPublisher()
    }
    
    public func deleteItem(itemID: Inode.ID) -> AnyPublisher<Void, Error> {
        let publisher = PassthroughSubject<Void, Error>()
        
        BeFolderAPI
            .Item
            .DeleteItem(itemID: itemID, token: token)
            .perform { result in
                switch result {
                case let .failure(error):
                    print(error)
                    publisher.send(completion: .failure(.networkError))
                    
                case .success:
                    publisher.complete()
                }
            }
        
        return publisher.eraseToAnyPublisher()
    }
}
