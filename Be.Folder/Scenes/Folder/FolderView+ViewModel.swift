//
//  FolderView+ViewModel.swift
//  Be.Folder
//
//  Created by Dorian on 16/11/2022.
//

import Foundation
import Combine
import Core

extension FolderView {
    class ViewModel: ObservableObject {
        
        let session: Session
        
        @Published
        var contents: [String] = []
        
        private var fetch: AnyCancellable?
        
        init(session: Session) {
            self.session = session
            
            fetch = FolderContentsProvider()
                .fetchContents(for: session)
                .sink { contents in
                    self.contents = contents
                }
        }
    }
}
