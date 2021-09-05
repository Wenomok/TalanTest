//
//  CheckboxButton.swift
//  TalanTest
//
//  Created by Vladislav Ivshin on 03.09.2021.
//

import UIKit

protocol CheckButtonObserver {
    func didUpdateCheck(isChecked: Bool)
}

class CheckboxButton: UIButton {
    @IBInspectable var isChecked: Bool = false {
        didSet {
            updateCheckbox()
        }
    }
    
    var observer: CheckButtonObserver?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    private func commonInit() {
        updateCheckbox()
        
        setTitle("", for: .normal)
        tintColor = .gray
    }
    
    private func updateCheckbox() {
        setImage(UIImage.init(named: isChecked ? "checkbox_on" : "checkbox_off"), for: .normal)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        isChecked.toggle()
        observer?.didUpdateCheck(isChecked: isChecked)
    }
}
