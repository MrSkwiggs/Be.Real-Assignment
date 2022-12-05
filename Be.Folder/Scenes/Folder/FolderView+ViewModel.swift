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
                .sink(receiveCompletion: { completion in
                    self.handleCompletion(completion)
                    self.fetch = nil
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
        
        func deleteItem(itemID: Inode.ID) {
            guard delete == nil else { return }
            delete = folderContentsProvider
                .deleteItem(itemID: itemID)
                .sink { completion in
                    self.handleCompletion(completion)
                    self.delete = nil
                } receiveValue: {
                    self.getFolderContents()
                }
        }
        
        private func handleCompletion(_ completion: Subscribers.Completion<Error>) {
            switch completion {
            case .finished:
                hasError = false
            case .failure:
                hasError = true
            }
        }
    }
}
