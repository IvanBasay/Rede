//
//  HomeViewModel.swift
//  Rede
//
//  Created by Иван Викторович on 15.04.2022.
//

import Foundation
import Combine

class HomeViewModel: BaseViewModel {
    
    struct BalanceDetailInfo {
        var currency: Currency = CurrencyManager.shared.currentCurrency
        var iOweValue: Double = 0
        var oweMeValue: Double = 0
    }
    
    var bag = Set<AnyCancellable>()

    private let realm = RealmManager.shared
    private var currentCurrency: Currency { get { CurrencyManager.shared.currentCurrency } }
    var latesOperations = CurrentValueSubject<[Operation], Never>([])
    var topInfo = CurrentValueSubject<TopInfo, Never>(TopInfo.init(earned: 0, spended: 0))
    var balanceDetails = CurrentValueSubject<BalanceDetailInfo, Never>(BalanceDetailInfo())
  
    init() {
        updateData()

        realm.shouldUpdateData.sink { [weak self] in self?.updateData() }.store(in: &bag)
        
        CurrencyManager.shared.currencyChanged.sink { [weak self] _ in self?.updateData() }.store(in: &bag)
    }
    
    func updateData() {
        latesOperations.send(realm.fetchLastOperations(currency: currentCurrency))
        topInfo.send(realm.fetchTopInfo(currency: currentCurrency))
        let oweMeDebts = RealmManager.shared.fetchDebts(type: .OweMe)
        let oweMeAmount = oweMeDebts.filter({ $0.currency == currentCurrency }).map({ $0.amount }).reduce(0, +)
        let iOweDebts = RealmManager.shared.fetchDebts(type: .iOwe)
        let iOweAmount = iOweDebts.filter({ $0.currency == currentCurrency }).map({ $0.amount }).reduce(0, +)
        balanceDetails.send(BalanceDetailInfo(currency: currentCurrency, iOweValue: iOweAmount, oweMeValue: oweMeAmount))
    }
}
