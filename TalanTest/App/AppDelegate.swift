//
//  AppDelegate.swift
//  TalanTest
//
//  Created by Vladislav Ivshin on 03.09.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    private var pageCoordinator: PageCoordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        debugPrint(FileManager.default.cachedImagesURL()?.path ?? "error")
        
        pageCoordinator = PageCoordinator.init()
        pageCoordinator.launchApp()
        
        return true
    }
}

