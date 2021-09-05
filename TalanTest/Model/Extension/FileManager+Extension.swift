//
//  FileManager+Extension.swift
//  TalanTest
//
//  Created by Vladislav Ivshin on 04.09.2021.
//

import UIKit

extension FileManager {
    func documentsURL() -> URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    func cachedImagesURL() -> URL? {
        return documentsURL()?.appendingPathComponent("cached_images")
    }
}
