//
//  CloseDebtViewModel.swift
//  Rede
//
//  Created by Иван Викторович on 27.04.2022.
//

import UIKit
import Combine

class CloseDebtViewModel: BaseViewModel {

    var bag: Set<AnyCancellable> = []
    
    private(set) var debt: Debt
    private(set) var balance: Balance
    private(set) var user: Contact?
    
    init(debt: Debt) {
        self.debt = debt
        self.balance = RealmManager.shared.fetchBalance(currency: debt.currency)
        self.user = RealmManager.shared.fetchUser()
    }
    
    func updateUser() {
        self.user = RealmManager.shared.fetchUser()
    }
    
    func closeDebt(amount: Double) {
        RealmManager.shared.modifyDebt(debt: debt, amount: amount)
    }
    
}
