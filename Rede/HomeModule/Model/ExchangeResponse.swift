//
//  ExchangeResponse.swift
//  Rede
//
//  Created by Иван Викторович on 16.04.2022.
//

import Foundation

struct ExchangeResponse: Decodable {
    
    var currency: Currency
    var value: Double
    var date: Date?
    
    init() {
        self.currency = .uah
        self.value = 0
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let currency = container.allKeys.filter { $0.stringValue == "usd" || $0.stringValue == "uah" }.first!
        let date = try container.decode(String.self, forKey: container.allKeys.first(where: { $0.stringValue == "date" })!)
        let currencyMean = try container.decode(Double.self, forKey: currency)
        
        if currency.stringValue == "usd" {
            self.currency = .usd
        } else {
            self.currency = .uah
        }
        
        self.value = currencyMean
        self.date = date.toDate(format: "yyyy-MM-dd")
    }
    
    struct CodingKeys: CodingKey, Hashable {
        var stringValue: String
        
        init(stringValue: String) {
            self.stringValue = stringValue
        }
        
        var intValue: Int? {
            return nil
        }
        
        init?(intValue: Int) {
            return nil
        }
    }
    
}
