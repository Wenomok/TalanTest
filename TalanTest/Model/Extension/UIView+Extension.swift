//
//  UIView+Constraints.swift
//
//  Created by Vladislav Ivshin on 26.10.2020.
//

import UIKit

extension UIView {
    // MARK: Add Constraints
    
    func addConstraintsMatchSuperview(attributes: [NSLayoutConstraint.Attribute]? = nil) {
        guard let superView = self.superview else {
            return
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let attributes = attributes {
            for attribute in attributes {
                superView.addConstraint(between: self, firstConstraintAttribute: attribute,
                                        secondControl: superView, secondConstraintAttribute: attribute,
                                        value: 0)
            }
        } else {
            superView.addConstraint(between: self, firstConstraintAttribute: .leading, secondControl: superView, secondConstraintAttribute: .leading, value: 0)
            superView.addConstraint(between: self, firstConstraintAttribute: .trailing, secondControl: superView, secondConstraintAttribute: .trailing, value: 0)
            superView.addConstraint(between: self, firstConstraintAttribute: .top, secondControl: superView, secondConstraintAttribute: .top, value: 0)
            superView.addConstraint(between: self, firstConstraintAttribute: .bottom, secondControl: superView, secondConstraintAttribute: .bottom, value: 0)
        }
    }
    
    func addConstraint(between firstControl:UIView, firstConstraintAttribute: NSLayoutConstraint.Attribute, secondControl: UIView, secondConstraintAttribute: NSLayoutConstraint.Attribute, value: Float) {
        self.addConstraint(NSLayoutConstraint.init(item: firstControl,
                                                   attribute: firstConstraintAttribute,
                                                   relatedBy: .equal,
                                                   toItem: secondControl,
                                                   attribute: secondConstraintAttribute,
                                                   multiplier: 1.0, constant: CGFloat(value)))
    }
    
    func addConstraint(to subview: UIView, attribute: NSLayoutConstraint.Attribute, value: CGFloat) {
        self.addConstraint(NSLayoutConstraint.init(item: subview,
                                                   attribute: attribute,
                                                   relatedBy: .equal,
                                                   toItem: self,
                                                   attribute: attribute,
                                                   multiplier: 1.0,
                                                   constant: value))
    }
    
    func addConstraint(height: CGFloat? = nil, width: CGFloat? = nil) {
        var constraints: [NSLayoutConstraint] = []
        if let iHeight = height {
            let heightConstraint = NSLayoutConstraint.init(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: iHeight)
            constraints.append(heightConstraint)
        }
        if let iWidth = width {
            let widthConstraint = NSLayoutConstraint.init(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: iWidth)
            constraints.append(widthConstraint)
        }
        
        self.addConstraints(constraints)
    }
    
    func addConstraintBetween(firstControl: UIView, constraint: NSLayoutConstraint.Attribute, andControl: UIView, andConstraint: NSLayoutConstraint.Attribute, value: CGFloat) {
        self.addConstraint(NSLayoutConstraint.init(item: firstControl, attribute: constraint, relatedBy: .equal, toItem: andControl, attribute: andConstraint, multiplier: 1.0, constant: value))
    }
    
    func addConstraintBetween(firstControl: UIView, constraint: NSLayoutConstraint.Attribute, andControl: UIView, andConstraint: NSLayoutConstraint.Attribute, multiplier: CGFloat) {
        self.addConstraint(NSLayoutConstraint.init(item: firstControl, attribute: constraint, relatedBy: .equal, toItem: andControl, attribute: andConstraint, multiplier: multiplier, constant: 0.0))
    }
    
    func addZeroConstraints(subview: UIView, constraintAttributes: [NSLayoutConstraint.Attribute]) {
        for attribute in constraintAttributes {
            addConstraint(to: subview, attribute: attribute, value: 0.0)
        }
    }
    
    // MARK: Get constraint
    
    private func getSizeConstraint(withAttritbute attribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
        for constraint in self.constraints {
            if constraint.firstAttribute == attribute {
                return constraint
            }
        }
        
        return nil
    }
    
    private func getConstraint(withAttritbute attribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
        for constraint in self.constraints {
            if constraint.firstAttribute == attribute, self.isEqual(constraint.firstItem) {
                return constraint
            }
        }
        
        return nil
    }
    
    private func getSuperviewConstraint(withAttritbute attribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
        for constraint in self.superview?.constraints ?? [] {
            if constraint.firstAttribute == attribute, self.isEqual(constraint.firstItem) {
                return constraint
            }
        }
        
        return nil
    }
    
    func getSelfHeightConstraint() -> NSLayoutConstraint? {
        return getSizeConstraint(withAttritbute: .height)
    }
    
    func getSelfWidthConstraint() -> NSLayoutConstraint? {
        return getSizeConstraint(withAttritbute: .width)
    }
    
    func getBaselineConstraint() -> NSLayoutConstraint? {
        return getSuperviewConstraint(withAttritbute: .firstBaseline)
    }
    
    func getCenterYConstraint() -> NSLayoutConstraint? {
        return getSuperviewConstraint(withAttritbute: .centerY)
    }
    
    func getCenterXConstraint() -> NSLayoutConstraint? {
        return getSuperviewConstraint(withAttritbute: .centerX)
    }
    
    func getLeftMarginConstraint() -> NSLayoutConstraint? {
        return getSuperviewConstraint(withAttritbute: .leading)
    }
    
    func getRightMarginConstraint() -> NSLayoutConstraint? {
        return getSuperviewConstraint(withAttritbute: .trailing)
    }
    
    func getBottomMarginConstraint() -> NSLayoutConstraint? {
        for constraint in self.superview?.constraints ?? [] {
            if constraint.firstAttribute == .bottom, self.isEqual(constraint.secondItem) {
                return constraint
            }
        }
        
        return nil
    }
    
    func getTopMarginConstraint() -> NSLayoutConstraint? {
        return getSuperviewConstraint(withAttritbute: .top)
    }
}
