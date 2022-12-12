//
//  FolderView+CreateNewFolderView.swift
//  Be.Folder
//
//  Created by Dorian on 30/11/2022.
//

import SwiftUI
import Core

extension FolderView {
    /// A modal view that allows the user to create a new folder
    struct CreateNewFolderView: View {
        
        @StateObject
        var viewModel: ViewModel
        
        @Environment(\.dismiss)
        var dismiss
        
        var body: some View {
            Form {
                Section("Create New Folder") {
                    TextField(text: $viewModel.folderName) {
                        Text("Folder name")
                    }
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .searchSuggestions(.hidden, for: .menu)
                }
                
                Section {
                    Button {
                        viewModel.createFolder {
                            self.dismiss()
                        }
                    } label: {
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(.circular)
                        } else {
                            Text("Save")
                        }
                    }
                    .disabled(!viewModel.canCreateFolder)
                }
                
                if let error = viewModel.error {
                    Section {
                        Text(error)
                            .font(.footnote)
                            .foregroundColor(.red)
                    }
                    .animation(.default, value: viewModel.error)
                }
            }
        }
    }
}

struct CreateNewFolder_Previews: PreviewProvider {
    static var previews: some View {
        FolderView.CreateNewFolderView(viewModel:
                .init(currentFolderID: "123", folderRepository: Mock.FolderRepository(), onFolderCreated: { _ in
            //
        }))
    }
}
