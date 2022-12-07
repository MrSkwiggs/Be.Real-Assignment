//
//  ViewModelProvider.swift
//  Be.Folder
//
//  Created by Dorian on 16/11/2022.
//

import Foundation
import Combine
import Core
import Networking

class ViewModelProvider: ObservableObject {
    private let root: Composition
    
    init(root: Composition) {
        self.root = root
    }
    
    var rootViewModel: RootView.ViewModel {
        .init(loginProvider: root.loginProvider)
    }
    
    var loginViewModel: LoginView.ViewModel {
        .init(loginProvider: root.loginProvider)
    }
    
    func sessionViewModelProvider(session: Session) -> SessionViewModelProvider {
        .init(root: root.authenticatedComposition(for: session))
    }
}

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
