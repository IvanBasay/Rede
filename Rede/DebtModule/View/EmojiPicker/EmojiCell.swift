//
//  EmojiCell.swift
//  Rede
//
//  Created by Иван Викторович on 20.04.2022.
//

import UIKit

class EmojiCell: UICollectionViewCell {

    @IBOutlet private weak var emojiLabel: UILabel!
    
    var emoji: String? {
        didSet {
            guard let emoji = emoji else {
                emojiLabel.text = "🫥"
                return
            }
            emojiLabel.text = emoji
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization cod
    }

}
