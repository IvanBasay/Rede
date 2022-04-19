//
//  BaseViewController.swift
//  Rede
//
//  Created by Иван Викторович on 15.04.2022.
//

import Foundation
import UIKit
import Combine

class BaseViewController: UIViewController {
    
    var bag = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bind()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unbind()
    }
    
    func bind() { }
    
    func configUI() { }
    
    func unbind() {
        bag.removeAll()
    }
    
    
}
