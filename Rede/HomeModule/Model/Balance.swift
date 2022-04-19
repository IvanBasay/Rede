//
//  Balance.swift
//  Rede
//
//  Created by Иван Викторович on 18.04.2022.
//

import Foundation
import RealmSwift

class Balance: Object {
    @Persisted var balance: Double = 0
    @Persisted var currency: Currency
}
