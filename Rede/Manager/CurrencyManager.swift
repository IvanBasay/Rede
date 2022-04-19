//
//  CurrencyManager.swift
//  Rede
//
//  Created by Иван Викторович on 15.04.2022.
//

import Foundation
import Combine

class CurrencyManager {
    
    static let shared = CurrencyManager()
    
    private init() {}
    
    var currencyChanged = PassthroughSubject<Currency, Never>()
    
    var currentCurrency: Currency {
        get {
            return UDKey.currency
        }
        set {
            UDKey.currency = newValue
            currencyChanged.send(newValue)
        }
    }
    
    var bag = Set<AnyCancellable>()
        
}
