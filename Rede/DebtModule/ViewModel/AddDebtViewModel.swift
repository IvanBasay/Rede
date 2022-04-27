//
//  AddDebtViewModel.swift
//  Rede
//
//  Created by Иван Викторович on 26.04.2022.
//

import UIKit
import Combine

class AddDebtViewModel: BaseViewModel {
    
    var bag: Set<AnyCancellable> = []
    
    var contacts = CurrentValueSubject<[Contact], Never>([])
    var balance = CurrentValueSubject<Balance?, Never>(nil)
    var total = CurrentValueSubject<Double, Never>(0)
    
    var type: DebtType
    
    init(type: DebtType) {
        self.type = type
        let contacts = RealmManager.shared.fetchContacts()
        let balance = RealmManager.shared.fetchBalance(currency: CurrencyManager.shared.currentCurrency)
        self.balance.send(balance)
        self.contacts.send(contacts)
        getTotalOwe()
    }
    
    func getTotalOwe() {
        let debts = RealmManager.shared.fetchDebts(type: type)
        let amount = debts.map({ $0.amount }).reduce(0, +)
        total.send(amount)
    }
    
    func updateBalance() {
        let balance = RealmManager.shared.fetchBalance(currency: CurrencyManager.shared.currentCurrency)
        self.balance.send(balance)
    }
    
    func searchContact(string: String) {
        var allContacts = RealmManager.shared.fetchContacts()
        if string.isEmpty {
            contacts.send(allContacts)
        } else {
            allContacts = allContacts.filter({ $0.name.lowercased().contains(string.lowercased()) })
            contacts.send(allContacts)
        }
    }
    
    func createDebt(contact: Contact, amount: Double) {
        RealmManager.shared.addDebt(contact: contact, amount: amount, type: type, currency: CurrencyManager.shared.currentCurrency)
    }
    
}
