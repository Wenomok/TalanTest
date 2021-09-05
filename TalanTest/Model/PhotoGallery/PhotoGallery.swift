//
//  PhotoGallery.swift
//  TalanTest
//
//  Created by Vladislav Ivshin on 04.09.2021.
//

import UIKit
import Photos

private let imageCacheDirectory = ""

protocol PhotoGalleryObserver {
    func failedWrite(imageData: ImageData, error: Error)
    func failedRead(imageData: ImageData, error: Error)
}

class PhotoGallery: NSObject {
    var observer: PhotoGalleryObserver?
    
    static func prepare() {
        let fileManager = FileManager.default
        
        var isDirectory: ObjCBool = true
        if let cacheDirectoryURL = fileManager.cachedImagesURL(), !fileManager.fileExists(atPath: cacheDirectoryURL.path, isDirectory: &isDirectory) {
            do {
                try fileManager.createDirectory(at: cacheDirectoryURL,
                                            withIntermediateDirectories: false,
                                            attributes: nil)
            } catch(let error) {
                debugPrint("Failed create image cache directory \(error.localizedDescription)")
            }
        }
    }
    
    static func deleteUnusedImages(usedImageNames: [String], completion: (() -> ())?) {
        DispatchQueue.init(label: "write_image").async {
            do {
                let fileManager = FileManager.default
                
                guard let cachedImagesURL = fileManager.cachedImagesURL() else {
                    return
                }
                
                let contents = try fileManager.contentsOfDirectory(at: cachedImagesURL, includingPropertiesForKeys: nil, options: .skipsSubdirectoryDescendants)
                let cachedImageNames = contents.map({ $0.deletingPathExtension().lastPathComponent })
                
                for cachedImageName in cachedImageNames {
                    if !usedImageNames.contains(cachedImageName) {
                        let imageURL = cachedImagesURL.appendingPathComponent(cachedImageName.appending(".png"))
                        
                        do {
                            try fileManager.removeItem(at: imageURL)
                        } catch(let error) {
                            debugPrint(error.localizedDescription)
                        }
                    }
                }
                
                completion?()
            } catch(let error) {
                debugPrint(error.localizedDescription)
                completion?()
            }
        }
    }
    
    func getImage(imageData: ImageData, compressionQuality: CGFloat = 1.0, completion: ((UIImage?) -> ())?) {
        guard let imageURL = FileManager.default.cachedImagesURL()?.appendingPathComponent("\(imageData.imageName).png") else {
            completion?(nil)
            return
        }
        
        DispatchQueue.init(label: "write_image", qos: .background).async {
            do {
                let data = try Data.init(contentsOf: imageURL)
                if compressionQuality == 1.0 {
                    completion?(UIImage.init(data: data))
                } else {
                    if let image = UIImage.init(data: data),
                       let compressedImageData = image.jpegData(compressionQuality: compressionQuality) {
                        completion?(UIImage.init(data: compressedImageData))
                    } else {
                        completion?(nil)
                    }
                }
                
            } catch(let error) {
                self.observer?.failedRead(imageData: imageData, error: error)
                completion?(nil)
            }
        }
    }
    
    func write(imageData: ImageData, completion: ((Bool) -> ())?) {
        guard let data = imageData.imageData else {
            observer?.failedWrite(imageData: imageData, error: NSError.noDataToWrite)
            return
        }
        
        DispatchQueue.init(label: "write_image").async {
            do {
                try data.writeToCachedImages(withName: imageData.imageName)
                DispatchQueue.main.async {
                    completion?(true)
                }
            } catch(let error) {
                self.observer?.failedWrite(imageData: imageData, error: error)
                DispatchQueue.main.async {
                    completion?(false)
                }
            }
        }
    }
    
    func getImageData(fromInfo info: [UIImagePickerController.InfoKey: Any]) -> ImageData? {
        if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
           let asset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset {
            let imageData = ImageData.init(imageName: "\((asset.creationDate ?? Date.init()) .timeIntervalSince1970)")
            imageData.imageData = originalImage.jpegData(compressionQuality: 0.5)
            return imageData
        } else {
            return nil
        }
    }
    
    func authorizationStatus(completion: ((PHAuthorizationStatus) -> ())?) {
        if #available(iOS 14, *) {
            let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
            
            if status == .notDetermined {
                PHPhotoLibrary.requestAuthorization(for: .readWrite) { libraryStatus in
                    completion?(libraryStatus)
                }
            } else {
                completion?(status)
            }
        } else {
            let status = PHPhotoLibrary.authorizationStatus()
            
            if status == .notDetermined {
                PHPhotoLibrary.requestAuthorization { libraryStatus in
                    completion?(libraryStatus)
                }
            } else {
                completion?(status)
            }
        }
    }
}
