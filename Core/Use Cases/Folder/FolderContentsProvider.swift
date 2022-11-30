//
//  FolderContentsProvider.swift
//  Core
//
//  Created by Dorian on 16/11/2022.
//

import Foundation
import Combine
import Networking

public class FolderContentsProvider {
    private let contentsSubject: PassthroughSubject<[Inode], Never> = .init()
    private let token: String
    
    public lazy var contentsPublisher: AnyPublisher<[Inode], Never> = contentsSubject.eraseToAnyPublisher()
    
    public init(token: String) {
        self.token = token
    }
    
    public func fetchFolderContents(folderID: String) -> AnyPublisher<[Inode], Never> {
        let publisher = PassthroughSubject<[Inode], Never>()
        
        BeFolderAPI
            .Items
            .folderContents(folderID: folderID, token: token)
            .perform { result in
                switch result {
                case let .failure(error):
                    publisher.send([])
                    
                case let .success(inodes):
                    publisher.send(inodes)
                }
            }
        
        
        return publisher.eraseToAnyPublisher()
    }
}
