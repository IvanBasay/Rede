//
//  AddDebtVC.swift
//  Rede
//
//  Created by Иван Викторович on 26.04.2022.
//

import UIKit

class AddDebtVC: BaseViewController {
    
    @IBOutlet weak var decorView: UIView!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var searchContactTF: PaddingTextField!
    @IBOutlet weak var contactPicker: EmojiPicker!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var currencySwicher: CurrencySwapView!
    @IBOutlet weak var amountTF: PaddingTextField!
    @IBOutlet weak var dataView: UIView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var totalLabel: UILabel!
    
    var viewModel: AddDebtViewModel!
    
    private var currentContact: Contact? = RealmManager.shared.fetchContacts().first
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.changeBarTo(appearence: .black)
    }
    
    override func bind() {
        
        viewModel.contacts
            .sink { [weak self] (contacts) in
                guard let self = self else { return }
                self.contactLabel.isHidden = contacts.isEmpty
                self.contactPicker.allEmojies = contacts.map({ $0.emoji })
                self.currentContact = contacts.first
                self.setContactLabel(type: self.viewModel.type)
                if !contacts.isEmpty {
                    self.contactPicker.contentOffset = .zero
                }
            }
            .store(in: &bag)
        
        viewModel.balance
            .sink { [weak self] in
                guard let balance = $0 else {
                    self?.balanceLabel.text = "Unknown error"
                    return
                }
                
                self?.amountTF.addLeftCurrencyView(currency: balance.currency)
                self?.balanceLabel.text = "\(balance.currency.rawValue) \(balance.balance.roundString())"
            }
            .store(in: &bag)
        
        viewModel.total
            .sink { [weak self] (total) in
                if self?.viewModel.type == .iOwe {
                    self?.totalLabel.text = "You are already owe \(CurrencyManager.shared.currentCurrency.rawValue) \(self?.viewModel.total.value.roundString() ?? "0")"
                } else {
                    self?.totalLabel.text = "People owe you \(CurrencyManager.shared.currentCurrency.rawValue) \(self?.viewModel.total.value.roundString() ?? "0")"
                }
            }
            .store(in: &bag)
        
        contactPicker.changeItem
            .sink { [weak self] (index, _) in
                guard let self = self else { return }
                self.currentContact = self.viewModel.contacts.value[index]
                self.setContactLabel(type: self.viewModel.type)
                
            }
            .store(in: &bag)
        
        addButton.tapPublisher
            .sink { [weak self] _ in self?.addDebtTapped() }
            .store(in: &bag)
        
        CurrencyManager.shared.currencyChanged
            .sink { [weak self] _ in self?.viewModel.updateBalance() }
            .store(in: &bag)
    }
    
    override func configUI() {
        decorView.cornerRadius(40)
        decorView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        searchContactTF.placeholder = "Search contact"
        searchContactTF.textAlignment = .center
        searchContactTF.backgroundColor = Color.white
        searchContactTF.addTarget(self, action: #selector(searchChanged(_:)), for: .editingChanged)
        
        searchContactTF.cornerRadius(10)
        
        dataView.backgroundColor = Color.white
        dataView.cornerRadius(10)
        
        addButton.cornerRadius(15)
        addButton.setTitle("Create", for: .normal)
        
        if viewModel.type == .iOwe {
            totalLabel.text = "You are already owe: \(viewModel.total.value.roundString())"
        } else {
            
        }
    }
    
    @objc private func searchChanged(_ sender: PaddingTextField) {
        viewModel.searchContact(string: sender.text ?? "")
    }
    
    private func setContactLabel(type: DebtType) {
        if type == .iOwe {
            let mut = NSMutableAttributedString(string: "From \(currentContact?.name ?? "Unknown")")
            mut.addAttribute(.foregroundColor, value: Color.darkGray, range: NSRange(location: 0, length: 4))
            mut.addAttribute(.font, value: UIFont(name: "Nunito-Black", size: 16)!, range: NSRange(location: 0, length: 4))
            contactLabel.attributedText = mut
        } else {
            let mut = NSMutableAttributedString(string: "To \(currentContact?.name ?? "Unknown")")
            mut.addAttribute(.foregroundColor, value: Color.darkGray, range: NSRange(location: 0, length: 2))
            mut.addAttribute(.font, value: UIFont(name: "Nunito-Black", size: 16)!, range: NSRange(location: 0, length: 2))
            contactLabel.attributedText = mut
        }
    }
    
    private func addDebtTapped() {
        let amountStr = amountTF.text?.replacingOccurrences(of: ",", with: ".")
        guard let amount = Double(amountStr ?? ""), let contact = currentContact else { return }
        
        
        if viewModel.type == .OweMe {
            guard (viewModel.balance.value?.balance ?? 0) >= amount else {
                SystemMessageView().show(message: "Not enought balance", type: .error)
                return
            }
        }
        
        viewModel.createDebt(contact: contact, amount: amount)
        navigationController?.popViewController(animated: true)
    }

}
