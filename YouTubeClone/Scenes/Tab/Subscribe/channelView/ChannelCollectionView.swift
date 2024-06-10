//
//  YouTuberIconsCollectionView.swift
//  youtubeSubsTab
//
//  Created by yujaehong on 5/7/24.
//

import UIKit

final class ChannelCollectionView: UICollectionView {
    
    // MARK: - Properties
    
    private let channel = ChannelData()
    
    // MARK: - Init
    
    init(layout: UICollectionViewFlowLayout) {
        super.init(frame: .zero, collectionViewLayout: layout)
        configureCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        let layout = ChannelCollectionViewFlowLayout()
        self.init(layout: layout)
    }
    
    // MARK: - Methods

    private func configureCollectionView() {
        backgroundColor = .systemBackground
        showsHorizontalScrollIndicator = false
        register(ChannelCollectionViewCell.self, forCellWithReuseIdentifier: "ChannelCVC")
        dataSource = self
        delegate = self
    }
    
}

// MARK: - UICollectionViewDataSource

extension ChannelCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return channel.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChannelCVC", for: indexPath) as! ChannelCollectionViewCell
        cell.setData(image: channel.list[indexPath.row].makeIamge(), name: channel.list[indexPath.row].name)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension ChannelCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Channel \(channel.list[indexPath.row]) was selected.")
    }
}
