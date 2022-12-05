//
//  FolderView+UploadImageView.swift
//  Be.Folder
//
//  Created by Dorian on 30/11/2022.
//

import SwiftUI
import PhotosUI

extension FolderView {
    struct UploadImageView: View {
        @StateObject
        var viewModel: ViewModel
        
        @Environment(\.dismiss)
        var dismiss
        
        var body: some View {
            Form {
                Section {
                    if let uiImage = viewModel.selectedImage {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 250, height: 250)
                    } else {
                        HStack(alignment: .center) {
                            Spacer()
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 150)
                                .opacity(0.2)
                            Spacer()
                        }
                        .frame(height: 250)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                            .fill(Color.gray.opacity(0.3))
                        )
                    }
                    PhotosPicker(
                        selection: .init(get: {
                            nil
                        }, set: { item in
                            guard let item else { return }
                            viewModel.userDidPick(photo: item)
                        }),
                        matching: .images,
                        photoLibrary: .shared()) {
                            Text("Select a photo")
                        }
                }
                
                Section {
                    TextField(text: $viewModel.name) {
                        Text("Image name")
                    }
                }
                
                Section {
                    Button {
                        viewModel.uploadPhoto {
                            self.dismiss()
                        }
                    } label: {
                        Text("Upload")
                    }
                    .disabled(viewModel.canUpload)
                }
            }
        }
    }
}

struct UploadImageView_Previews: PreviewProvider {
    static var previews: some View {
        FolderView.UploadImageView(viewModel: .init(currentFolderID: "", folderRepository: .init(token: "")))
    }
}
