//
//  TODOHeaderView.swift
//  TalanTest
//
//  Created by Vladislav Ivshin on 03.09.2021.
//

import UIKit

class TODOHeaderView: UITableViewHeaderFooterView {
    static let reuseIdentifier: String = "todo_header_view"
    
    private let label: UILabel = {
        let label = UILabel.init()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        label.textAlignment = .center
        label.text = ""
        
        return label
    }()
    
    func configure(title: String) {
        label.text = title
        
        if !subviews.contains(label) {
            let x: CGFloat = 12.0
            let y: CGFloat = 12.0
            let width: CGFloat = UIScreen.main.bounds.width - x * 2
            let height: CGFloat = title.height(withConstrainedWidth: width, font: label.font)
            
            label.frame = CGRect.init(x: x, y: y, width: width, height: height)
            addSubview(label)
        }
        
        backgroundColor = .lightGray
    }
    
    func calculateHeight() -> CGFloat {
        return CGFloat(12 * 2 + label.frame.height)
    }
}
