//
//  ToastView.swift
//
//  Created by Vladislav Ivshin on 12.03.2021.
//

import UIKit

// MARK: Attributes
private let contentViewEdgeInsets: UIEdgeInsets = UIEdgeInsets.init(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
private let descriptionLabelEdgeInsets: UIEdgeInsets = UIEdgeInsets.init(top: 10.0, left: 15.0, bottom: 12.0, right: 15.0)

class ToastView: UIView {
    // MARK: Content
    private let contentView: UIView = {
        let view = UIView.init(frame: .zero)
        view.backgroundColor = UIColor.darkGray
        view.layer.cornerRadius = 8.0
        
        return view
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel.init(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        label.textColor = .white
        label.numberOfLines = 3
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    
    private(set) var descriptionTextHeight: CGFloat = 0.0
    
    private var timerForHiding: Timer?
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        addSubview(contentView)
        contentView.addSubview(descriptionLabel)
        
        alpha = 0.0
    }
    
    // MARK: Override
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = CGRect.init(x: contentViewEdgeInsets.left,
                                        y: contentViewEdgeInsets.top,
                                        width: frame.width - (contentViewEdgeInsets.left + contentViewEdgeInsets.right),
                                        height: frame.height - (contentViewEdgeInsets.top + contentViewEdgeInsets.bottom))
        descriptionLabel.frame = CGRect.init(x: descriptionLabelEdgeInsets.left,
                                             y: descriptionLabelEdgeInsets.top,
                                             width: contentView.frame.width - (descriptionLabelEdgeInsets.left + descriptionLabelEdgeInsets.right),
                                             height: contentView.frame.height - (descriptionLabelEdgeInsets.top + descriptionLabelEdgeInsets.bottom))
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        
        timerForHiding?.invalidate()
        timerForHiding = nil
    }
    
    // MARK: Public
    
    func configure(message: String, numberOfLines: Int = 3) {
        descriptionLabel.text = message
        descriptionLabel.numberOfLines = 0
        descriptionLabel.sizeToFit()
        
        descriptionTextHeight = descriptionLabel.frame.height
    }
    
    func show(message: String, numberOfLines: Int = 3, duration: TimeInterval = 3.0) {
        let safeAreaInsets = UIApplication.shared.keyWindow?.safeAreaInsets ?? UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        let maxMessageHeight: CGFloat = self.descriptionLabel.font.lineHeight * CGFloat(numberOfLines)
        var messageHeight = message.height(withConstrainedWidth: UIScreen.main.bounds.width - (contentViewEdgeInsets.left + contentViewEdgeInsets.right + descriptionLabelEdgeInsets.left + descriptionLabelEdgeInsets.right), font: UIFont.systemFont(ofSize: 14.0, weight: .regular))
        if numberOfLines != 0 {
            messageHeight = maxMessageHeight >= messageHeight ? messageHeight : maxMessageHeight
        }
        
        let toastHeight = messageHeight + contentViewEdgeInsets.top + contentViewEdgeInsets.bottom + descriptionLabelEdgeInsets.top + descriptionLabelEdgeInsets.bottom
        
        let rect = CGRect.init(x: 0.0 + safeAreaInsets.left,
                               y: UIScreen.main.bounds.height - safeAreaInsets.bottom - toastHeight,
                               width: UIScreen.main.bounds.width,
                               height: toastHeight)
        self.frame = rect
        
        if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController, let topViewController = navigationController.topViewController {
            if !topViewController.view.subviews.contains(where: { $0.isKind(of: ToastView.classForCoder())}) {
                topViewController.view.addSubview(self)
                self.animate(toast: self, isShow: true)
                self.startTimer(forDuration: duration)
            }
        }
    }
    
    // MARK: Private
    
    private func animate(toast: ToastView, isShow: Bool) {
        UIView.transition(with: toast, duration: 0.3, options: .curveEaseOut) {
            toast.alpha = isShow ? 1.0 : 0.0
        } completion: { (value) in
            if !isShow {
                
                toast.removeFromSuperview()
            }
        }
    }
    
    private func startTimer(forDuration duration: TimeInterval) {
        timerForHiding?.invalidate()
        timerForHiding = Timer.scheduledTimer(withTimeInterval: duration, repeats: false, block: { [weak self] (timer) in
            guard let self = self else { return }
            self.animate(toast: self, isShow: false)
            
            timer.invalidate()
        })
    }
    
    // MARK: Static
    
    static func show(message: String, numberOfLines: Int = 3, duration: TimeInterval = 3.0) {
        let toastView = ToastView.init(frame: .zero)
        toastView.configure(message: message, numberOfLines: numberOfLines)
        toastView.show(message: message, numberOfLines: numberOfLines)
    }
    
    static func show(errorMessage: NSError, numberOfLines: Int = 3, duration: TimeInterval = 3.0) {
        debugPrint(errorMessage)
        show(message: errorMessage.localizedDescription, numberOfLines: numberOfLines, duration: duration)
    }
}
