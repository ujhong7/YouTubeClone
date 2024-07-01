//
//  DetailViewModel.swift
//  YouTubeClone
//
//  Created by Kant on 6/29/24.
//

import UIKit

final class DetailViewModel {
    
    var item: Item? // 이미 상위에서 전달주는 값
    var channelItem: ChannelItem?
    var videoURL: URL?
    /// 댓글 API 데이터 받기위한 배열
    private var comments: [CommentThread] = []
    private lazy var commentDetailView: CommentDetailView? = nil
    
    private(set) var title: String?
    private(set) var videoPulished: String?
    private(set) var viewCount: String?
    private(set) var channelTitle: String?
    private(set) var subtitle: String?
    private(set) var commentCount: String?
    private(set) var subscriberCount: String?
    private(set) var channelImageUrl: URL?
    private(set) var channelImage: UIImage?
    private(set) var comment: String?
    
    // 댓글 데이터가 업데이트되었을 때 호출될 클로저
    var didUpdateComments: (() -> Void)?
    
    init(item: Item?, channelItem: ChannelItem?, videoURL: URL?) {
        self.item = item
        self.channelItem = channelItem
        self.videoURL = videoURL
        
        setupData()
    }
    
    private func setupData() {
        guard let item = item else { return }
        
        title = item.snippet.title
        videoPulished = item.snippet.publishedAt.toDate()?.timeAgoSinceDate()
        viewCount = Int(item.statistics?.viewCount ?? "0")?.formattedViewCount()
        channelTitle = item.snippet.channelTitle
        commentCount = item.statistics?.commentCount
        
        if let urlString = channelItem?.snippet.thumbnails.high.url, let url = URL(string: urlString) {
            channelImageUrl = url
        }
        
    }
    
    func requestCommentsAPI(item: Item?) {
        guard let videoID = item?.id else {
            print("Video ID가 없습니다.")
            return
        }
        
        APIManager.shared.requestCommentsAPIData(videoId: videoID.videoId, maxResults: 1) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let comments):
                    self?.comments = comments
                    if let firstComment = comments.first {
                        self?.comment = firstComment.snippet.topLevelComment.snippet.textOriginal
                    }
                    self?.didUpdateComments?()
                    print("👿👿👿👿\(comments)")
                case .failure(let error):
                    print("Failed to fetch comments: \(error)")
                }
            }
        }
    }
    
    func setImage(for button: UIButton) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: self.channelImageUrl!), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    button.setImage(image, for: .normal)
                }
            } else {
                DispatchQueue.main.async {
                    // Handle error case here if needed
                }
            }
        }
    }
}
