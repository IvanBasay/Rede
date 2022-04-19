//
//  ProgressBar.swift
//  Rede
//
//  Created by Иван Викторович on 15.04.2022.
//

import Foundation
import UIKit

class ProgressBar: UIView {
    
    private var progressView = UIView()
    
    var progress: Double = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()

    }
    
    private func commonInit() {
        progressView.frame = bounds.insetBy(dx: 4, dy: 4)
        progressView.frame.size.width = 0
        addSubview(progressView)
        backgroundColor = Color.lightGray
        self.layer.masksToBounds = true
        cornerRadius(bounds.height / 2)
        progressView.cornerRadius(progressView.bounds.height / 2)
        progressView.backgroundColor = Color.green
        self.transform = CGAffineTransform(rotationAngle: .pi)
    }
    
    override func draw(_ rect: CGRect) {
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) { [weak self] in
            if !(self?.progress.isNormal ?? false) {
                self?.progressView.frame.size.width = 0
                
            } else {
                self?.progressView.frame.size.width = ((self?.bounds.width ?? 0) - 8) * (self?.progress ?? 0)
            }
        }
        
    }
    
    
}
