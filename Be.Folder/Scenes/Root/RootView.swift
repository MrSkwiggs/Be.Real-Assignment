//
//  RootView.swift
//  Be.Folder
//
//  Created by Dorian on 16/11/2022.
//

import SwiftUI
import Core

struct RootView: View {
    
    @EnvironmentObject
    var viewModelProvider: ViewModelProvider
    
    @StateObject
    var viewModel: ViewModel
    
    var body: some View {
        if let session = viewModel.session {
            VStack {
                Text("Logged in")
                Text("User: \(session.user.firstName) \(session.user.lastName)")
                Text("RootFolder: \(session.user.rootFolder.name)")
                FolderView(viewModel: viewModelProvider.sessionViewModelProvider(session: session).folderContentsViewModel)
            }
            .environmentObject(viewModelProvider.sessionViewModelProvider(session: session))
        } else {
            LoginView(viewModel: viewModelProvider.loginViewModel)
        }
    }
}

struct RootView_Previews: PreviewProvider {
    
    static let viewModelProvider = ViewModelProvider(root: .mock())
    
    static var previews: some View {
        RootView(viewModel: viewModelProvider.rootViewModel)
            .environmentObject(ViewModelProvider(root: .mock()))
    }
}
