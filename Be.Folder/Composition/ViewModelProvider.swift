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
        .init(session: session, root: root)
    }
}

extension ViewModelProvider {
    class SessionViewModelProvider: ObservableObject {
        private let session: Session
        private let root: Composition
        private let folderContentsProvider: FolderRepository
        private let fileDataProvider: FileDataProvider
        
        init(session: Session, root: Composition) {
            self.session = session
            self.root = root
            self.folderContentsProvider = .init(token: session.token)
            self.fileDataProvider = .init(token: session.token)
        }
        
        var rootFolderViewModel: FolderView.ViewModel {
            .init(folder: session.user.rootFolder, folderContentsProvider: folderContentsProvider)
        }
        
        func folderContentsViewModel(for folder: Inode, breadcrumbs: String) -> FolderView.ViewModel {
            .init(folder: folder, folderContentsProvider: folderContentsProvider, breadcrumbs: breadcrumbs)
        }
        
        func fileDataViewModel(file: File) -> FileView.ViewModel {
            .init(file: file, fileDataProvider: fileDataProvider)
        }
        
        func createFolderViewModel(currentFolderID: String, then callback: @escaping (Inode?) -> Void) -> FolderView.CreateNewFolderView.ViewModel {
            .init(currentFolderID: currentFolderID, folderRepository: folderContentsProvider, onFolderCreated: callback)
        }
        
        func uploadImageViewModel(currentFolderID: String) -> FolderView.UploadImageView.ViewModel {
            .init(currentFolderID: currentFolderID, folderRepository: folderContentsProvider)
        }
    }
}
