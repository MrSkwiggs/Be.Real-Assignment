//
//  SceneDelegate.swift
//  Be.Folder
//
//  Created by Dorian on 16/11/2022.
//

import SwiftUI
import Core

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        /// Uncomment one of the two next lines to switch between production app composition and mock app composition
        let viewModelProvider = ViewModelProvider(root: .main)
//        let viewModelProvider = ViewModelProvider(root: Mock.composition)
        
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
