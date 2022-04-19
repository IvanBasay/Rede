//
//  BaseViewModel.swift
//  Rede
//
//  Created by Иван Викторович on 15.04.2022.
//

import Foundation
import Combine

protocol BaseViewModel {
    
    var bag: Set<AnyCancellable> { get set }
    
}
