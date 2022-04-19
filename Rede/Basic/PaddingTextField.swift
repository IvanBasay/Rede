//
//  PaddingTextField.swift
//  Tradelize
//
//  Created by Иван Викторович on 23.04.2021.
//

import UIKit

class PaddingTextField: UITextField {
    
    @IBInspectable
    var padding = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 7)
    
    @IBInspectable
    var textPadding = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 36 + 12)
    
    @IBInspectable
    var placeholderColor = Color.darkGray {
        didSet {
            attributedPlaceholder = NSAttributedString(string: placeholder ?? "",
                                                       attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
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
        makeRound()
        attributedPlaceholder = NSAttributedString(string: placeholder ?? "",
                                                   attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
        
        
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect.origin.x -= padding.right

        return rect
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.x += padding.left

        return rect
    }
    
    func addRightCurrencyView(currency: Currency) {
        let btcAccessoryLabel = UILabel()
        btcAccessoryLabel.font = UIFont(name: "Nunito-SemiBold", size: 13)
        if currency == .uah {
            btcAccessoryLabel.text = "UAH"
        } else {
            btcAccessoryLabel.text = "USD"
        }
        btcAccessoryLabel.textColor = textColor
        btcAccessoryLabel.textAlignment = .right
        btcAccessoryLabel.layoutIfNeeded()
        btcAccessoryLabel.sizeToFit()
        self.rightViewMode = .always
        self.padding.right = 16
        self.rightView = btcAccessoryLabel
    }
    
    func addLeftCurrencyView(currency: Currency) {
        let btcAccessoryLabel = UILabel()
        btcAccessoryLabel.font = UIFont(name: "Nunito-Bold", size: 16)
        btcAccessoryLabel.text = currency.rawValue
        btcAccessoryLabel.textColor = textColor
        btcAccessoryLabel.textAlignment = .left
        btcAccessoryLabel.layoutIfNeeded()
        btcAccessoryLabel.sizeToFit()
        textPadding.left = 24+16
        self.leftViewMode = .always
        self.padding.left = 16
        self.leftView = btcAccessoryLabel
    }

}
