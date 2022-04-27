//
//  DebtHomeViewModel.swift
//  Rede
//
//  Created by Иван Викторович on 21.04.2022.
//

import UIKit
import Combine

class DebtHomeViewModel: BaseViewModel {

    var bag: Set<AnyCancellable> = []
    
    var oweMeDebts = CurrentValueSubject<[Debt], Never>([])
    var iOweDebts = CurrentValueSubject<[Debt], Never>([])
    
    func updateDebts() {
        let iOwe = RealmManager.shared.fetchDebts(type: .iOwe)
        let oweMe = RealmManager.shared.fetchDebts(type: .OweMe)
        
        oweMeDebts.send(oweMe)
        iOweDebts.send(iOwe)
    }
    
}
