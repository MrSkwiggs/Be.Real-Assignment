//
//  FolderView+ViewModel.swift
//  Be.Folder
//
//  Created by Dorian on 16/11/2022.
//

import Foundation
import Combine
import Core
import Networking

extension FolderView {
    class ViewModel: ObservableObject {
        
        private let currentFolderID: String
        private let folderContentsProvider: FolderRepository
        
        @Published
        var folders: [String: String] = [:]
        
        @Published
        var images: [String: String] = [:]
        
        @Published
        var hasError: Bool = false
        
        private var fetch: AnyCancellable?
        
        init(folderID: String, folderContentsProvider: FolderRepository) {
            self.currentFolderID = folderID
            self.folderContentsProvider = folderContentsProvider
            
            getFolderContents()
        }
        
        private func getFolderContents() {
            guard fetch == nil else { return }
            fetch = folderContentsProvider
                .fetchFolderContents(folderID: currentFolderID)
                .sink(receiveCompletion: { error in
                    // error
                }, receiveValue: { contents in
                    var folders: [String: String] = [:]
                    var images: [String: String] = [:]
                    
                    contents.forEach { inode in
                        guard let file = inode.asFile() else {
                            folders[inode.id] = inode.name
                            return
                        }
                        images[file.id] = file.name
                    }
                    
                    self.folders = folders
                    self.images = images
                })
        }
        
        func retry() {
            getFolderContents()
        }
        
        func createFolderViewModel(from viewModelProvider: ViewModelProvider.SessionViewModelProvider) -> CreateNewFolderView.ViewModel {
            viewModelProvider.createFolderViewModel(currentFolderID: currentFolderID) { inode in
                self.getFolderContents()
            }
        }
        
        func uploadImageViewModel(from viewModelProvider: ViewModelProvider.SessionViewModelProvider) -> UploadImageView.ViewModel {
            viewModelProvider.uploadImageViewModel(currentFolderID: currentFolderID)
        }
    }
}
