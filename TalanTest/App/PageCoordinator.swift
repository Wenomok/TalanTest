//
//  PageCoordinator.swift
//  TalanTest
//
//  Created by Vladislav Ivshin on 03.09.2021.
//

import UIKit

class PageCoordinator: NSObject {
    let window: UIWindow
    
    private var navigationController: UINavigationController!
    private var splashViewController: SplashViewController?
    
    private var todoListViewController: TODOListViewController?
    private var detailedViewController: TODODetailedViewController?
    
    override init() {
        window = UIWindow.init(frame: UIScreen.main.bounds)
        
        super.init()
        
        let splashViewController = SplashViewController.init(mainPageCoordinator: self)
        splashViewController.delegate = self
        self.splashViewController = splashViewController
        
        navigationController = UINavigationController.init(rootViewController: splashViewController)
        navigationController.delegate = self
    }
    
    func launchApp() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func pushDetails(type: TODODetailedControllerType) {
        let todoDetailedViewController = TODODetailedViewController.init(mainPageCoordinator: self, type: type)
        navigationController.pushViewController(todoDetailedViewController, animated: true)
        
        self.detailedViewController = todoDetailedViewController
    }
    
    private func launchMainViewController() {
        if todoListViewController == nil {
            let todoListViewController = TODOListViewController.init(mainPageCoordinator: self)
            navigationController.setViewControllers([todoListViewController], animated: true)
            
            self.todoListViewController = todoListViewController
        }
    }
}

extension PageCoordinator: SplashViewControllerDelegate {
    func launchDidFinish() {
        DispatchQueue.main.async { [unowned self] in
            launchMainViewController()
            
            splashViewController?.delegate = nil
        }
    }
}

extension PageCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController.isKind(of: TODOListViewController.self) {
            detailedViewController?.clear()
            detailedViewController = nil
        }
    }
}
