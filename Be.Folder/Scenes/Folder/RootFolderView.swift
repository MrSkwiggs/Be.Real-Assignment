//
//  RootFolderView.swift
//  Be.Folder
//
//  Created by Dorian on 16/11/2022.
//

import SwiftUI

struct RootFolderView: View {
    
    @EnvironmentObject
    var viewModelProvider: ViewModelProvider.SessionViewModelProvider
    
    @StateObject
    var viewModel: ViewModel
    
    var body: some View {
        List {
            ForEach(Array(viewModel.contents.keys), id: \.self) { key in
                NavigationLink {
                    RootFolderView(viewModel: viewModelProvider.folderContentsViewModel(folderID: key))
                } label: {
                    Text(viewModel.contents[key] ?? key)
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
//        RootFolderView(viewModel: vmp.sessionViewModelProvider(session: <#T##Session#>))
//    }
//}
