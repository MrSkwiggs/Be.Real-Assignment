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
            NavigationView {
                VStack {
                    FolderView(viewModel: viewModelProvider.sessionViewModelProvider(session: session).rootFolderViewModel)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                NavigationLink(destination: {
                                    UserView(user: session.user)
                                }, label: {
                                    Image(systemName: "person.crop.circle")
                                })
                            }
                        }
                }
            }
            .environmentObject(viewModelProvider.sessionViewModelProvider(session: session))
        } else {
            LoginView(viewModel: viewModelProvider.loginViewModel)
        }
    }
}

struct RootView_Previews: PreviewProvider {
    
    static let viewModelProvider = ViewModelProvider(root: Mock.composition)
    
    static var previews: some View {
        RootView(viewModel: viewModelProvider.rootViewModel)
            .environmentObject(ViewModelProvider(root: Mock.composition))
    }
}
