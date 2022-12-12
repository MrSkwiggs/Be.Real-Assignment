//
//  FileView+ViewModel.swift
//  Be.Folder
//
//  Created by Dorian on 30/11/2022.
//

import Foundation
import Core
import Networking
import Combine

extension FileView {
    /// The View Model for a FileView
    class ViewModel: ObservableObject {
        typealias File = Networking.File
        
        private var fetch: AnyCancellable?
        private let file: File
        
        /// The file's contents
        @Published
        var fileData: Core.File.Data?
        
        /// The title to be used in the navbar
        @Published
        var navbarTitle: String = ""
        
        /// Whether or not the view model ran into an error.
        @Published
        var hasError: Bool = false
        
        let fileDataProvider: FileDataContract
        
        init(file: File, fileDataProvider: FileDataContract) {
            self.file = file
            self.fileDataProvider = fileDataProvider
            self.navbarTitle = file.name
            getFileData()
        }
        
        private func getFileData() {
            guard fetch == nil else { return }
            fetch = fileDataProvider
                .fetchFileData(for: file)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure:
                        self.hasError = true
                    case .finished:
                        self.hasError = false
                    }
                }, receiveValue: { fileData in
                    self.fileData = fileData
                })
        }
    }
}
