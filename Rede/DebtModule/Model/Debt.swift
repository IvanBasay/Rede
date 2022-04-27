//
//  Debt.swift
//  Rede
//
//  Created by Иван Викторович on 20.04.2022.
//

import Foundation
import RealmSwift

class Debt: Object {
    
    @Persisted var contact: Contact?
    @Persisted var amount: Double
    @Persisted var type: DebtType
    @Persisted var date: Date
    @Persisted var currency: Currency
    
}

enum DebtType: String, PersistableEnum {
    case iOwe
    case OweMe
}
