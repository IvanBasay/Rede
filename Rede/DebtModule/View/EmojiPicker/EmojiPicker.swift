//
//  EmojiPicker.swift
//  Rede
//
//  Created by Иван Викторович on 20.04.2022.
//

import UIKit
import Combine

class EmojiPicker: UICollectionView {
    
    typealias EmojiPickedDetails = (index: Int, emoji: String)
    
    var allEmojies: [String] = [] {
        didSet {
            self.reloadData()
            if !allEmojies.isEmpty {
                changeItem.send((0, allEmojies.first ?? "🫥"))
            }
        }
    }
    
    var changeItem = PassthroughSubject<EmojiPickedDetails, Never>()
    var currentEmoji: String?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let carousel = CarouselLayout()
        carousel.sideItemScale = 0.7
        carousel.spacingMode = .fixed(spacing: 40)
        carousel.itemSize = CGSize(width: 50, height: 50)
        carousel.scrollDirection = .horizontal
        super.init(frame: frame, collectionViewLayout: carousel)
        loadXib()
        getAllEmojies()
        self.showsHorizontalScrollIndicator = false
        self.dataSource = self
        self.delegate = self
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        let carousel = CarouselLayout()
        carousel.sideItemScale = 0.7
        carousel.spacingMode = .fixed(spacing: 25)
        carousel.itemSize = CGSize(width: 50, height: 50)
        carousel.scrollDirection = .horizontal
        self.collectionViewLayout = carousel
        loadXib()
        getAllEmojies()
        self.showsHorizontalScrollIndicator = false
        self.dataSource = self
        self.delegate = self
    }
    
    private func getAllEmojies() {
        var array: [String] = []
        for i in 0x1F601...0x1F64F {
            let c = String(UnicodeScalar(i) ?? "-")
            array.append(c)
        }
        allEmojies = array
        currentEmoji = allEmojies.first
    }
    
    private func loadXib() {
        self.register(UINib(nibName: "EmojiCell", bundle: .main), forCellWithReuseIdentifier: "cell")
    }

}

extension EmojiPicker: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allEmojies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? EmojiCell else { return UICollectionViewCell() }
        cell.emoji = allEmojies[indexPath.row]
        return cell
    }
    
    
}

extension EmojiPicker: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentIndex = Int(scrollView.contentOffset.x) / 67
        print(Int(scrollView.contentOffset.x))
        print(currentIndex)
        currentEmoji = allEmojies[currentIndex]
        changeItem.send((currentIndex, allEmojies[currentIndex]))
    }
}
