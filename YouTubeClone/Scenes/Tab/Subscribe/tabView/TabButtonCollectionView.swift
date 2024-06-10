//
//  TabButtonsCollectionView.swift
//  youtubeSubsTab
//
//  Created by yujaehong on 5/7/24.
//

import UIKit

final class TabButtonCollectionView: UICollectionView {
    
    // MARK: - Properties
    
    private let tabTitles = ["전체", "오늘", "동영상", "Shorts",
                             "이어서 시청하기", "라이브", "게시물"]
    
    // MARK: - Init
    
    init(layout: TabButtonCollectionViewFlowLayout) {
        super.init(frame: .zero, collectionViewLayout: layout)
        configureCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        let layout = TabButtonCollectionViewFlowLayout()
        self.init(layout: layout)
    }
    
    // MARK: - Methods
    
    private func configureCollectionView() {
        backgroundColor = .systemBackground
        showsHorizontalScrollIndicator = false
        register(TabButtonCollectionViewCell.self, forCellWithReuseIdentifier: "TabButtonCell")
        dataSource = self
        delegate = self
    }
    
    private func calculateCellSize(for indexPath: IndexPath) -> CGSize {
        let tabTitle = tabTitles[indexPath.row]
        let font = UIFont.systemFont(ofSize: 14)
        let padding: CGFloat = 22
        let size = (tabTitle as NSString).size(withAttributes: [.font: font])
        let width = size.width + padding
        return CGSize(width: width, height: bounds.height)
    }
}

// MARK: - UICollectionViewDataSource

extension TabButtonCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabButtonCell", for: indexPath) as! TabButtonCollectionViewCell
        let tabTitle = tabTitles[indexPath.row]
        cell.configure(text: tabTitle)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension TabButtonCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Tab \(tabTitles[indexPath.row]) was selected.")
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TabButtonCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return calculateCellSize(for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 9, bottom: 0, right: 9)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
}
