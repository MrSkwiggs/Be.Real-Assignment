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
    private let contentsSubject: PassthroughSubject<[String], Never> = .init()
    
    public lazy var contentsPublisher: AnyPublisher<[String], Never> = contentsSubject.eraseToAnyPublisher()
    
    public init() {}
    
    public func fetchContents(for session: Session) -> AnyPublisher<[String], Never> {
        let publisher = PassthroughSubject<[String], Never>()
        
        BeFolderAPI
            .Items
            .folderContents(folderID: session.user.rootFolder.id, token: session.token)
            .perform { result in
                switch result {
                case let .failure(error):
                    publisher.send(["Something went wrong: \(error)"])
                    
                case let .success(inodes):
                    publisher.send(inodes.map(\.name))
                }
            }
        
        
        return publisher.eraseToAnyPublisher()
    }
}
