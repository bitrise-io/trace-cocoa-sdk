//
//  SceneDelegate.swift
//  SwiftUIDemo
//
//  Created by Shams Ahmed on 24/08/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import UIKit
import SwiftUI

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // MARK: - Property
    
    var window: UIWindow?

    // MARK: - UIWindowSceneDelegate
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        print("DEMO - will connect to session")
        
        if let windowScene = scene as? UIWindowScene {
            let view = ContentView()
            
            window = UIWindow(windowScene: windowScene)
            window?.rootViewController = UIHostingController(rootView: view)
            window?.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        print("DEMO - scene did disconnect")
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        print("DEMO - scene did become active")
    }

    func sceneWillResignActive(_ scene: UIScene) {
        print("DEMO - scene will resign active")
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        print("DEMO - scene will enter foreground")
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        print("DEMO - scene did enter background")
    }
}
