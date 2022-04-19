//
//  Category.swift
//  MoneySaver
//
//  Created by Иван Викторович on 13.04.2022.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @Persisted var emoji: String = "🫥"
    @Persisted var name: String
    @Persisted private var type: String
    @Persisted var isHidden: Bool = false
    @Persisted var categoryType: CategoryType
    
    
}

enum CategoryType: String, PersistableEnum {
    case earn
    case spend
    case none
}
