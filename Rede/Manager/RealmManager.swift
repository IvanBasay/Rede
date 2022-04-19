//
//  RealmManager.swift
//  MoneySaver
//
//  Created by Иван Викторович on 13.04.2022.
//

import Foundation
import RealmSwift
import Combine

class RealmManager {
    
    private(set) var localRealm: Realm?
    
    static let shared = RealmManager()
    
    let shouldUpdateData = PassthroughSubject<Void, Never>()
    
    private init() {
        openRealm()
    }
    
    func openRealm() {
        do {
            let config = Realm.Configuration(schemaVersion: 1, migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion > 1 {
                    
                }
            })

            Realm.Configuration.defaultConfiguration = config

            localRealm = try Realm()
        } catch {
            print("Error opening Realm", error)
        }
    }
    
    func fetchAllOperations(currency: Currency) -> [Operation] {
        if let localRealm = localRealm {
            let monthPredicate = NSPredicate(format: "currency == %@", currency.rawValue)
            let monthOperations = localRealm.objects(Operation.self).filter(monthPredicate)
            return monthOperations.sorted(by: { $0.date > $1.date })
        }
        return []
    }
    
    func fetchLastOperations(currency: Currency) -> [Operation] {
        if let localRealm = localRealm {
            let monthPredicate = NSPredicate(format: "currency == %@ AND date >= %@ AND date <= %@", currency.rawValue, Date().startOfMonth() as CVarArg, Date().endOfMonth() as CVarArg)
            let monthOperations = localRealm.objects(Operation.self).filter(monthPredicate)
            return monthOperations.sorted(by: { $0.date > $1.date })
        }
        return []
    }
    
    func fetchTopInfo(currency: Currency) -> TopInfo {
        if let localRealm = localRealm {
            
            let monthPredicate = NSPredicate(format: "currency == %@ AND date >= %@ AND date <= %@", currency.rawValue, Date().startOfMonth() as CVarArg, Date().endOfMonth() as CVarArg)
            let monthOperations = localRealm.objects(Operation.self).filter(monthPredicate)
            let beforeMothDate: Date = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
            let beforeMonthPredicate = NSPredicate(format: "currency == %@ AND date >= %@ AND date <= %@", currency.rawValue, beforeMothDate.startOfMonth() as CVarArg, beforeMothDate.endOfMonth() as CVarArg)
            let beforeMonthOperations = localRealm.objects(Operation.self).filter(beforeMonthPredicate)
            
            let beforeEarn = beforeMonthOperations.filter({ $0.category?.categoryType == .earn }).map({ $0.amount }).reduce(0, +)
            let beforeSpend = beforeMonthOperations.filter({ $0.category?.categoryType == .spend }).map({ $0.amount }).reduce(0, +)
            
            let earning = monthOperations.filter({ $0.category?.categoryType == .earn }).map({ $0.amount }).reduce(0, +)
            let spending = monthOperations.filter({ $0.category?.categoryType == .spend }).map({ $0.amount }).reduce(0, +)
            
                
            var compareEarn = earning/beforeEarn
            var compareSpend = spending/beforeSpend
            
            if !compareEarn.isNormal {
                compareEarn = 0
            }
            
            if !compareSpend.isNormal {
                compareSpend = 0
            }
            
            return TopInfo(earned: earning, spended: spending, earnCompare: compareEarn, spendCompare: compareSpend)
            
        }
        return TopInfo(earned: 0, spended: 0)
    }
    
    func fetchAllCategories() -> [Category] {
        if let localRealm = localRealm {
            let allCategories = localRealm.objects(Category.self).filter("isHidden == false")
            return Array(allCategories)
        }
        return []
    }
    
    func fetchSpecificCategories(type: CategoryType) -> [Category] {
        if let localRealm = localRealm {
            let allCategories = localRealm.objects(Category.self).filter("isHidden == false AND categoryType == %@", type.rawValue)
            return Array(allCategories)
        }
        return []
    }
    
    func fetchBalance(currency: Currency) -> Balance {
        if let localRealm = localRealm {
            let balance = localRealm.objects(Balance.self).filter("currency == %@", currency.rawValue)
            return balance.first ?? Balance()
        }
        
        return Balance()
    }
    
    func setupFirstLaunchRealm() {
        addStandartCategories()
        addBalanceObjects()
    }
    
    
    
    func swap(_ from: Currency, to: Currency, fromAmount: Double, toAmount: Double) {
        let hiddenCategories = getHiddenCategories()
        guard let swapTo = hiddenCategories.first(where: { $0.name == "Swap" && $0.isHidden && $0.categoryType == .earn }), let swapFrom = hiddenCategories.first(where: { $0.name == "Swap" && $0.isHidden && $0.categoryType == .spend }) else { return }
        
        addOperation(category: swapFrom, amount: fromAmount, currency: from)
        addOperation(category: swapTo, amount: toAmount, currency: to)
        
        
    }
    
    func addOperation(category: Category, amount: Double, currency: Currency, date: Date = Date()) {
        let balance = fetchBalance(currency: currency)
        if let realm = localRealm {
            do {
                try realm.write({
                    let newOperation = Operation()
                    newOperation.category = category
                    newOperation.amount = amount
                    newOperation.date = date
                    newOperation.currency = currency
                    realm.add(newOperation)
                    
                    if category.categoryType == .spend {
                        balance.balance -= amount
                    } else {
                        balance.balance += amount
                    }
                    
                    shouldUpdateData.send()
                    print("Successed")
                })
            } catch {
                print("Error save new operation", error.localizedDescription)
            }
        }
    }
    
    func addCategory(name: String, emoji: String = "🫥", type: CategoryType) {
        if let realm = localRealm {
            do {
                try realm.write({
                    let newCategory = Category()
                    newCategory.emoji = emoji
                    newCategory.name = name
                    newCategory.categoryType = type
                    realm.add(newCategory)
                    shouldUpdateData.send()
                    print("Successed")
                })
            } catch {
                print("Error save new category", error.localizedDescription)
            }
        }
    }
    
    private func addBalanceObjects() {
        let usd = Balance()
        usd.balance = 0
        usd.currency = .usd
        let uah = Balance()
        uah.balance = 0
        uah.currency = .uah
        
        if let realm = localRealm {
            do {
                try realm.write({
                    realm.add([uah, usd])
                    shouldUpdateData.send()
                })
            } catch {
                print("Can't add standart categories, error: ", error.localizedDescription)
            }
        }
    }
    
    private func getHiddenCategories() -> [Category] {
        if let localRealm = localRealm {
            let predicate = NSPredicate(format: "isHidden == true")
            return Array(localRealm.objects(Category.self).filter(predicate))
        }
        
        return []
    }
    
    private func addStandartCategories() {
        if let realm = localRealm {
            do {
                try realm.write({
                    realm.add(StandartCategories.getStandartCategoriesArray())
                    shouldUpdateData.send()
                })
            } catch {
                print("Can't add standart categories, error: ", error.localizedDescription)
            }
        }
    }
    
}
