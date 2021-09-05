//
//  TODODetailedViewController.swift
//  TalanTest
//
//  Created by Vladislav Ivshin on 03.09.2021.
//

import UIKit
import SDWebImage

enum TODODetailedControllerType {
    case add
    case show(item: TODOItem)
}

class TODODetailedViewController: BaseViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    private var additionalFeatureBarButton: UIBarButtonItem?
    
    private var type: TODODetailedControllerType = .add
    
    private var item: TODOItem?
    private var imageData: ImageData? {
        didSet {
            if let imageData = self.imageData {
                if let data = imageData.imageData {
                    self.imageView.image = UIImage.init(data: data)
                } else {
                    self.imageView.sd_setImage(with: imageData.getImageURL(), placeholderImage: nil, completed: nil)
                }
            } else {
                DispatchQueue.main.async {
                    self.imageView.image = nil
                }
            }
        }
    }
    
    private var photoGallery: PhotoGallery = PhotoGallery.init()
    
    init(mainPageCoordinator: PageCoordinator, type: TODODetailedControllerType) {
        self.type = type
        
        super.init(mainPageCoordinator: mainPageCoordinator)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoGallery.observer = self
        
        setupNavBar()
        
        switch type {
        case .add:
            break
        case .show(let item):
            self.item = item
            setup(byTODOItem: item)
        }
    }
    
    func clear() {
        photoGallery.observer = nil
        
        item = nil
        imageData = nil
    }
    
    // MARK: Private
    
    private func setup(byTODOItem item: TODOItem) {
        titleTextField.text = item.title
        descTextView.text = item.desc
        
        if let imageData = item.imageData {
            self.imageData = imageData
        }
    }
    
    private func setupNavBar() {
        navigationItem.title = "Detailed"
        
        additionalFeatureBarButton = UIBarButtonItem.init(barButtonSystemItem: .edit,
                                                          target: self, action: #selector(additionalFeature))
        navigationItem.rightBarButtonItem = additionalFeatureBarButton
    }
    
    private func showImagePicker() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            showMessage(message: NSError.error(code: 103, localizedDesc: "Photo library unavailable").localizedDescription)
            return
        }
        
        photoGallery.authorizationStatus(completion: { [unowned self] status in
            switch status {
            case .authorized, .limited:
                DispatchQueue.main.async {
                    let imagePicker = UIImagePickerController.init()
                    imagePicker.delegate = self
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .photoLibrary
                
                    self.present(imagePicker, animated: true, completion: nil)
                }
            default:
                let okAction = AlertActionConfig.okAction()
                let settingsAction = AlertActionConfig.init(title: "Settings", isPreffered: true, style: .default) {
                    if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                    }
                }
                
                showAlert(title: "Photo library", message: "Need authorization permission for accessing photo libary to add image", actionConfigs: [okAction, settingsAction])
            }
        })
    }
    
    private func addItem(title: String, desc: String?) {
        if let imageData = self.imageData {
            self.startLoading()
            self.photoGallery.write(imageData: imageData) { isSuccess in
                self.imageData?.imageData = nil
                
                self.stopLoading()
                if isSuccess {
                    DBManager.shared.add(item: TODOItem.init(title: title,
                                                             desc: desc,
                                                             createDate: Date.init(),
                                                             doneDate: nil,
                                                             imageData: self.imageData,
                                                             isDone: false))
                    self.navigationController?.popViewController(animated: true)
                }
            }
        } else {
            DBManager.shared.add(item: TODOItem.init(title: title,
                                                     desc: desc,
                                                     createDate: Date.init(),
                                                     doneDate: nil,
                                                     imageData: self.imageData,
                                                     isDone: false))
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func updateItem(title: String, desc: String?) {
        if let item = self.item {
            if let imageData = self.imageData, imageData.imageName != item.imageData?.imageName {
                self.startLoading()
                self.photoGallery.write(imageData: imageData) { isSuccess in
                    self.imageData?.imageData = nil
                    
                    self.stopLoading()
                    if isSuccess {
                        item.update(title: title, desc: desc)
                        item.update(imageData: imageData)
                        
                        DBManager.shared.update(item: item)
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            } else {
                item.update(title: title, desc: desc)
                item.update(imageData: self.imageData)
                DBManager.shared.update(item: item)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    // MARK: Override
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        view.endEditing(true)
    }
    
    // MARK: Actions
    
    @objc func additionalFeature() {
        guard let title = titleTextField.text, !title.isEmpty else {
            showMessage(message: "Title required")
           return
        }
        let desc = descTextView.text.isEmpty ? nil : descTextView.text
        
        var mainActionTitle = "Update TODO"
        
        switch type {
        case .add:
            mainActionTitle = "Add TODO"
        case .show:
            break
        }
        
        var actions: [AlertActionConfig] = []
        let mainAction = AlertActionConfig.init(title: mainActionTitle, isPreffered: false) {
            switch self.type {
            case .add:
                self.addItem(title: title, desc: desc)
            case .show:
                self.updateItem(title: title, desc: desc)
            }
        }
        actions.append(mainAction)
        
        if imageData == nil {
            let addImage = AlertActionConfig.init(title: "Add image", isPreffered: false) {
                self.showImagePicker()
            }
            actions.append(addImage)
        } else {
            let changeImage = AlertActionConfig.init(title: "Change image", isPreffered: false) {
                self.showImagePicker()
            }
            let removeImage = AlertActionConfig.init(title: "Remove image", isPreffered: false) {
                self.imageData = nil
            }
            
            actions.append(contentsOf: [changeImage, removeImage])
        }
        
        let cancelAction = AlertActionConfig.cancelAction()
        actions.append(cancelAction)
        showAlert(title: nil, message: nil, actionConfigs: actions, style: .actionSheet)
    }
}

extension TODODetailedViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.delegate = nil
        picker.dismiss(animated: true, completion: nil)
        
        imageData = photoGallery.getImageData(fromInfo: info)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.delegate = nil
        picker.dismiss(animated: true, completion: nil)
    }
}

extension TODODetailedViewController: PhotoGalleryObserver {
    func failedWrite(imageData: ImageData, error: Error) {
        showMessage(message: "Cant save image \(error.localizedDescription)")
    }
    
    func failedRead(imageData: ImageData, error: Error) {
        showMessage(message: "Failed read image data \(imageData.imageName) \(error.localizedDescription)")
    }
}
