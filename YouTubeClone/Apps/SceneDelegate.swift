//
//  SceneDelegate.swift
//  YouTubeClone
//
//  Created by yujaehong on 3/25/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        let rootViewController: UIViewController
        
        if isLoggedIn {
            rootViewController = MainTabController()
        } else {
            let navigationController = UINavigationController(rootViewController: LoginViewController())
            rootViewController = navigationController
        }
        
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        self.window = window
    }
}

