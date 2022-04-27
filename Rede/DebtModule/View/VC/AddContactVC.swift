//
//  AddContactVC.swift
//  Rede
//
//  Created by Иван Викторович on 21.04.2022.
//

import UIKit
import CombineCocoa


class AddContactVC: BaseViewController {
    
    @IBOutlet weak var popapView: UIView!
    @IBOutlet weak var emojiPicker: EmojiPicker!
    @IBOutlet weak var nameTF: PaddingTextField!
    @IBOutlet weak var phoneTF: PaddingTextField!
    @IBOutlet weak var cardTF: PaddingTextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var viewModel: AddContactViewModel!
    
    override func bind() {
        
        saveButton.tapPublisher
            .sink { [weak self] _ in self?.saveContact() }
            .store(in: &bag)
        
        cancelButton.tapPublisher
            .sink { [weak self] _ in self?.dismiss(animated: true) }
            .store(in: &bag)
        
        cardTF.textPublisher
            .sink { [weak self] (text) in
                self?.cardTF.text = self?.cardTF.text?.applyPatternOnNumbers(pattern: "XXXX XXXX XXXX XXXX", replacementCharacter: "X") ?? ""
            }
            .store(in: &bag)
    }
  
    override func configUI() {
        
        view.backgroundColor = .clear
        view.addBlur(type: .regular)
        
        popapView.cornerRadius(20)
        nameTF.addIcon(UIImage(named: "profile_icon"))
        if viewModel.itsMe {
            nameTF.placeholder = "Your name..."
        } else {
            nameTF.placeholder = "Name..."
        }
        nameTF.placeholderColor = UIColor(red: 0.878, green: 0.878, blue: 0.878, alpha: 1)
        
        phoneTF.addIcon(UIImage(named: "phone_icon"))
        if viewModel.itsMe {
            phoneTF.placeholder = "Your phone... (optional)"
        } else {
            phoneTF.placeholder = "Phone... (optional)"
        }
        phoneTF.placeholderColor = UIColor(red: 0.878, green: 0.878, blue: 0.878, alpha: 1)
        
        cardTF.addIcon(UIImage(named: "wallet_icon"))
        if viewModel.itsMe {
            cardTF.placeholder = "Your card number... (optional)"
        } else {
            cardTF.placeholder = "Card number... (optional)"
        }
        cardTF.addPasteView()
        cardTF.format = "XXXX XXXX XXXX XXXX"
        cardTF.placeholderColor = UIColor(red: 0.878, green: 0.878, blue: 0.878, alpha: 1)
        
        saveButton.setTitle("Save", for: .normal)
        saveButton.cornerRadius(10)
        
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.cornerRadius(10)
        
        popapView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -30).isActive = true
        
    }
    
    private func saveContact() {
        guard let name = nameTF.text else { return }
        guard let emoji = emojiPicker.currentEmoji else { return }
        viewModel.saveContact(name: name, emoji: emoji, phoneNumber: phoneTF.text, cardNumber: cardTF.text, itsMe: viewModel.itsMe)
        dismiss(animated: true)
    }

}
