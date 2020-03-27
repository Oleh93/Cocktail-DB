//
//  AppDelegate.swift
//  Cocktail DB
//
//  Created by Oleh Mykytyn on 26.03.2020.
//  Copyright © 2020 Oleh Mykytyn. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private var applicationCoordinator: ApplicationCoordinator!

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow(frame: UIScreen.main.bounds)
        let navController = UINavigationController()

        applicationCoordinator = ApplicationCoordinator(navigationController: navController)

        window.rootViewController = navController
        window.makeKeyAndVisible()

        self.applicationCoordinator.start()
        self.window = window

        return true
    }
    
    private func configureAppearance() {
        // Navigation bar setup
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.barTintColor = .black
    }
}
