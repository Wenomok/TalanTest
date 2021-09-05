//
//  LoaderView.swift
//  TalanTest
//
//  Created by Vladislav Ivshin on 05.09.2021.
//

import UIKit

class LoaderView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("LoaderView", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.addConstraintsMatchSuperview()
    }
    
    func startLoading(superView: UIView) {
        superView.addSubview(self)
        addConstraintsMatchSuperview()
        activityIndicator.startAnimating()
    }
    
    func stopLoading() {
        activityIndicator.stopAnimating()
        removeFromSuperview()
    }
}
