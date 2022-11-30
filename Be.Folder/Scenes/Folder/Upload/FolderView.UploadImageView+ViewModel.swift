//
//  FolderView.UploadImageView+ViewModel.swift
//  Be.Folder
//
//  Created by Dorian on 30/11/2022.
//

import SwiftUI
import PhotosUI
import Core
import Combine

extension FolderView.UploadImageView {
    class ViewModel: ObservableObject {
        
        @Published
        var selectedImage: UIImage?
        
        @Published
        var isImageLoading: Bool = false
        
        @Published
        var name: String = ""
        
        @Published
        var canUpload: Bool = false
        
        private let currentFolderID: String
        private let folderRepository: FolderRepository
        private var subscriptions: [AnyCancellable] = []
        
        init(currentFolderID: String, folderRepository: FolderRepository) {
            self.currentFolderID = currentFolderID
            self.folderRepository = folderRepository
            
            $name
                .combineLatest($selectedImage)
                .sink { name, imageData in
                    self.canUpload = !name.isEmpty && imageData != nil
                }
        }
        
        func userDidPick(photo: PhotosPickerItem) {
            isImageLoading = true
            Task {
                // Retrive selected asset in the form of Data
                if let data = try? await photo.loadTransferable(type: Data.self) {
                    DispatchQueue.main.async {
                        self.selectedImage = UIImage(data: data)
                        self.isImageLoading = false
                    }
                }
            }
        }
        
        func uploadPhoto() {
            guard let selectedImage, let data = selectedImage.jpegData(compressionQuality: 0.2) else { return }
            folderRepository
                .uploadFile(name: name + ".jpg", data: data, parentFolderID: currentFolderID)
                .sink { completion in
                    if case let .failure(error) = completion {
                        print(error)
                    }
                } receiveValue: { file in
                    print("upload succeeded")
                }
                .store(in: &subscriptions)
        }
    }
}
