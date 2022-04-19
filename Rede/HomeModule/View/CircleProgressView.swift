//
//  CircleProgressView.swift
//  Rede
//
//  Created by Иван Викторович on 14.04.2022.
//

import UIKit

class CircleProgressView: UIView {
    
    private var backLayer = CAShapeLayer()
    private var frontLayer = CAShapeLayer()

    var trackBackgroundColor = Color.lightGray
    var trackBorderWidth: CGFloat = 20
    var progressColor = Color.green
    private var oldPercent: Double = 0
    var percent: Double = 0 {
        didSet {
            oldPercent = oldValue
            setNeedsDisplay()
        }
    }
    
    var title: String = "" {
        didSet {
            multiplyerLabel.text = title
        }
    }
    
    var subtitle: String = "" {
        didSet {
            subtitleLabel.text = subtitle
        }
    }
    
    private let multiplyerLabel = UILabel()
    private let subtitleLabel = UILabel()


    private let startDegrees: CGFloat = 150
    private let endDegrees: CGFloat = 30
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(backLayer)
        layer.addSublayer(frontLayer)
        createLabels()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        layer.addSublayer(backLayer)
        layer.addSublayer(frontLayer)
        createLabels()
    }

    override func draw(_ rect: CGRect) {
        let startAngle: CGFloat = radians(of: startDegrees)
        let endAngle: CGFloat = radians(of: endDegrees)

        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(center.x, center.y) - trackBorderWidth / 2

        let trackPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        backLayer.path = trackPath.cgPath
        backLayer.lineWidth = trackBorderWidth
        backLayer.lineCap = .round
        backLayer.fillColor = UIColor.clear.cgColor
        backLayer.strokeColor = trackBackgroundColor.cgColor
        
        frontLayer.path = trackPath.cgPath
        frontLayer.fillColor = UIColor.clear.cgColor
        frontLayer.strokeColor = progressColor.cgColor
        frontLayer.lineWidth = trackBorderWidth - 4
        frontLayer.lineCap = .round
        
        startAnimation()
    }
    
    private func createLabels() {
        let a1 = min(center.x, center.y) - trackBorderWidth / 2
        let b1 = 2 * a1 * (sqrt(3)/2)
        let f1 = 2 * a1 * 0.5
        
        let downOffset = sqrt(pow(f1, 2) - pow(b1/2, 2))
        
        
        multiplyerLabel.textAlignment = .center
        multiplyerLabel.font = UIFont(name: "Nunito-Black", size: 24)
        multiplyerLabel.textColor = Color.black
        multiplyerLabel.sizeToFit()
        multiplyerLabel.translatesAutoresizingMaskIntoConstraints = false

        
        subtitleLabel.font = UIFont(name: "Nunito-SemiBold", size: 12)
        subtitleLabel.textColor = Color.darkGray
        subtitleLabel.sizeToFit()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [multiplyerLabel, subtitleLabel])
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        stackView.sizeToFit()
        stackView.layoutIfNeeded()
        stackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView)
        stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 24).isActive = true
        stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -24).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -downOffset).isActive = true
        


    }

    private func radians(of degrees: CGFloat) -> CGFloat {
        return degrees / 180 * .pi
    }

    private func startAnimation() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        animation.fromValue = oldPercent
        animation.toValue = percent
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.duration = 0.5 // seconds
        animation.autoreverses = false
        animation.isRemovedOnCompletion = false
        animation.fillMode = .both

        // And finally add the linear animation to the shape!
        frontLayer.add(animation, forKey: "line")
    }
}
