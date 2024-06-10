//
//  TabButtonCollectionViewFlowLayout.swift
//  YouTubeClone
//
//  Created by yujaehong on 5/30/24.
//

import UIKit

final class TabButtonCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    private func setLayout() {
        scrollDirection = .horizontal
    }
}
