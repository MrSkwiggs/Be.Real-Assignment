//
//  RootFolderView+ViewModel.swift
//  Be.Folder
//
//  Created by Dorian on 16/11/2022.
//

import Foundation
import Combine
import Core

extension RootFolderView {
    class ViewModel: ObservableObject {
        
        private let currentFolderID: String
        private let folderContentsProvider: FolderContentsProvider
        
        @Published
        var contents: [String: String] = [:]
        
        private var fetch: AnyCancellable?
        
        init(folderID: String, folderContentsProvider: FolderContentsProvider) {
            self.currentFolderID = folderID
            self.folderContentsProvider = folderContentsProvider
            
            fetch = folderContentsProvider
                .fetchFolderContents(folderID: currentFolderID)
                .sink { contents in
                    self.contents = contents.reduce(into: [String: String](), { partialResult, inode in
                        partialResult[inode.id] = inode.name
                    })
                }
        }
    }
}
