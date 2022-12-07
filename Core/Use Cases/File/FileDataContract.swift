//
//  FileDataContract.swift
//  Core
//
//  Created by Dorian on 07/12/2022.
//

import Foundation
import Combine
import Networking

/// Protocol that dictates the File Data retrieving logic
public protocol FileDataContract: AnyObject {
    /// Asynchronously retrieves the data of the given file.
    /// - parameter file: The `File` for which we wish to retrieve data.
    /// - returns: A publisher that emits a typed data `File.Data` object if the operation succeeded, or a `Core.Error` otherwise.
    func fetchFileData(for file: Networking.File) -> AnyPublisher<File.Data, Error>
    
    /// Asynchronously retrieves the raw data of the given file.
    /// - parameter fileID: The `File` ID for which we wish to retrieve data.
    /// - returns: A publisher that emits raw `Data` if the operation succeeded, or a `Core.Error` otherwise.
    func fetchRawData(fileID: Networking.File.ID) -> AnyPublisher<Data, Error>
    
    /// Asynchronously retrieves the text contents of the given file.
    /// - parameter file: The `File` ID for which we wish to retrieve data.
    /// - returns: A publisher that emits a typed `String` object if the operation succeeded, or a `Core.Error` otherwise.
    func fetchTextData(fileID: Networking.File.ID) -> AnyPublisher<String, Error>
}
