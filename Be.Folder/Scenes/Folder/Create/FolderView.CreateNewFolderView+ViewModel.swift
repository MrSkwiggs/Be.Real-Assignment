//
//  FolderView.CreateNewFolderView+ViewModel.swift
//  Be.Folder
//
//  Created by Dorian on 30/11/2022.
//

import Foundation
import Combine
import Core
import Networking

extension FolderView.CreateNewFolderView {
    /// The ViewModel of a CreateNewFolderView
    class ViewModel: ObservableObject {
        /// Whether or not the new folder's name is valid.
        @Published
        var isNameValid: Bool = true
        
        /// Whether or not the user is allowed to tap the create folder button.
        @Published
        var canCreateFolder: Bool = false
        
        /// The new folder's name.
        @Published
        var folderName: String = ""
        
        /// Whether or not the view model is busy with creating the folder.
        @Published
        var isLoading: Bool = false
        
        /// Whether or not the view model ran into an error while creating the folder.
        @Published
        var error: String?
        
        private let onFolderCreated: (Inode?) -> Void
        private let folderRepository: FolderRepositoryContract
        private let currentFolderID: String
        private var subscriptions: [AnyCancellable] = []
        
        func createFolder(then callback: @escaping () -> Void) {
            guard canCreateFolder else { return }
            isLoading = true
            
            folderRepository
                .createFolder(name: folderName, parentFolderID: currentFolderID)
                .sink { completion in
                    self.isLoading = false
                    
                    switch completion {
                    case .finished:
                        break
                    case .failure:
                        self.error = "Something went wrong. Please try again"
                    }
                } receiveValue: { inode in
                    callback()
                    self.onFolderCreated(inode)
                }
                .store(in: &subscriptions)
        }
        
        init(currentFolderID: String, folderRepository: FolderRepositoryContract, onFolderCreated: @escaping (Inode?) -> Void) {
            self.currentFolderID = currentFolderID
            self.folderRepository = folderRepository
            self.onFolderCreated = onFolderCreated
            
            setupSubscriptions()
        }
        
        private func setupSubscriptions() {
            $folderName
                .sink { name in
                    guard name.firstMatch(of: /^[^\.\/\\\:].*[^\/\\\:].*$/) != nil else {
                        self.isNameValid = false
                        self.canCreateFolder = false
                        return
                    }
                    self.isNameValid = true
                    self.canCreateFolder = !name.isEmpty
                }
                .store(in: &subscriptions)
        }
    }
}
