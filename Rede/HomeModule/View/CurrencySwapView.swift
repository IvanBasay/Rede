//
//  CurrencySwapView.swift
//  Rede
//
//  Created by Иван Викторович on 14.04.2022.
//

import UIKit

class CurrencySwapView: UIView, XibView {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet var contentView: UIView!
    
    internal var xibName: String = "CurrencySwapView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    internal func commonInit() {
        self.backgroundColor = Color.lightGray
        Bundle.main.loadNibNamed(xibName, owner: self, options: nil)
        contentView.fixInView(self)
        contentView.backgroundColor = .clear
        self.cornerRadius(7)
                
        let buttons = stackView.arrangedSubviews.filter({ $0 is UIButton }).map({ $0 as! UIButton })
        buttons.forEach({ $0.setTitleColor(Color.darkGray, for: .normal) })
        buttons.first?.setTitle("UAH", for: .normal)
        UDKey.currency == .uah ? buttons.first?.setTitleColor(Color.black, for: .normal) : buttons.last?.setTitleColor(Color.black, for: .normal)
        buttons.last?.setTitle("USD", for: .normal)
    }
    
    func update() {
        let buttons = stackView.arrangedSubviews.filter({ $0 is UIButton }).map({ $0 as! UIButton })
        buttons.forEach({ $0.setTitleColor(Color.darkGray, for: .normal) })
        UDKey.currency == .uah ? buttons.first?.setTitleColor(Color.black, for: .normal) : buttons.last?.setTitleColor(Color.black, for: .normal)
    }
    
    @IBAction func currencyChanged(_ sender: UIButton) {
        stackView.arrangedSubviews.filter({ $0 is UIButton }).forEach({ ($0 as! UIButton).setTitleColor(Color.darkGray, for: .normal) })
        sender.setTitleColor(Color.black, for: .normal)
        if sender == stackView.arrangedSubviews.first {
            CurrencyManager.shared.currentCurrency = .uah
        } else {
            CurrencyManager.shared.currentCurrency = .usd
        }
    }
    
}

protocol XibView {
    var xibName: String { get }
    func commonInit() -> Void
}

extension XibView {
    func commonInit() {
        
    }
}
