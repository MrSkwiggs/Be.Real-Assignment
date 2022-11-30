//
//  ImageView+ViewModel.swift
//  Be.Folder
//
//  Created by Dorian on 30/11/2022.
//

import Foundation
import Core
import Combine

extension ImageView {
    class ViewModel: ObservableObject {
        private var fetch: AnyCancellable?
        private let imageID: String
        
        @Published
        var imageData: Data?
        
        @Published
        var hasError: Bool = false
        
        let imageDataProvider: ImageDataProvider
        
        init(imageID: String, imageDataProvider: ImageDataProvider) {
            self.imageID = imageID
            self.imageDataProvider = imageDataProvider
            
            getImageData()
        }
        
        private func getImageData() {
            guard fetch == nil else { return }
            fetch = imageDataProvider
                .fetchImageData(imageID: imageID)
                .sink(receiveCompletion: { error in
                    self.hasError = true
                }, receiveValue: { data in
                    self.imageData = data
                })
        }
    }
}
