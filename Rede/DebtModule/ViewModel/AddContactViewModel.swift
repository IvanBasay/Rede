//
//  AddContactViewModel.swift
//  Rede
//
//  Created by Иван Викторович on 25.04.2022.
//

import UIKit
import Combine

class AddContactViewModel: BaseViewModel {

    var bag: Set<AnyCancellable> = []
    
    var itsMe: Bool
    
    init(itsMe: Bool = false) {
        self.itsMe = itsMe
    }
    
    func saveContact(name: String, emoji: String, phoneNumber: String?, cardNumber: String?, itsMe: Bool = false) {
        RealmManager.shared.addContact(name: name, emoji: emoji, phoneNumber: phoneNumber, cardNumber: cardNumber, itsMe: itsMe)
    }
    
}
