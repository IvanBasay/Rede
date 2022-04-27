//
//  IOweCVCell.swift
//  Rede
//
//  Created by Иван Викторович on 20.04.2022.
//

import UIKit

class IOweCVCell: UICollectionViewCell {

    @IBOutlet weak var emojiIcon: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var decorView: UIView!
    
    var debt: Debt? {
        didSet {
            configUI()
            guard let debt = debt else { return }
            setupData(debt: debt)
        }
    }
    
    private func configUI() {
        decorView.backgroundColor = Color.darkGray
        self.cornerRadius(20)
        backgroundColor = Color.white.withAlphaComponent(0.2)
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
