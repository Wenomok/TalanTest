//
//  Data+Extension.swift
//  TalanTest
//
//  Created by Vladislav Ivshin on 04.09.2021.
//

import UIKit

extension Data {
    func writeToCachedImages(withName name: String) throws {
        guard let cachedImagesURL = FileManager.default.cachedImagesURL() else {
            throw NSError.error(code: 105, localizedDesc: "Failed write image because cant found url for images cache directory")
        }
        
        if !FileManager.default.fileExists(atPath: cachedImagesURL.appendingPathComponent("\(name).png").path) {
            try write(to: cachedImagesURL.appendingPathComponent("\(name).png"))
        }
    }
}
