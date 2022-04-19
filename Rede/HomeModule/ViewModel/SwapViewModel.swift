//
//  SwapViewModel.swift
//  Rede
//
//  Created by Иван Викторович on 16.04.2022.
//

import UIKit
import Combine

class SwapViewModel: BaseViewModel {
    
    var bag = Set<AnyCancellable>()
    
    var currency = CurrentValueSubject<ExchangeResponse?, Never>(nil)
    var isSyncEnabled = true
    
    var to: Currency
    var from: Currency

    init(to: Currency, from: Currency) {
        self.to = to
        self.from = from
        updateExchange()
    }
    
    private func checkExchange(from: Currency, to: Currency) -> AnyPublisher<ExchangeResponse?, Never> {
        guard isSyncEnabled else { return Just(nil).eraseToAnyPublisher() }
        let url = URL(string: "https://cdn.jsdelivr.net/gh/fawazahmed0/currency-api@1/latest/currencies/\(from)/\(to).json")
        return APIManager.shared.createGetRequest(url: url, header: nil)
    }
    
    func updateExchange() {
        checkExchange(from: from, to: to).assign(to: \.currency.value, on: self).store(in: &bag)
    }
    
    func swapFields() {
        (self.from, self.to) = (self.to, self.from)
        updateExchange()
        
    }
    
    func swap(fromAmount: Double, toAmount: Double) {
        RealmManager.shared.swap(from, to: to, fromAmount: fromAmount, toAmount: toAmount)
    }
}
