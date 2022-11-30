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
        private let imageDataProvider: ImageDataProvider
        
        init(session: Session, root: Composition) {
            self.session = session
            self.root = root
            self.folderContentsProvider = .init(token: session.token)
            self.imageDataProvider = .init(token: session.token)
        }
        
        var rootFolderViewModel: FolderView.ViewModel {
            .init(folderID: session.user.rootFolder.id, folderContentsProvider: folderContentsProvider)
        }
        
        func folderContentsViewModel(folderID: String) -> FolderView.ViewModel {
            .init(folderID: folderID, folderContentsProvider: folderContentsProvider)
        }
        
        func imageDataViewModel(imageID: String) -> ImageView.ViewModel {
            .init(imageID: imageID, imageDataProvider: imageDataProvider)
        }
        
        func createFolderViewModel(currentFolderID: String, then callback: @escaping (Inode?) -> Void) -> FolderView.CreateNewFolderView.ViewModel {
            .init(currentFolderID: currentFolderID, folderRepository: folderContentsProvider, onFolderCreated: callback)
        }
        
        func uploadImageViewModel(currentFolderID: String) -> FolderView.UploadImageView.ViewModel {
            .init(currentFolderID: currentFolderID, folderRepository: folderContentsProvider)
        }
    }
}
