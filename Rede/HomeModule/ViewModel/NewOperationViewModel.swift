//
//  NewOperationViewModel.swift
//  Rede
//
//  Created by Иван Викторович on 17.04.2022.
//

import UIKit
import Combine

class NewOperationViewModel: BaseViewModel {
    
    var bag: Set<AnyCancellable> = []
    
    var type: CategoryType
    
    var categories = CurrentValueSubject<[Category], Never>([])

    init(type: CategoryType) {
        self.type = type
        let allCategoris = RealmManager.shared.fetchSpecificCategories(type: type)
        categories.send(allCategoris.filter({ $0.categoryType == type }))
    }
    
    func createNewOperation(category: Category, amount: Double, date: Date = Date()) {
        RealmManager.shared.addOperation(category: category, amount: amount, currency: CurrencyManager.shared.currentCurrency, date: date)
    }
    
    func searchCategory(string: String) {
        let allCategoris = RealmManager.shared.fetchSpecificCategories(type: type)
        guard !string.isEmpty else {
            categories.send(allCategoris.filter({ $0.categoryType == type }))
            return
        }
        let searchedCategories = allCategoris.filter({ $0.name.lowercased().contains(string.lowercased()) })
        categories.send(searchedCategories)
    }
    
}
