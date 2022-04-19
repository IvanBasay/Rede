//
//  StandartCategories.swift
//  Rede
//
//  Created by Иван Викторович on 15.04.2022.
//

import Foundation

struct StandartCategories {
    
    static func getStandartCategoriesArray() -> [Category] {
        let array = [
            StandartCategories.createCategory(emoji: "🛒", name: "Shopping", type: .spend),
            StandartCategories.createCategory(emoji: "🥗", name: "Food", type: .spend),
            StandartCategories.createCategory(emoji: "🍹", name: "Alcohol", type: .spend),
            StandartCategories.createCategory(emoji: "🏆", name: "Sports", type: .spend),
            StandartCategories.createCategory(emoji: "💰", name: "Salary", type: .earn),
            StandartCategories.createCategory(emoji: "🎓", name: "Education", type: .spend),
            StandartCategories.createCategory(emoji: "🧧", name: "Gift", type: .earn),
            StandartCategories.createCategory(emoji: "🚘", name: "Car", type: .spend),
            StandartCategories.createCategory(emoji: "🏥", name: "Health", type: .spend),
            StandartCategories.createCategory(emoji: "🚍", name: "Transport", type: .spend),
            StandartCategories.createCategory(emoji: "🎮", name: "Fun", type: .spend),
            StandartCategories.createCategory(emoji: "🏡", name: "House", type: .spend),
            StandartCategories.createCategory(emoji: "🍣", name: "Eating out", type: .spend),
            StandartCategories.createCategory(emoji: "🛁", name: "Toiletry", type: .spend),
            StandartCategories.createCategory(emoji: "🚖", name: "Taxi", type: .spend),
//            StandartCategories.createCategory(emoji: "👔", name: "Cloth", type: .spend),
            StandartCategories.createCategory(emoji: "🐶", name: "Pets", type: .spend),
            StandartCategories.createCategory(emoji: "🎁", name: "Gifts", type: .spend),
            StandartCategories.createCategory(emoji: "📞", name: "Phone", type: .spend),
            StandartCategories.createCategory(emoji: "💇", name: "Beauty", type: .spend),
            StandartCategories.createCategory(emoji: "📅", name: "Rental", type: .spend),
            StandartCategories.createCategory(emoji: "👶", name: "Kids", type: .spend),
            StandartCategories.createCategory(emoji: "🙏", name: "Tithe", type: .spend),
            StandartCategories.createCategory(emoji: "🎗", name: "Charity", type: .spend),
            StandartCategories.createCategory(emoji: "🛩", name: "Travel", type: .spend),
            StandartCategories.createCategory(emoji: "🧖", name: "SPA", type: .spend),
            StandartCategories.createCategory(emoji: "🧾", name: "Bills", type: .spend),
            StandartCategories.createCategory(emoji: "🔨", name: "Repair", type: .spend),
            StandartCategories.createCategory(emoji: "👮", name: "Penalties", type: .spend),
            StandartCategories.createCategory(emoji: "🏛", name: "Taxes", type: .spend),
            StandartCategories.createCategory(emoji: "🏘", name: "Property", type: .spend),
            StandartCategories.createCategory(emoji: "🤑", name: "Passive income", type: .earn),
            StandartCategories.createCategory(emoji: "💸", name: "Deposits", type: .earn),
            StandartCategories.createCategory(emoji: "🔀", name: "Swap", type: .earn, isHidden: true),
            StandartCategories.createCategory(emoji: "🔀", name: "Swap", type: .spend, isHidden: true)
        ]
        
        return array
    }
    
    static func createCategory(emoji: String, name: String, type: CategoryType, isHidden: Bool = false) -> Category {
        let category = Category()
        category.categoryType = type
        category.emoji = emoji
        category.name = name
        category.isHidden = isHidden
        return category
    }
    
}
