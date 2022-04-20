//
//  NewOperationVC.swift
//  Rede
//
//  Created by Иван Викторович on 17.04.2022.
//

import UIKit
import CombineCocoa

class NewOperationVC: BaseViewController {
    
    @IBOutlet weak var searchTF: PaddingTextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var currencyBatItem: UIBarButtonItem!
    
    var pickedIndex: Int?
    var previusSelectedCell: NewOperationCell?
    
    var viewModel: NewOperationViewModel!
    
    override func bind() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        viewModel.categories.sink { [weak self] _ in self?.tableView.reloadData() }.store(in: &bag)
        
        NewOperationAction.shared.saveNewOperationTapped.sink { [weak self] in
            
            self?.viewModel.createNewOperation(category: $0.category, amount: $0.amount, date: $0.date)
            
            self?.tableView.beginUpdates()
            self?.previusSelectedCell?.cellSelected = false
            self?.previusSelectedCell = nil
            self?.tableView.endUpdates()
            
            self?.view.endEditing(true)

            
        }.store(in: &bag)
        
        CurrencyManager.shared.currencyChanged
            .sink { [weak self] in
                if let cell = self?.previusSelectedCell {
                    cell.currency = $0
                } else {
                    self?.tableView.reloadData()
                }
                
            }.store(in: &bag)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        previusSelectedCell?.cellSelected = false
        pickedIndex = nil
        previusSelectedCell = nil
    }
    
    override func configUI() {
        loadXib()
        searchTF.addTarget(self, action: #selector(searchText(_:)), for: .editingChanged)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.separatorStyle = .none
        
        searchTF.backgroundColor = Color.lightGray
        searchTF.placeholder = "Search category"
        searchTF.cornerRadius(8)
        
        navigationItem.title = "\(viewModel.type)".capitalized
        
        configCurrencySwapper()
    }
    
    private func configCurrencySwapper() {
        let swapper = CurrencySwapView(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 30)))
        currencyBatItem.title = ""
        swapper.translatesAutoresizingMaskIntoConstraints = false
        currencyBatItem.customView = swapper
        swapper.widthAnchor.constraint(equalToConstant: 100).isActive = true
        swapper.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    private func loadXib() {
        tableView.register(UINib(nibName: "NewOperationCell", bundle: .main), forCellReuseIdentifier: "cell")
    }
    
    @objc private func searchText(_ tf: PaddingTextField) {
        pickedIndex = nil
        previusSelectedCell = nil
        viewModel.searchCategory(string: tf.text ?? "")
    }
}

extension NewOperationVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.categories.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? NewOperationCell else { return UITableViewCell() }
        if let index = pickedIndex {
            cell.cellSelected = index == indexPath.row
        } else {
            cell.cellSelected = false
        }
        cell.category = viewModel.categories.value[indexPath.row]
        return cell
    }
}

extension NewOperationVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? NewOperationCell else { return }
        pickedIndex = indexPath.row
        previusSelectedCell?.cellSelected = false
        if cell == previusSelectedCell {
            tableView.beginUpdates()
            cell.cellSelected = false
            tableView.endUpdates()
            previusSelectedCell = nil
            return
        }
        previusSelectedCell = cell
        tableView.beginUpdates()
        cell.cellSelected = !cell.cellSelected
        tableView.endUpdates()
    }
}
