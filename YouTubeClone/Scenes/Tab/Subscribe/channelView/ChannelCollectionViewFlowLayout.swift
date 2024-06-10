//
//  ChannelCollectionViewFlowLayout.swift
//  YouTubeClone
//
//  Created by yujaehong on 5/30/24.
//

import UIKit

final class ChannelCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    private func setLayout() {
        scrollDirection = .horizontal
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        itemSize = CGSize(width: 72, height: 104)
    }
}
