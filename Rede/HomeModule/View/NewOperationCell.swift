//
//  NewOperationCell.swift
//  Rede
//
//  Created by Иван Викторович on 17.04.2022.
//

import UIKit
import Combine

class NewOperationCell: UITableViewCell {

    @IBOutlet weak var stackView: UIStackView! {
        didSet {
            stackView.arrangedSubviews.last?.isHidden = true
        }
    }
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var amountTF: PaddingTextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var balanceLabel: UILabel!
        
    var category: Category? {
        didSet {
            configUI()
            guard let category = category else { return }
            emojiLabel.text = category.emoji
            categoryName.text = category.name
        }
    }

    var cellSelected: Bool = false {
        didSet {
            guard cellSelected != oldValue else { return }
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) { [weak self] in
                self?.stackView.arrangedSubviews.last?.isHidden = !(self?.cellSelected ?? true)
                self?.stackView.layoutIfNeeded()
            } completion: { [weak self] _ in
                self?.balanceLabel.text = "Balance: \(CurrencyManager.shared.currentCurrency.rawValue) \(RealmManager.shared.fetchTopInfo(currency: CurrencyManager.shared.currentCurrency).balance.roundString(to: 2))"
            }
            
            datePicker.date = Date()

        }
    }
    
    var currency: Currency = CurrencyManager.shared.currentCurrency {
        didSet {
            balanceLabel.text = "Balance: \(CurrencyManager.shared.currentCurrency.rawValue) \(RealmManager.shared.fetchTopInfo(currency: CurrencyManager.shared.currentCurrency).balance.roundString(to: 2))"
            amountTF.addLeftCurrencyView(currency: CurrencyManager.shared.currentCurrency)
        }
    }

    func configUI() {
        amountTF.backgroundColor = Color.black
        amountTF.placeholder = "Enter amount..."
        amountTF.placeholderColor = .systemGray3
        amountTF.addLeftCurrencyView(currency: CurrencyManager.shared.currentCurrency)
        stackView.cornerRadius(10)
        stackView.layer.masksToBounds = true
        stackView.clipsToBounds = true
        
        selectionStyle = .none
        
        datePicker.maximumDate = Date()
        datePicker.overrideUserInterfaceStyle = .dark
        datePicker.tintColor = Color.darkGray
        
        saveButton.cornerRadius(10)
        saveButton.backgroundColor = Color.white
        saveButton.setTitleColor(Color.black, for: .normal)
    }
        
    @IBAction func saveTapped(_ sender: UIButton) {
        guard let amount = Double(amountTF.text?.replacingOccurrences(of: ",", with: ".") ?? ""), let category = category else { return }
        if category.categoryType == .spend {
            guard amount <= RealmManager.shared.fetchTopInfo(currency: CurrencyManager.shared.currentCurrency).balance else {
                SystemMessageView().show(message: "Not enought money", type: .error)
                return
            }
        }
        let date = datePicker.date.startOfDay.addingTimeInterval(Date().timeIntervalSince(Date().startOfDay))
        NewOperationAction.shared.saveNewOperationTapped.send(NewOperationDetails(date: date,
                                                                                  amount: amount,
                                                                                  category: category))
        
    }
    
    struct NewOperationDetails {
        var date: Date
        var amount: Double
        var category: Category
    }
    
}

class NewOperationAction {
    
    static let shared = NewOperationAction()
    
    private init() {}
    
    let saveNewOperationTapped = PassthroughSubject<NewOperationCell.NewOperationDetails, Never>()
    
}
