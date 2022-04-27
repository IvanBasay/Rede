//
//  ExtensionUIView.swift
//  Rede
//
//  Created by Иван Викторович on 15.04.2022.
//

import UIKit

extension UIView {
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
    
    func makeRound() {
        self.layer.cornerRadius = self.frame.height/2
    }
    
    func cornerRadius(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
    }
    
    func addBlur(type: UIBlurEffect.Style) {
        let blurView = UIVisualEffectView(frame: self.bounds)
        blurView.effect = UIBlurEffect(style: type)
        self.insertSubview(blurView, at: 0)
    }
    
    func removeBlur() {
        self.subviews.forEach({ if $0 is UIVisualEffectView { $0.removeFromSuperview() } })
    }
}
