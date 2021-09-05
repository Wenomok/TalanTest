//
//  NSError+Extension.swift
//  TalanTest
//
//  Created by Vladislav Ivshin on 04.09.2021.
//

import UIKit

extension NSError {
    static var notFound: NSError {
        return NSError.error(code: 101, localizedDesc: "Not found")
    }
    
    static var noDataToWrite: NSError {
        return NSError.error(code: 102, localizedDesc: "No data to write")
    }
    
    static func error(code: Int, localizedDesc: String) -> NSError {
        return NSError.init(domain: "vivshin.TalanTest", code: code, userInfo: [NSLocalizedDescriptionKey: localizedDesc])
    }
}
