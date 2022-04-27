//
//  Contact.swift
//  Rede
//
//  Created by Иван Викторович on 20.04.2022.
//

import Foundation
import RealmSwift

class Contact: Object {
    
    @Persisted var name: String
    @Persisted var emoji: String
    @Persisted var phoneNumber: String?
    @Persisted var cardNumber: String?
    @Persisted var itsMe: Bool = false
}
