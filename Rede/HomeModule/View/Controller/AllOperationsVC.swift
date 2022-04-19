//
//  AllOperationsVC.swift
//  Rede
//
//  Created by Иван Викторович on 19.04.2022.
//

import UIKit

class AllOperationsVC: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: AllOperationsViewModel = AllOperationsViewModel()
    
    override func configUI() {
        navigationItem.title = "Operations"
        tableView.separatorStyle = .none
        loadXib()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 56
        tableView.sectionHeaderHeight = 40
        tableView.allowsSelection = false
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        
        emptyScreen(viewModel.operations.value.isEmpty)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func emptyScreen(_ bool: Bool) {
        if bool {
            let label = UILabel()
            label.textColor = Color.darkGray
            label.text = "No operations. Time to add your first!"
            label.font = UIFont(name: "Nunito-SemiBold", size: 14)!
            label.textAlignment = .center
            tableView.backgroundView = label
        } else {
            tableView.backgroundView = nil
        }
    }
    
    private func loadXib() {
        tableView.register(UINib(nibName: "AllOperationCell", bundle: .main), forCellReuseIdentifier: "cell")
    }
    
}

extension AllOperationsVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.operations.value.keys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.operations.value[section]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? AllOperationCell else { return UITableViewCell() }
        cell.operation = viewModel.operations.value[indexPath.section]?[indexPath.row]
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = Color.lightGray
        } else {
            cell.backgroundColor = Color.white
        }
        return cell
    }
}

extension AllOperationsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let header = UIView(frame: )
//        header.backgroundColor = view.backgroundColor
        let label = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: tableView.frame.width, height: 40)))
        label.backgroundColor = Color.white
        label.font = UIFont(name: "Nunito-Bold", size: 10)!
        label.textColor = Color.black
        label.textAlignment = .center
        let date = viewModel.operations.value[section]?.first?.date
        if date?.startOfDay == Date().startOfDay {
            label.text = "Today"
        } else if date?.startOfDay == Date().startOfDay.addingTimeInterval(-10).startOfDay {
            label.text = "Yesterday"
        } else {
            label.text = date?.toString(format: "MMM d, yyyy") ?? ""
        }
        return label
    }
}
