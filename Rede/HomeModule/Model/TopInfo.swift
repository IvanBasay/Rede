//
//  TopInfo.swift
//  MoneySaver
//
//  Created by Иван Викторович on 13.04.2022.
//

import Foundation

struct TopInfo {
    
    var earned: Double
    var spended: Double
    var earnCompare: Double = 0
    var spendCompare: Double = 0
    
    var balance: Double {
        get {
            return RealmManager.shared.fetchBalance(currency: CurrencyManager.shared.currentCurrency).balance
        }
    }
    
    var balancePC: Double {
        get {
            return 0.2 //balance / earned
        }
    }
    
}
