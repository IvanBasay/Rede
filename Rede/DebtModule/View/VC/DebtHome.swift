//
//  DebtHome.swift
//  Rede
//
//  Created by Иван Викторович on 20.04.2022.
//

import UIKit
import CombineCocoa

class DebtHome: BaseViewController {

    @IBOutlet weak var addNewIOweButton: UIButton!
    @IBOutlet weak var iOweCV: UICollectionView!
    @IBOutlet weak var addNewOweMeButton: UIButton!
    @IBOutlet weak var oweMeCV: UICollectionView!
    @IBOutlet weak var decorTopView: UIView!
    
    let barButton = UIBarButtonItem()
    
    private var viewModel = DebtHomeViewModel()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.changeBarTo(appearence: .black)
    }
    
    override func bind() {
        viewModel.updateDebts()
        
        viewModel.iOweDebts
            .sink { [weak self] _ in self?.iOweCV.reloadData(); self?.checkEmpty() }
            .store(in: &bag)
        
        viewModel.oweMeDebts
            .sink { [weak self] _ in self?.oweMeCV.reloadData(); self?.checkEmpty() }
            .store(in: &bag)
        
        barButton.tapPublisher
            .sink { [weak self] _ in self?.addNewContactTapped() }
            .store(in: &bag)
        
        addNewIOweButton.tapPublisher
            .sink { [weak self] _ in self?.addNewIOwe() }
            .store(in: &bag)
        
        addNewOweMeButton.tapPublisher
            .sink { [weak self] _ in self?.addNewOweMe() }
            .store(in: &bag)
        
        RealmManager.shared.shouldUpdateData
            .sink { [weak self] _ in self?.viewModel.updateDebts() }
            .store(in: &bag)
    }
    
    override func configUI() {
        loadXib()
        decorTopView.cornerRadius(50)
        decorTopView.layer.maskedCorners = [.layerMinXMaxYCorner]
        iOweCV.dataSource = self
        iOweCV.delegate = self
        iOweCV.contentInset.left = 24
        iOweCV.contentInset.right = 24
        oweMeCV.contentInset.left = 24
        oweMeCV.contentInset.right = 24
        oweMeCV.dataSource = self
        oweMeCV.delegate = self
        navigationItem.title = "Debts control"
        

        
        createNavBarButton()
    }
    
    private func checkEmpty() {
        if viewModel.oweMeDebts.value.isEmpty {
            let label = UILabel()
            label.textColor = Color.darkGray
            label.text = "No debtors"
            label.font = UIFont(name: "Nunito-SemiBold", size: 18)!
            label.textAlignment = .center
            label.sizeToFit()
            oweMeCV.backgroundView = label
        } else {
            oweMeCV.backgroundView = nil
        }
        
        if viewModel.iOweDebts.value.isEmpty {
            let label = UILabel()
            label.textColor = Color.lightGray
            label.text = "You are not a debtor"
            label.font = UIFont(name: "Nunito-SemiBold", size: 18)!
            label.textAlignment = .center
            label.sizeToFit()
            iOweCV.backgroundView = label
        } else {
            iOweCV.backgroundView = nil
        }
    }
    
    private func createNavBarButton() {
        barButton.title = nil
        barButton.image = UIImage(named: "add_user_icon")
        barButton.tintColor = Color.white
        barButton.width = 24
        navigationItem.setRightBarButton(barButton, animated: false)
    }
    
    private func loadXib() {
        iOweCV.register(UINib(nibName: "IOweCVCell", bundle: .main), forCellWithReuseIdentifier: "iOweCell")
        oweMeCV.register(UINib(nibName: "OweMeCVCell", bundle: .main), forCellWithReuseIdentifier: "oweMeCell")
    }
    
    private func addNewContactTapped() {
        let vc = StoryboardReferenceBuilder.shared.buildReference(forController: AddContactVC.self, storyboard: .debt)!
        vc.viewModel = AddContactViewModel()
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
    }
    
    private func addNewIOwe() {
        guard !RealmManager.shared.fetchContacts().isEmpty else {
            SystemMessageView().show(message: "Add contacts first", type: .error)
            return
        }
        let vc = StoryboardReferenceBuilder.shared.buildReference(forController: AddDebtVC.self, storyboard: .debt)!
        vc.viewModel = AddDebtViewModel(type: .iOwe)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func addNewOweMe() {
        guard !RealmManager.shared.fetchContacts().isEmpty else {
            SystemMessageView().show(message: "Add contacts first", type: .error)
            return
        }
        let vc = StoryboardReferenceBuilder.shared.buildReference(forController: AddDebtVC.self, storyboard: .debt)!
        vc.viewModel = AddDebtViewModel(type: .OweMe)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension DebtHome: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == iOweCV {
            return viewModel.iOweDebts.value.count
        } else {
            return viewModel.oweMeDebts.value.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == iOweCV {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "iOweCell", for: indexPath) as? IOweCVCell else { return UICollectionViewCell() }
            cell.debt = viewModel.iOweDebts.value[indexPath.row]
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "oweMeCell", for: indexPath) as? OweMeCVCell else { return UICollectionViewCell() }
            cell.debt = viewModel.oweMeDebts.value[indexPath.row]
            return cell
        }
    }
    
    
}

extension DebtHome: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == iOweCV {
            guard let cell = collectionView.cellForItem(at: indexPath) as? IOweCVCell else { return }
            if let debt = cell.debt {
                let vc = StoryboardReferenceBuilder.shared.buildReference(forController: CloseDebtVC.self, storyboard: .debt)!
                vc.viewModel = CloseDebtViewModel(debt: debt)
                navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            guard let cell = collectionView.cellForItem(at: indexPath) as? OweMeCVCell else { return }
            if let debt = cell.debt {
                let vc = StoryboardReferenceBuilder.shared.buildReference(forController: CloseDebtVC.self, storyboard: .debt)!
                vc.viewModel = CloseDebtViewModel(debt: debt)
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == iOweCV {
            return CGSize(width: 140, height: 170)
        } else {
            return CGSize(width: 120, height: 200)
        }
    }
}
