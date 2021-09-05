//
//  String+Extension.swift
//  TalanTest
//
//  Created by Vladislav Ivshin on 03.09.2021.
//

import UIKit

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont, attributes: [NSAttributedString.Key: Any]? = nil) -> CGFloat {
        var boundingAttributes: [NSAttributedString.Key: Any] = [.font: font]
        if let attributes = attributes {
            attributes.forEach { (key: NSAttributedString.Key, value: Any) in
                boundingAttributes[key] = value
            }
        }
        
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: boundingAttributes, context: nil)
    
        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont, attributes: [NSAttributedString.Key: Any]? = nil) -> CGFloat {
        var boundingAttributes: [NSAttributedString.Key: Any] = [.font: font]
        if let attributes = attributes {
            attributes.forEach { (key: NSAttributedString.Key, value: Any) in
                boundingAttributes[key] = value
            }
        }
        
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: boundingAttributes, context: nil)

        return ceil(boundingBox.width)
    }
}
