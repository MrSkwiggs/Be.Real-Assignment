//
//  FolderView.swift
//  Be.Folder
//
//  Created by Dorian on 16/11/2022.
//

import SwiftUI

struct FolderView: View {
    
    @EnvironmentObject
    var viewModelProvider: ViewModelProvider.SessionViewModelProvider
    
    @StateObject
    var viewModel: ViewModel
    
    @State
    var showFolderCreationSheet: Bool = false
    
    @State
    var showUploadFileSheet: Bool = false
    
    var body: some View {
        List {
            if viewModel.hasError {
                Section {
                    Text("Something went wrong")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                    Button {
                        viewModel.retry()
                    } label: {
                        Text("Please try again")
                    }
                }
            }
            if !viewModel.folders.isEmpty {
                Section("Folders") {
                    ForEach(viewModel.folders) { folder in
                        NavigationLink {
                            FolderView(viewModel: viewModelProvider.folderContentsViewModel(for: folder, breadcrumbs: viewModel.breadcrumbs))
                        } label: {
                            Text(folder.name)
                        }
                    }
                    .onDelete { indices in
                        guard let index = indices.first,
                              viewModel.folders.indices.contains(index) else { return }
                        viewModel.deleteFolder(folderID: viewModel.folders[index].id)
                    }
                }
            } else {
                Text("No folders here...")
            }
            
            if !viewModel.images.isEmpty {
                Section("Images") {
                    ForEach(viewModel.images) { image in
                        NavigationLink {
                            ImageView(viewModel: viewModelProvider.imageDataViewModel(imageID: image.id))
                        } label: {
                            Text(image.name)
                        }
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: {
            ToolbarItem(placement: .principal) {
                Text(viewModel.breadcrumbs).truncationMode(.head)
            }
            ToolbarItem {
                Button {
                    showFolderCreationSheet = true
                } label: {
                    Image(systemName: "folder.badge.plus")
                }
            }
            
            ToolbarItem {
                Button {
                    showUploadFileSheet = true
                } label: {
                    Image(systemName: "doc.badge.plus")
                }
            }
        })
        .sheet(isPresented: $showFolderCreationSheet) {
            CreateNewFolderView(viewModel: viewModel.createFolderViewModel(from: viewModelProvider))
                .presentationDetents([.medium])
        }
        .sheet(isPresented: $showUploadFileSheet) {
            UploadImageView(viewModel: viewModel.uploadImageViewModel(from: viewModelProvider))
        }
    }
}

//struct FolderView_Previews: PreviewProvider {
//    static let vmp = ViewModelProvider.SessionViewModelProvider.init(session: <#T##Session#>, root: <#T##Composition#>)
////    static let svmp = vmp.sessionViewModelProvider(session: )
//
//    static var previews: some View {
//        FolderView(viewModel: vmp.sessionViewModelProvider(session: <#T##Session#>))
//    }
//}
