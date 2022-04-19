//
//  SwapVC.swift
//  Rede
//
//  Created by Иван Викторович on 16.04.2022.
//

import UIKit
import CombineCocoa

class SwapVC: BaseViewController {

    @IBOutlet weak var toTF: PaddingTextField!
    @IBOutlet weak var fromTF: PaddingTextField!
    @IBOutlet weak var swapFieldsButton: UIButton!
    @IBOutlet weak var swapButton: UIButton!
    @IBOutlet weak var swichSync: UIButton!
    
    var viewModel: SwapViewModel!
    
    override func bind() {
        
        swichSync.isHidden = !Reachability.isConnectedToNetwork()
        
        viewModel.currency
            .sink { [weak self] in
                guard let exchange = $0 else { return }
                self?.calculateExchange(exchange)
            }
            .store(in: &bag)
        
        swapFieldsButton.tapPublisher
            .sink { [weak self] _ in
                self?.swapFieldCurrency()
            }
            .store(in: &bag)
        
        fromTF.textPublisher
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink { [weak self] in self?.fromTextChanged(text: $0 ?? "") }.store(in: &bag)
        
        swichSync.tapPublisher.sink { [weak self] _ in self?.syncSwiched() }.store(in: &bag)
        
        swapButton.tapPublisher.sink { [weak self] _ in self?.swapTapped() }.store(in: &bag)
    }
    
    override func configUI() {
        fromTF.text = "100"

        fromTF.backgroundColor = Color.lightGray
        fromTF.cornerRadius(10)
        
        toTF.backgroundColor = Color.lightGray
        toTF.cornerRadius(10)
        
        fromTF.addRightCurrencyView(currency: viewModel.from)
        toTF.addRightCurrencyView(currency: viewModel.to)
        fromTF.addLeftCurrencyView(currency: viewModel.from)
        toTF.addLeftCurrencyView(currency: viewModel.to)
        
        if viewModel.isSyncEnabled {
            swichSync.setTitle("Disable sync", for: .normal)
        } else {
            swichSync.setTitle("Enable sync", for: .normal)
        }
        
        swapButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -24).isActive = true
        
        swapButton.cornerRadius(10)
    }
    
    private func syncSwiched() {
        viewModel.isSyncEnabled = !viewModel.isSyncEnabled
        
        if viewModel.isSyncEnabled {
            swichSync.setTitle("Disable sync", for: .normal)
        } else {
            swichSync.setTitle("Enable sync", for: .normal)
        }
        
        viewModel.updateExchange()
    }
    
    private func calculateExchange(_ exchange: ExchangeResponse) {
        let fromDoubleValue = Double(fromTF.text ?? "1") ?? 1
        let exchangeCourse = exchange.value
        let amountStirng = (fromDoubleValue * exchangeCourse).roundString(to: 2)
        toTF.text = "\(amountStirng)"
    }
    
    private func swapFieldCurrency() {
        viewModel.swapFields()
        fromTF.addRightCurrencyView(currency: viewModel.from)
        toTF.addRightCurrencyView(currency: viewModel.to)
        fromTF.addLeftCurrencyView(currency: viewModel.from)
        toTF.addLeftCurrencyView(currency: viewModel.to)
        
        if viewModel.isSyncEnabled {
            fromTF.text = toTF.text
            viewModel.updateExchange()
        } else {
            (fromTF.text, toTF.text) = (toTF.text, fromTF.text)
        }
    }
    
    private func fromTextChanged(text: String) {
        if Double(text.replacingOccurrences(of: ",", with: ".")) != nil {
            viewModel.updateExchange()
        }
    }
    
    private func swapTapped() {
        if let fromAmount = Double(fromTF.text ?? ""), let toAmount = Double(toTF.text ?? "") {
            guard RealmManager.shared.fetchTopInfo(currency: viewModel.from).balance > fromAmount else {
                SystemMessageView().show(message: "Not enought balance", type: .error)
                return
            }
            viewModel.swap(fromAmount: fromAmount, toAmount: toAmount)
            dismiss(animated: true)
        } else {
            SystemMessageView().show(message: "Wront data", type: .error)
        }
    }
}
