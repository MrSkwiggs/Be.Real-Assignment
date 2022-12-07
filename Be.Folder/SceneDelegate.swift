//
//  SceneDelegate.swift
//  Be.Folder
//
//  Created by Dorian on 16/11/2022.
//

import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        let viewModelProvider = ViewModelProvider(root: .main)
        
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            let rootView = RootView(viewModel: viewModelProvider.rootViewModel)
                .environmentObject(viewModelProvider)
            window.rootViewController = UIHostingController(rootView: rootView)
            
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
