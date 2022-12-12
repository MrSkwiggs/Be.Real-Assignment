//
//  Mock+FileDataProvider.swift
//  Core
//
//  Created by Dorian on 07/12/2022.
//

import Foundation
import Networking
import Combine

extension Mock {
    
    /// A mock implementation of the FileDataContract, which can be configured to succeed or fail as necessary
    open class FileDataProvider: FileDataContract {
        
        public var fetchFileDataResult: Result<File.Data, Error>
        public var fetchRawDataResult: Result<Data, Error>
        public var fetchTextDataResult: Result<String, Error>
        
        /// Creates an instance of this Mock with pre-defined results for each of its functions.
        ///
        /// Defaults to `.success` results for all functions.
        public init(fetchFileDataResult: Result<File.Data, Error> = .success(.text(string: "Testy McTestface")),
                    fetchRawDataResult: Result<Data, Error> = .success("SGVsbG8sIHdvcmxkIQ==".data(using: .utf8)!),
                    fetchTextDataResult: Result<String, Error> = .success("Boaty McBoatFace")) {
            self.fetchFileDataResult = fetchFileDataResult
            self.fetchRawDataResult = fetchRawDataResult
            self.fetchTextDataResult = fetchTextDataResult
        }
        
        public func fetchFileData(for file: Networking.File) -> AnyPublisher<File.Data, Error> {
            let publisher = PassthroughSubject<File.Data, Error>()
            publisher.complete(with: fetchFileDataResult)
            return publisher.eraseToAnyPublisher()
        }
        
        public func fetchRawData(fileID: Networking.File.ID) -> AnyPublisher<Data, Error> {
            let publisher = PassthroughSubject<Data, Error>()
            publisher.complete(with: fetchRawDataResult)
            return publisher.eraseToAnyPublisher()
        }
        
        public func fetchTextData(fileID: Networking.File.ID) -> AnyPublisher<String, Error> {
            let publisher = PassthroughSubject<String, Error>()
            publisher.complete(with: fetchTextDataResult)
            return publisher.eraseToAnyPublisher()
        }
    }
}
