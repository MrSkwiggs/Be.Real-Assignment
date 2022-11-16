//
//  LoginView.swift
//  Be.Folder
//
//  Created by Dorian on 16/11/2022.
//

import Core
import SwiftUI

struct LoginView: View {
    
    @StateObject
    var viewModel: ViewModel
    
    var body: some View {
        VStack {
            Image(systemName: "folder.fill.badge.person.crop")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 75, height: 75, alignment: .center)
                .foregroundColor(.accentColor)
            Text("Be.Folder")
                .font(.largeTitle)
                .bold()

            Form {
                Section {
                    Group {
                        TextField(text: $viewModel.username) {
                            Text("Username")
                        }
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        
                        SecureField(text: $viewModel.password) {
                            Text("Password")
                        }
                    }
                    .disabled(viewModel.isBusyLoggingIn)
                } header: {
                    Text("Credentials")
                }
                
                Section {
                    if let error = viewModel.error {
                        Text(error)
                            .font(.body)
                            .bold()
                            .foregroundColor(.red)
                    }
                    Button {
                        viewModel.userDidTapLoginButton()
                    } label: {
                        if viewModel.isBusyLoggingIn {
                            ProgressView()
                                .progressViewStyle(.circular)
                        } else {
                            Text("Login")
                        }
                    }
                    .disabled(!viewModel.canLogin || viewModel.isBusyLoggingIn)
                }
            }
        }
    }
}

struct CheckBoxView: View {
    @Binding var checked: Bool

    var body: some View {
        Image(systemName: checked ? "checkmark.square.fill" : "square")
            .foregroundColor(checked ? .accentColor : .secondary)
            .onTapGesture {
                self.checked.toggle()
            }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: .init(loginProvider: Mock.LoginProvider()))
    }
}
