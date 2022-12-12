//
//  ViewModelProvider+SessionViewModelProvider.swift
//  Be.Folder
//
//  Created by Dorian on 12/12/2022.
//

import Foundation
import Core
import Networking

extension ViewModelProvider {
    class SessionViewModelProvider: ObservableObject {
        private let root: AuthenticatedComposition
        
        init(root: AuthenticatedComposition) {
            self.root = root
        }
        
        var rootFolderViewModel: FolderView.ViewModel {
            .init(folder: root.session.user.rootFolder, folderContentsProvider: root.folderContentsProvider)
        }
        
        func folderContentsViewModel(for folder: Inode, breadcrumbs: String) -> FolderView.ViewModel {
            .init(folder: folder, folderContentsProvider: root.folderContentsProvider, breadcrumbs: breadcrumbs)
        }
        
        func fileDataViewModel(file: Networking.File) -> FileView.ViewModel {
            .init(file: file, fileDataProvider: root.fileDataProvider)
        }
        
        func createFolderViewModel(currentFolderID: String, then callback: @escaping (Inode?) -> Void) -> FolderView.CreateNewFolderView.ViewModel {
            .init(currentFolderID: currentFolderID, folderRepository: root.folderContentsProvider, onFolderCreated: callback)
        }
        
        func uploadImageViewModel(currentFolderID: String, then callback: @escaping () -> Void) -> FolderView.UploadImageView.ViewModel {
            .init(currentFolderID: currentFolderID, folderRepository: root.folderContentsProvider, then: callback)
        }
    }
}
