//
//  ImageData.swift
//  TalanTest
//
//  Created by Vladislav Ivshin on 04.09.2021.
//

import UIKit

class ImageData: NSObject {
    var imageName: String
    var imageData: Data?
    
    init(imageName: String) {
        self.imageName = imageName
        
        super.init()
    }
    
    func getImageURL() -> URL? {
        return FileManager.default.cachedImagesURL()?.appendingPathComponent("\(imageName).png")
    }
}
