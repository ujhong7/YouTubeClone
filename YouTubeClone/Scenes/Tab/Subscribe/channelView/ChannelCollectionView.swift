//
//  YouTuberIconsCollectionView.swift
//  youtubeSubsTab
//
//  Created by yujaehong on 5/7/24.
//

import UIKit

final class ChannelCollectionView: UICollectionView {
    
    // MARK: - Properties
    
    private let channel: [Channel] = Channel.mock
    private var selectedIndexPath: IndexPath?
    var onDataReceived: (([Item]) -> Void)?
    
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
        register(ChannelCollectionViewCell.self, forCellWithReuseIdentifier: "ChannelCollectionViewCell")
        dataSource = self
        delegate = self
    }
    
}

// MARK: - UICollectionViewDataSource

extension ChannelCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return channel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChannelCollectionViewCell", for: indexPath) as! ChannelCollectionViewCell
        let channel = channel[indexPath.row]
        cell.configure(channel)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension ChannelCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 이전에 선택된 셀의 배경색 초기화
        if let selectedIndexPath = selectedIndexPath,
           let previousCell = collectionView.cellForItem(at: selectedIndexPath) as? ChannelCollectionViewCell {
            previousCell.resetBackgroundColor()
        }
        
        if let cell = collectionView.cellForItem(at: indexPath) as? ChannelCollectionViewCell {
            
            cell.changeSelectedBackgroundColor()
            
            let id = channel[indexPath.row].id
            
            APIManager.shared.requestSubscribeVideoData(id: id) { result in
                switch result {
                case .success(let data):
                    self.onDataReceived?(data)
                case .failure(_):
                    print(#fileID, #function, #line, "🐧 결과값이 존재하지 않습니다.")
                }
            }
        }
        
        // 선택된 셀의 인덱스 업데이트
        selectedIndexPath = indexPath
    }
}
