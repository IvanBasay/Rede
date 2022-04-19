//
//  SystemMessageView.swift
//  Tradelize
//
//  Created by Иван Викторович on 19.04.2021.
//

import UIKit

class SystemMessageView: UIView {
    
    let kCONTENT_XIB_NAME = "SystemMessageView"
    
    @IBOutlet private var containerView: UIView!
    @IBOutlet private weak var messageLabel: UILabel!
    
    private var hideTimer: Timer?
    
    private var oldOffset: CGPoint = .zero
        
    override private init(frame: CGRect) {
        super.init(frame: frame)
        commotInit()
    }
    
    required internal init?(coder: NSCoder) {
        super.init(coder: coder)
        commotInit()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
        commotInit()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hideTimer?.invalidate()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        if self.frame.contains(location) {
            let opacity = location.y/frame.height
            layer.opacity = Float(opacity)
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.layer.opacity <= 0.7 {
            hide()
        } else {
            UIView.transition(with: containerView, duration: 0.3, options: .transitionCrossDissolve) { [weak self] in
                self?.layer.opacity = 1
            }
            hideTimer?.fire()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.layer.opacity <= 0.7 {
            hide()
        } else {
            UIView.transition(with: containerView, duration: 0.3, options: .transitionCrossDissolve) { [weak self] in
                self?.layer.opacity = 1
            }
            hideTimer?.fire()
        }
    }
    
    private func commotInit() {
        backgroundColor = .clear
        Bundle.main.loadNibNamed(kCONTENT_XIB_NAME, owner: self, options: nil)
        containerView.fixInView(self)
    }
    
    private func reloadWith(message: String, type: SystemMessageType) {
        if let windowView = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            if windowView.subviews.contains(where: { $0 is SystemMessageView }) {
                self.messageLabel.text = message
                switch type {
                case .error:
                    containerView.backgroundColor = Color.red
                case .simple:
                    containerView.backgroundColor = Color.black
                case .simpleAction:
                    containerView.backgroundColor = Color.black
                case .success:
                    containerView.backgroundColor = Color.green
                }
            }
        }
    }

    func show(message: String, action: (()->Void)? = nil, type: SystemMessageType) {
        
        messageLabel.text = message
        
        switch type {
        case .error:
            containerView.backgroundColor = Color.red
        case .simple:
            containerView.backgroundColor = Color.black
        case .simpleAction:
            containerView.backgroundColor = Color.black
        case .success:
            containerView.backgroundColor = Color.green
        }
        
        if let windowView = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            
            if windowView.subviews.contains(where: { $0 is SystemMessageView }) {
                let messageView = windowView.subviews.first(where: { $0 is SystemMessageView }) as? SystemMessageView
                messageView?.reloadWith(message: message, type: type)
                return
            }
            
            let origin = CGPoint(x: 0, y: 0)
            let size = CGSize(width: windowView.frame.width, height: message.height(constraintedWidth: windowView.frame.width - 32, font: UIFont(name: "Nunito-SemiBold", size: 16)!) + 24 + windowView.safeAreaInsets.top)
            
            let rect = CGRect(origin: origin, size: size)
            
            self.frame = rect
            
            self.layer.opacity = 0
            
            windowView.addSubview(self)
            
            UIView.transition(with: containerView, duration: 0.3, options: .transitionCrossDissolve) { [weak self] in
                self?.layer.opacity = 1
            }

            hideTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { [weak self] _ in
                self?.hide()
            })
        }
    }
    
    func hide() {
        UIView.transition(with: containerView, duration: 0.3, options: .transitionCrossDissolve) { [weak self] in
            self?.layer.opacity = 0
        } completion: { [weak self] (success) in
            self?.removeFromSuperview()
        }
    }
}

enum SystemMessageType {
    case simple, simpleAction, error, success
}
