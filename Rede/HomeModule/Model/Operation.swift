//
//  Operation.swift
//  MoneySaver
//
//  Created by Иван Викторович on 13.04.2022.
//

import Foundation
import RealmSwift

class Operation: Object {
    
    @Persisted var amount: Double
    @Persisted var date: Date
    @Persisted var category: Category?
    @Persisted var currency: Currency
//    var currency: Currency {
//        get {
//            return Currency(rawValue: operationCurrency) ?? .unknown
//        } set {
//            operationCurrency = newValue.rawValue
//        }
//    }
    
}
