//
//  ViewController.swift
//  Rede
//
//  Created by Иван Викторович on 14.04.2022.
//

import UIKit
import CombineCocoa

class HomeVC: BaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var currencySwitcher: CurrencySwapView!
    @IBOutlet weak var earnLabel: UILabel!
    @IBOutlet weak var spendLabel: UILabel!
    @IBOutlet weak var spendButton: UIButton!
    @IBOutlet weak var earnButton: UIButton!
    @IBOutlet weak var circleEarnCompare: CircleProgressView!
    @IBOutlet weak var circleSpendCompare: CircleProgressView!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var showMoreOperationsButton: UIButton!
    @IBOutlet weak var latestOpearionsCV: UICollectionView!
    @IBOutlet weak var swapButton: UIButton!
    
    var viewModel: HomeViewModel = HomeViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        currencySwitcher.update()

    }
    
    // MARK: - Combine
    
    override func bind() {
                
        viewModel.topInfo.sink { [weak self] in self?.topInfoChanged($0) }.store(in: &bag)
        viewModel.latesOperations.sink { [weak self] in self?.latesOperationsChanged($0) }.store(in: &bag)
        
        earnButton.tapPublisher.sink { [weak self] _ in self?.earnTapped() }.store(in: &bag)
        
        spendButton.tapPublisher.sink { [weak self] _ in self?.spendTapped() }.store(in: &bag)
        
        swapButton.tapPublisher.sink { [weak self] _ in self?.swapTapped() }.store(in: &bag)
        
        showMoreOperationsButton.tapPublisher.sink { [weak self] _ in self?.showMoreOperationsTapped() }.store(in: &bag)
        
    }
    
    func randomBetween(start: Date, end: Date) -> Date {
        var date1 = start
        var date2 = end
        if date2 < date1 {
            let temp = date1
            date1 = date2
            date2 = temp
        }
        let span = TimeInterval.random(in: date1.timeIntervalSinceNow...date2.timeIntervalSinceNow)
        return Date(timeIntervalSinceNow: span)
    }
    
    // MARK: - Data
    
    private func topInfoChanged(_ topInfo: TopInfo) {
        let currency = CurrencyManager.shared.currentCurrency.rawValue
                
        earnLabel.text = "\(currency) \(topInfo.earned.roundString(to: 2))"
        spendLabel.text = "\(currency) \(topInfo.spended.roundString(to: 2))"
        balanceLabel.text = "\(currency) \(topInfo.balance.roundString(to: 2))"
        
        circleEarnCompare.title = "x\(topInfo.earnCompare.roundString(to: 1))"
        circleEarnCompare.subtitle = "Earn"
        circleEarnCompare.percent = topInfo.earnCompare
        
        circleSpendCompare.title = "x\(topInfo.spendCompare.roundString(to: 1))"
        circleSpendCompare.subtitle = "Spend"
        circleSpendCompare.percent = topInfo.spendCompare
        
    }
    
    private func latesOperationsChanged(_ operations: [Operation]) {
        circleEarnCompare.progressColor = Color.green
        circleSpendCompare.progressColor = Color.red
        latestOpearionsCV.reloadData()
    }
    
    // MARK: - UI
    
    override func configUI() {
        loadXib()
        scrollView.contentInset.bottom = 30
        latestOpearionsCV.dataSource = self
        latestOpearionsCV.delegate = self
        latestOpearionsCV.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        titleLabel.text = "Rede"
    }
    
    private func loadXib() {
        latestOpearionsCV.register(UINib(nibName: "LatestOperationCell", bundle: .main), forCellWithReuseIdentifier: "cell")
    }
    
    // MARK: - Actions
    
    private func earnTapped() {
        let vc = StoryboardReferenceBuilder.shared.buildReference(forController: NewOperationVC.self, storyboard: .main)!
        vc.viewModel = NewOperationViewModel(type: .earn)
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func spendTapped() {
        let vc = StoryboardReferenceBuilder.shared.buildReference(forController: NewOperationVC.self, storyboard: .main)!
        vc.viewModel = NewOperationViewModel(type: .spend)
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func swapTapped() {
        let vc = StoryboardReferenceBuilder.shared.buildReference(forController: SwapVC.self, storyboard: .main)!
        if CurrencyManager.shared.currentCurrency == .uah {
            vc.viewModel = SwapViewModel(to: .usd, from: .uah)
        } else {
            vc.viewModel = SwapViewModel(to: .uah, from: .usd)
        }
        present(vc, animated: true)
    }
    
    private func showMoreOperationsTapped() {
        let vc = StoryboardReferenceBuilder.shared.buildReference(forController: AllOperationsVC.self, storyboard: .main)!
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: - DataSource

extension HomeVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.latesOperations.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? LatestOperationCell else { return UICollectionViewCell() }
        cell.operation = viewModel.latesOperations.value[indexPath.row]
        return cell
    }
    
}

// MARK: - Delegate

extension HomeVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 110, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
}

