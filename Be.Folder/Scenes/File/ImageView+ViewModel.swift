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
    class ViewModel: ObservableObject {
        private var fetch: AnyCancellable?
        private let file: File
        
        @Published
        var fileData: FileDataProvider.FileData?
        
        @Published
        var navbarTitle: String = ""
        
        @Published
        var hasError: Bool = false
        
        let fileDataProvider: FileDataProvider
        
        init(file: File, fileDataProvider: FileDataProvider) {
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
