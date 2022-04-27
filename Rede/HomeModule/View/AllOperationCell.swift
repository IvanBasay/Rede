//
//  AllOperationCell.swift
//  Rede
//
//  Created by Иван Викторович on 19.04.2022.
//

import UIKit

class AllOperationCell: UITableViewCell {

    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    var operation: Operation? {
        didSet {
            guard let operation = operation, let category = operation.category else { return }
            emojiLabel.text = category.emoji
            nameLabel.text = category.name
            amountLabel.text = "\(CurrencyManager.shared.currentCurrency.rawValue) \(operation.amount.roundString())"
            
            if category.categoryType == .spend {
                amountLabel.textColor = Color.red
            } else {
                amountLabel.textColor = Color.green
            }
            
        }
    }
    
}
