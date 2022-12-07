//
//  CompositionFactory.swift
//  Core
//
//  Created by Dorian on 07/12/2022.
//

import Foundation

class CompositionFactory: CompositionFactoryContract {
    func authenticatedComposition(from session: Session, with root: Composition) -> AuthenticatedComposition {
        .init(super: root,
              session: session,
              folderContentsProvider: FolderRepository(token: session.token),
              fileDataProvider: FileDataProvider(token: session.token))
    }
}

extension Mock {
    class CompositionFactory: CompositionFactoryContract {
        func authenticatedComposition(from session: Session, with root: Composition) -> AuthenticatedComposition {
            .init(super: root,
                  session: session,
                  folderContentsProvider: Mock.FolderRepository(),
                  fileDataProvider: Mock.FileDataProvider())
        }
    }
}
