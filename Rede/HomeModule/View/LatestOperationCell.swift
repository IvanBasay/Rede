//
//  LatestOperationCell.swift
//  Rede
//
//  Created by Иван Викторович on 16.04.2022.
//

import UIKit

class LatestOperationCell: UICollectionViewCell {
    
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var operation: Operation! {
        didSet {
            cornerRadius(10)
            backgroundColor = Color.black
            emojiLabel.text = operation.category?.emoji ?? "🫥"
            categoryNameLabel.text = operation.category?.name ?? "Unknown"
            amountLabel.text = "\(operation.currency.rawValue) \(operation.amount.formatNumber())"
            dateLabel.text = operation.date.toString(format: "MMM d, yyyy")
            
            if operation.category?.categoryType == .earn {
                amountLabel.textColor = Color.green
            } else {
                amountLabel.textColor = Color.red
            }
        }
    }

}
