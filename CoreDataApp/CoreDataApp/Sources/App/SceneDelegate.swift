//
//  SceneDelegate.swift
//  CoreDataApp
//
//  Created by Daniil Yarkovenko on 30.06.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }

        //root controller
        let viewController = TableViewController()
        let navController = UINavigationController(rootViewController: viewController)
        let config = UIImage.SymbolConfiguration(weight: .light)

        // set backButton image and some navBar config
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.systemBackground]
        appearance.setBackIndicatorImage(UIImage(systemName: "xmark", withConfiguration: config), transitionMaskImage: UIImage(systemName: "xmark"))
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance

        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }
}

