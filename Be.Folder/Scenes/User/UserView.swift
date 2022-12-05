//
//  UserView.swift
//  Be.Folder
//
//  Created by Dorian on 05/12/2022.
//

import SwiftUI
import Networking

struct UserView: View {
    
    let user: User
    
    var body: some View {
        List {
            Section("User") {
                
                Text(user.firstName)
                Text(user.lastName)
            }
            
            Section("Root Folder") {
                Text(user.rootFolder.name)
            }
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView(user: Mock.user)
    }
}
