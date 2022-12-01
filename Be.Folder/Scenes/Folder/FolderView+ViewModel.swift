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
        
        private let currentFolder: Inode
        private let folderContentsProvider: FolderRepository
        
        @Published
        var folders: [Inode] = []
        
        @Published
        var images: [File] = []
        
        @Published
        var hasError: Bool = false
        
        let breadcrumbs: String
        
        private var fetch: AnyCancellable?
        private var delete: AnyCancellable?
        
        init(folder: Inode, folderContentsProvider: FolderRepository, breadcrumbs: String? = nil) {
            self.currentFolder = folder
            self.folderContentsProvider = folderContentsProvider
            self.breadcrumbs = breadcrumbs.map { "\($0) / \(folder.name)" } ?? folder.name
            getFolderContents()
        }
        
        private func getFolderContents() {
            guard fetch == nil else { return }
            fetch = folderContentsProvider
                .fetchFolderContents(folderID: currentFolder.id)
                .sink(receiveCompletion: { error in
                    // error
                }, receiveValue: { contents in
                    var folders: [Inode] = []
                    var images: [File] = []
                    
                    contents.forEach { inode in
                        guard let file = inode.asFile() else {
                            folders.append(inode)
                            return
                        }
                        images.append(file)
                    }
                    
                    self.folders = folders.sorted { $0.name.lowercased() < $1.name.lowercased() }
                    self.images = images.sorted { $0.name.lowercased() < $1.name.lowercased() }
                })
        }
        
        func retry() {
            hasError = false
            getFolderContents()
        }
        
        func createFolderViewModel(from viewModelProvider: ViewModelProvider.SessionViewModelProvider) -> CreateNewFolderView.ViewModel {
            viewModelProvider.createFolderViewModel(currentFolderID: currentFolder.id) { inode in
                self.getFolderContents()
            }
        }
        
        func uploadImageViewModel(from viewModelProvider: ViewModelProvider.SessionViewModelProvider) -> UploadImageView.ViewModel {
            viewModelProvider.uploadImageViewModel(currentFolderID: currentFolder.id)
        }
        
        func deleteFolder(folderID: Inode.ID) {
            delete = folderContentsProvider
                .deleteFolder(folderID: folderID)
                .sink { completion in
                    switch completion {
                    case .failure:
                        self.hasError = true
                    case .finished:
                        self.hasError = false
                    }
                    
                } receiveValue: {
                    self.getFolderContents()
                }
        }
    }
}
