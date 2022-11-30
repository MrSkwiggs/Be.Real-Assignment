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
                    ForEach(Array(viewModel.folders.keys), id: \.self) { key in
                        NavigationLink {
                            FolderView(viewModel: viewModelProvider.folderContentsViewModel(folderID: key))
                        } label: {
                            Text(viewModel.folders[key] ?? key)
                        }
                    }
                }
            }
            
            if !viewModel.images.isEmpty {
                Section("Images") {
                    ForEach(Array(viewModel.images.keys), id: \.self) { key in
                        NavigationLink {
                            ImageView(viewModel: viewModelProvider.imageDataViewModel(imageID: key))
                        } label: {
                            Text(viewModel.images[key] ?? key)
                        }
                    }
                }
            }
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
