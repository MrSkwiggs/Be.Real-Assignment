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
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: RootView())
            
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
