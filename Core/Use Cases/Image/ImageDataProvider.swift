//
//  ImageDataProvider.swift
//  Core
//
//  Created by Dorian on 30/11/2022.
//

import Foundation
import Combine
import Networking

public class ImageDataProvider {
    private let token: String
    
    public init(token: String) {
        self.token = token
    }
    
    public func fetchImageData(imageID: File.ID) -> AnyPublisher<Data, Error> {
        let publisher = PassthroughSubject<Data, Error>()
        
        BeFolderAPI
            .Item
            .ImageData(id: imageID, token: token)
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
}
