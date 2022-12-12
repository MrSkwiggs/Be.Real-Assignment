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
    /// The ViewModel of a UploadImageView
    class ViewModel: ObservableObject {
        
        /// The user's selected image, if they have picked one yet.
        @Published
        var selectedImage: UIImage?
        
        /// Whether or not an image is being loaded.
        @Published
        var isImageLoading: Bool = false
        
        /// The name of the image
        @Published
        var name: String = ""
        
        /// Whether or not the user can press the upload button
        @Published
        var canUpload: Bool = false
        
        /// Whether or not the image is being uploaded & created.
        @Published
        var isLoading: Bool = false
        
        /// Whether or not the view model ran into an error when uploading the image.
        @Published
        var hasError: Bool = false
        
        private let onImageUploaded: () -> Void
        private let currentFolderID: String
        private let folderRepository: FolderRepositoryContract
        private var subscriptions: [AnyCancellable] = []
        
        init(currentFolderID: String, folderRepository: FolderRepositoryContract, then callback: @escaping () -> Void) {
            self.onImageUploaded = callback
            self.currentFolderID = currentFolderID
            self.folderRepository = folderRepository
            
            $name
                .combineLatest($selectedImage)
                .sink { name, imageData in
                    self.canUpload = !name.isEmpty && imageData != nil
                }
                .store(in: &subscriptions)
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
        
        func uploadPhoto(then callback: @escaping () -> Void) {
            hasError = false
            isLoading = true
            guard let selectedImage, let data = selectedImage.jpegData(compressionQuality: 0.2) else { return }
            folderRepository
                .uploadFile(name: name + ".jpg", data: data, parentFolderID: currentFolderID)
                .sink { completion in
                    switch completion {
                    case let .failure(error):
                        print(error)
                        self.hasError = true
                        
                    case .finished:
                        callback()
                        self.onImageUploaded()
                    }
                    
                    self.isLoading = false
                } receiveValue: { file in
                    print("upload succeeded")
                }
                .store(in: &subscriptions)
        }
    }
}
