//
//  VideoTableViewModel.swift
//  YouTubeClone
//
//  Created by yujaehong on 7/3/24.
//

import UIKit

final class VideoTableViewModel {
    
    // MARK: - Properties
    
    private(set) var items: [Item] = []
    private(set) var channelItems: [String: ChannelItem] = [:]
    var isPresentAnimation: Bool = true
    
    var updateTableViewClosure: (() -> Void)?
    
    // MARK: - Methods
    
    func fetchVideos() {
        requestYouTubeAPI()
    }
    
    func updateVideos(_ videos: [Item], completion: @escaping () -> Void) {
        self.items = videos
        self.items.forEach { item in
            self.requestChannelProfileImageAPI(with: item.snippet.channelId)
        }
        self.updateTableViewClosure?()
        completion()
    }
    
    private func requestYouTubeAPI() {
        APIManager.shared.requestYouTubeAPIData { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.items = data
                    self?.updateTableViewClosure?()
                }
                data.forEach { item in
                    self?.requestChannelProfileImageAPI(with: item.snippet.channelId)
                }
            case .failure(let error):
                print("데이터를 받아오는데 실패했습니다: \(error)")
            }
        }
    }
    
    private func requestChannelProfileImageAPI(with channelId: String) {
        APIManager.shared.requestChannelAPIData(channelId: channelId) { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.channelItems[channelId] = data.first
                    self?.updateTableViewClosure?()
                }
            case .failure(let error):
                print("에러: \(error)")
            }
        }
    }
}
