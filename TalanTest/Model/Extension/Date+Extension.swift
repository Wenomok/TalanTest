//
//  Date+Extension.swift
//  TalanTest
//
//  Created by Vladislav Ivshin on 03.09.2021.
//

import UIKit

extension Date {
    func toStringFormat(format: String) -> String {
        let formatter = DateFormatter.init()
        formatter.dateFormat = format
        
        return formatter.string(from: self)
    }
}
