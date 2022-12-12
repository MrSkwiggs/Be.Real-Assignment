//
//  FileView.swift
//  Be.Folder
//
//  Created by Dorian on 30/11/2022.
//

import SwiftUI

/// Attempts to display a file's contents, whenever possible.
///
/// Supports Image & Text types, other raw data will be displayed in its Base64-decoded String form.
struct FileView: View {
    
    @StateObject
    var viewModel: ViewModel
    
    var body: some View {
        Group {
            if !viewModel.hasError {
                switch viewModel.fileData {
                case let .raw(data):
                    if let string = String(data: data, encoding: .utf8) {
                        text(from: string)
                    } else {
                        Text("Unable to show raw data")
                    }
                case let .text(string):
                    text(from: string)
                    
                case let .image(data):
                    if let uiImage = UIImage(data: data) {
                        image(from: uiImage)
                    } else {
                        Text("Corrupt image data")
                    }
                    
                case .none:
                    Text("Loading...")
                }
            } else {
                Text("Something went wrong")
            }
        }
        .navigationTitle(viewModel.navbarTitle)
    }
    
    private func image(from image: UIImage) -> some View {
        GeometryReader { proxy in
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: proxy.size.width, height: proxy.size.height)
                .clipShape(Rectangle())
                .modifier(ImageModifier(contentSize: CGSize(width: proxy.size.width, height: proxy.size.height)))
        }
    }
    
    private func text(from string: String) -> some View {
        ScrollView {
            Text(string)
        }
        .padding(.horizontal)
    }
}
