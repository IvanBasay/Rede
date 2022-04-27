//
//  CloseDebtVC.swift
//  Rede
//
//  Created by Иван Викторович on 27.04.2022.
//

import UIKit

class CloseDebtVC: BaseViewController {
    
    @IBOutlet weak var decorView: UIView!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var amountTF: PaddingTextField!
    @IBOutlet weak var dataView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var oweLabel: UILabel!
    @IBOutlet weak var oweTypeLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    var viewModel: CloseDebtViewModel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.changeBarTo(appearence: .black)
    }
    
    override func bind() {
        balanceLabel.text = "Current balance: \(viewModel.balance.currency.rawValue) \(viewModel.balance.balance.formattedWithSeparator)"
        setContactLabel(type: viewModel.debt.type)
        emojiLabel.text = viewModel.debt.contact?.emoji ?? "🫥"
        
        closeButton.tapPublisher
            .sink { [weak self] _ in self?.closeDebtTapped() }
            .store(in: &bag)
        
        actionButton.tapPublisher
            .sink { [weak self] _ in self?.actionTapped() }
            .store(in: &bag)
        
        oweLabel.text = "\(viewModel.debt.currency.rawValue) \(viewModel.debt.amount.formattedWithSeparator)"
        
        RealmManager.shared.shouldUpdateData
            .sink { [weak self] _ in self?.viewModel.updateUser() }
            .store(in: &bag)
        
    }
    
    override func configUI() {
        decorView.cornerRadius(40)
        decorView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        dataView.backgroundColor = Color.white
        dataView.cornerRadius(10)
        
        closeButton.cornerRadius(15)
        closeButton.setTitle("Close debt", for: .normal)
        
        actionButton.cornerRadius(15)
        
        if viewModel.debt.type == .iOwe {
            oweTypeLabel.text = "You owe"
            actionButton.setImage(UIImage(named: "send_icon")?.withRenderingMode(.alwaysTemplate).withTintColor(Color.white), for: .normal)
        } else {
            oweTypeLabel.text = "\(viewModel.debt.contact?.name ?? "Noname") owe you"
            actionButton.setImage(UIImage(named: "share_icon")?.withRenderingMode(.alwaysTemplate).withTintColor(Color.white), for: .normal)

        }
        
        if viewModel.debt.type == .iOwe {
            if let url = URL(string: "https://mbnk.app"), UIApplication.shared.canOpenURL(url) {
                actionButton.isHidden = false
            } else {
                actionButton.isHidden = true
            }
        }
        
        amountTF.addLeftCurrencyView(currency: viewModel.debt.currency)
        amountTF.text = "\(viewModel.debt.amount)"
    }
    
    private func setContactLabel(type: DebtType) {
        if type == .OweMe {
            let mut = NSMutableAttributedString(string: "From \(viewModel.debt.contact?.name ?? "Unknown")")
            mut.addAttribute(.foregroundColor, value: Color.darkGray, range: NSRange(location: 0, length: 4))
            mut.addAttribute(.font, value: UIFont(name: "Nunito-Black", size: 16)!, range: NSRange(location: 0, length: 4))
            contactLabel.attributedText = mut
        } else {
            let mut = NSMutableAttributedString(string: "To \(viewModel.debt.contact?.name ?? "Unknown")")
            mut.addAttribute(.foregroundColor, value: Color.darkGray, range: NSRange(location: 0, length: 2))
            mut.addAttribute(.font, value: UIFont(name: "Nunito-Black", size: 16)!, range: NSRange(location: 0, length: 2))
            contactLabel.attributedText = mut
        }
    }
    
    private func closeDebtTapped() {
        guard let amountStr = amountTF.text?.replacingOccurrences(of: ",", with: "."), var amount = Double(amountStr) else { return }
        if viewModel.debt.type == .iOwe {
            if amount > viewModel.debt.amount {
                amount = viewModel.debt.amount
            }
            
            if amount > viewModel.balance.balance {
                SystemMessageView().show(message: "Not enought balance", type: .error)
                return
            }
        }
        viewModel.closeDebt(amount: amount)
        navigationController?.popViewController(animated: true)
    }
    
    private func actionTapped() {
        if viewModel.debt.type == .OweMe {
            if let user = viewModel.user {
                var message = ""
                message = "Hi!👋\nYou owe me \(viewModel.debt.currency.rawValue)\(viewModel.debt.amount.formattedWithSeparator) 💵"
                
                if user.cardNumber != nil {
                    message.append(contentsOf: "\nMy card number is\n💳\(user.cardNumber?.replacingOccurrences(of: " ", with: "") ?? "Unknown")💳")
                }
                
                let activityVC = UIActivityViewController(activityItems: [message], applicationActivities: nil)
                activityVC.excludedActivityTypes = [.airDrop, .addToReadingList]
                self.present(activityVC, animated: true, completion: nil)
            } else {
                let vc = StoryboardReferenceBuilder.shared.buildReference(forController: AddContactVC.self, storyboard: .debt)!
                vc.viewModel = AddContactViewModel(itsMe: true)
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                present(vc, animated: true)
            }
        } else {
            if let cardNumber = viewModel.debt.contact?.cardNumber {
                UIPasteboard.general.string = cardNumber
            }
            if let url = URL(string: "https://mbnk.app"), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    }
    
}
