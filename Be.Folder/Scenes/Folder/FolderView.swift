//
//  FolderView.swift
//  Be.Folder
//
//  Created by Dorian on 16/11/2022.
//

import SwiftUI

struct FolderView: View {
    
    @StateObject
    var viewModel: ViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.contents, id: \.self) { content in
                Text(content)
            }
        }
    }
}

//struct FolderView_Previews: PreviewProvider {
//    static let vmp = ViewModelProvider(root: .mock())
////    static let svmp = vmp.sessionViewModelProvider(session: )
//    
//    static var previews: some View {
//        FolderView(viewModel: vmp.)
//    }
//}
