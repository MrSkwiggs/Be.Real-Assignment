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
    
    /// A view model provider for app sessions, where an authenticated composition object is used as a dependency.
    class SessionViewModelProvider: ObservableObject {
        private let root: AuthenticatedComposition
        
        init(root: AuthenticatedComposition) {
            self.root = root
        }
        
        /// Provides a FolderView ViewModel for the user's Root Folder
        var rootFolderViewModel: FolderView.ViewModel {
            .init(folder: root.session.user.rootFolder, folderContentsProvider: root.folderContentsProvider)
        }
        
        /// Provides a FolderView ViewModel for the given folder.
        /// - parameters:
        ///     - folder: The folder for which we need the view model.
        ///     - breadcrumbs: The path/breadcrumb trail of the folder, with regards to its parent (and its parent's parent, etc.). Should use folder names separated by `/`, i.e `"rootFolder / subFolder / subFolder2"`
        ///
        func folderContentsViewModel(for folder: Inode, breadcrumbs: String) -> FolderView.ViewModel {
            .init(folder: folder, folderContentsProvider: root.folderContentsProvider, breadcrumbs: breadcrumbs)
        }
        
        /// Provides a FileView ViewModel for the given file
        func fileDataViewModel(file: Networking.File) -> FileView.ViewModel {
            .init(file: file, fileDataProvider: root.fileDataProvider)
        }
        
        /// Provides a CreateNewFolderView ViewModel
        func createFolderViewModel(currentFolderID: String, then callback: @escaping (Inode?) -> Void) -> FolderView.CreateNewFolderView.ViewModel {
            .init(currentFolderID: currentFolderID, folderRepository: root.folderContentsProvider, onFolderCreated: callback)
        }
        
        /// Provides a UploadImageView ViewModel
        func uploadImageViewModel(currentFolderID: String, then callback: @escaping () -> Void) -> FolderView.UploadImageView.ViewModel {
            .init(currentFolderID: currentFolderID, folderRepository: root.folderContentsProvider, then: callback)
        }
    }
}
