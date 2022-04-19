//
//  UDKey.swift
//  MoneySaver
//
//  Created by Иван Викторович on 13.04.2022.
//

import Foundation

class UDKey {
    
    static var isNotFirstLaunch: Bool {
        get { return UserDefaults.standard.bool(forKey: "isFirstLaunch") }
        set { UserDefaults.standard.set(newValue, forKey: "isFirstLaunch") }
    }
    
    static var currency: Currency {
        get { return Currency(rawValue: UserDefaults.standard.string(forKey: "currency") ?? "unknown") ?? .unknown }
        set { UserDefaults.standard.set(newValue.rawValue, forKey: "currency") }
    }
    
}
