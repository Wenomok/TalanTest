//
//  BaseViewController.swift
//  TalanTest
//
//  Created by Vladislav Ivshin on 03.09.2021.
//

import UIKit

struct AlertActionConfig {
    var title: String
    var color: UIColor?
    var isPreffered: Bool
    var style: UIAlertAction.Style = .default
    
    var completion: (() -> ())?
    
    static func okAction() -> AlertActionConfig {
        return AlertActionConfig.init(title: "OK", color: .systemBlue,
                                      isPreffered: true, completion: nil)
    }
    
    static func cancelAction() -> AlertActionConfig {
        return AlertActionConfig.init(title: "Cancel", color: .systemBlue,
                                      isPreffered: false, style: .cancel, completion: nil)
    }
}

class BaseViewController: UIViewController {
    private(set) var mainPageCoordinator: PageCoordinator
    
    private var loaderView: LoaderView?

    init(mainPageCoordinator: PageCoordinator) {
        self.mainPageCoordinator = mainPageCoordinator
        
        let nibName = String.init(describing: type(of: self))
        
        super.init(nibName: nibName, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        mainPageCoordinator = PageCoordinator.init()
        
        super.init(coder: coder)
    }
    
    func showAlert(title: String?, message: String?, actionConfigs: [AlertActionConfig], style: UIAlertController.Style = .alert) {
        DispatchQueue.main.async { [unowned self] in
            let alertController = UIAlertController.init(title: title, message: message, preferredStyle: style)
            for actionConfig in actionConfigs {
                let action = UIAlertAction.init(title: actionConfig.title, style: actionConfig.style) { (action) in
                    actionConfig.completion?()
                }
                if let actionTitleColor = actionConfig.color {
                    action.setValue(actionTitleColor, forKey: "titleTextColor")
                }
                
                alertController.addAction(action)
                
                if actionConfig.isPreffered {
                    alertController.preferredAction = action
                }
            }
        
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func showMessage(message: String, numberOfLines: Int = 3, duration: TimeInterval = 3.0) {
        ToastView.show(message: message, numberOfLines: numberOfLines, duration: duration)
    }
    
    func showErrorMessage(error: NSError, numberOfLines: Int = 3, duration: TimeInterval = 3.0) {
        ToastView.show(errorMessage: error, numberOfLines: numberOfLines, duration: duration)
    }
    
    func startLoading() {
        DispatchQueue.main.async {
            let loaderView = LoaderView.init(frame: .zero)
            if let baseView = UIApplication.shared.keyWindow?.rootViewController?.view {
                loaderView.startLoading(superView: baseView)
            } else {
                loaderView.startLoading(superView: self.view)
            }
            
            
            self.loaderView = loaderView
        }
    }
    
    func stopLoading() {
        DispatchQueue.main.async {
            self.loaderView?.stopLoading()
            self.loaderView = nil
        }
    }
}
