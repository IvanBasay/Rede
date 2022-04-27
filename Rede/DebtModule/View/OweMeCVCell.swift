//
//  OweMeCVCell.swift
//  Rede
//
//  Created by Иван Викторович on 20.04.2022.
//

import UIKit

class OweMeCVCell: UICollectionViewCell {
    
    @IBOutlet weak var emojiIcon: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var decorView: UIView!
    
    private var shadowLayer: CAShapeLayer!

    var debt: Debt? {
        didSet {
            configUI()
            guard let debt = debt else { return }
            setupData(debt: debt)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 20).cgPath
            shadowLayer.fillColor = UIColor.white.cgColor

            shadowLayer.shadowColor = UIColor.darkGray.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            shadowLayer.shadowOpacity = 0.8
            shadowLayer.shadowRadius = 2

            layer.insertSublayer(shadowLayer, at: 0)
            //layer.insertSublayer(shadowLayer, below: nil) // also works
        }
    }
    
    private func configUI() {
        decorView.backgroundColor = Color.gray
        self.cornerRadius(20)
        backgroundColor = Color.white
        self.clipsToBounds = true
        self.layer.masksToBounds = true
    }
    
    private func setupData(debt: Debt) {
        emojiIcon.text = debt.contact?.emoji ?? "🫥"
        nameLabel.text = debt.contact?.name ?? ""
        dateLabel.text = debt.date.toString(format: "MMM d, yyyy")
        amountLabel.text = "\(debt.currency.rawValue) \(debt.amount.formatNumber())"
    }

}
