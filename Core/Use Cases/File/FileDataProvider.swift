//
//  ImageDataProvider.swift
//  Core
//
//  Created by Dorian on 30/11/2022.
//

import Foundation
import Combine
import Networking

public class FileDataProvider: FileDataContract {
    private let token: String
    
    public init(token: String) {
        self.token = token
    }
    
    public func fetchFileData(for file: Networking.File) -> AnyPublisher<File.Data, Error> {
        switch file.contentType {
        case .jpg, .png:
            return fetchRawData(fileID: file.id).map { .image(data: $0) }.eraseToAnyPublisher()
            
        case .octetStream, .unknow:
            return fetchRawData(fileID: file.id).map { .raw(data: $0) }.eraseToAnyPublisher()
            
        case .text:
            return fetchTextData(fileID: file.id).map { .text(string: $0) }.eraseToAnyPublisher()
        }
    }
    
    public func fetchRawData(fileID: Networking.File.ID) -> AnyPublisher<Data, Error> {
        let publisher = PassthroughSubject<Data, Error>()
        
        BeFolderAPI
            .Item
            .ImageData(id: fileID, token: token)
            .perform { result in
                switch result {
                case let .failure(error):
                    print(error)
                    publisher.send(completion: .failure(.networkError))
                    
                case let .success(data):
                    publisher.complete(with: data)
                }
            }
        
        return publisher.eraseToAnyPublisher()
    }
    
    public func fetchTextData(fileID: Networking.File.ID) -> AnyPublisher<String, Error> {
        fetchRawData(fileID: fileID)
            .map { String(data: $0, encoding: .utf8) }
            .flatMap { text -> AnyPublisher<String, Error> in
                guard let text else {
                    return Fail(error: .networkError).eraseToAnyPublisher()
                }
                return Just(text).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}

