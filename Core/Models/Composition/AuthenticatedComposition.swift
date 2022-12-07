//
//  AuthenticatedComposition.swift
//  Core
//
//  Created by Dorian on 07/12/2022.
//

import Foundation

public class AuthenticatedComposition: Composition {
    
    public let session: Session
    
    public let folderContentsProvider: FolderRepositoryContract
    public let fileDataProvider: FileDataContract
    
    internal init(super: Composition,
                  session: Session,
                  folderContentsProvider: FolderRepositoryContract,
                  fileDataProvider: FileDataContract) {
        self.session = session
        self.folderContentsProvider = folderContentsProvider
        self.fileDataProvider = fileDataProvider
        super.init(loginProvider: `super`.loginProvider, compositionFactory: `super`.compositionFactory)
    }
}

public extension Mock {
    static let authenticatedComposition: AuthenticatedComposition = .init(super: Mock.composition,
                                                                          session: Mock.session,
                                                                          folderContentsProvider: Mock.FolderRepository(),
                                                                          fileDataProvider: Mock.FileDataProvider())
}
