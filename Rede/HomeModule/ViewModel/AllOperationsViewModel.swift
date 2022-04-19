//
//  AllOperationsViewModel.swift
//  Rede
//
//  Created by Иван Викторович on 19.04.2022.
//

import UIKit
import Combine

class AllOperationsViewModel: BaseViewModel {
    
    var bag: Set<AnyCancellable> = []

    var operations = CurrentValueSubject<[Int:[Operation]], Never>([:])
    
    init() {
        let oper = RealmManager.shared.fetchAllOperations(currency: CurrencyManager.shared.currentCurrency)
        let dates = Array(Set(oper.map({ $0.date.startOfDay }))).sorted(by: { $0 > $1 })
        var dict: [Int: [Operation]] = [:]
        for (index, item) in dates.enumerated() {
            dict[index] = oper.filter({ $0.date.startOfDay == item })
        }
        operations.send(dict)
    }
}
