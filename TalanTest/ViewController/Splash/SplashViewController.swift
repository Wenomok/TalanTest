//
//  SplashViewController.swift
//  TalanTest
//
//  Created by Vladislav Ivshin on 03.09.2021.
//

import UIKit

protocol SplashViewControllerDelegate {
    func launchDidFinish()
}

class SplashViewController: BaseViewController {
    var delegate: SplashViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        PhotoGallery.prepare()
        DBManager.shared.prepareDB { [unowned self] isError in
            if !isError {
                PhotoGallery.deleteUnusedImages(usedImageNames: DBManager.shared.getUsedImageNames()) {
                    delegate?.launchDidFinish()
                }
            } else {
                showMessage(message: "Error prepare Database")
            }
        }
        
        navigationController?.navigationBar.isHidden = true
    }
}
