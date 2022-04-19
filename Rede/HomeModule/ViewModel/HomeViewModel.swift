//
//  HomeViewModel.swift
//  Rede
//
//  Created by Иван Викторович on 15.04.2022.
//

import Foundation
import Combine

class HomeViewModel: BaseViewModel {
    
    var bag = Set<AnyCancellable>()

    private let realm = RealmManager.shared
    private var currentCurrency: Currency { get { CurrencyManager.shared.currentCurrency } }
    var latesOperations = CurrentValueSubject<[Operation], Never>([])
    var topInfo = CurrentValueSubject<TopInfo, Never>(TopInfo.init(earned: 0, spended: 0))
  
    init() {
        updateData()

        realm.shouldUpdateData.sink { [weak self] in self?.updateData() }.store(in: &bag)
        
        CurrencyManager.shared.currencyChanged.sink { [weak self] _ in self?.updateData() }.store(in: &bag)

        
    }
    
    func updateData() {
        latesOperations.send(realm.fetchLastOperations(currency: currentCurrency))
        topInfo.send(realm.fetchTopInfo(currency: currentCurrency))
        
    }
}
