//  VideoViewController.swift
//  YouTubeClone
//
//  Created by yujaehong on 6/1/24.
//

import UIKit
import AVKit
import WebKit

class DetailVideoViewController: UIViewController {
    
    // MARK: - Properties
    
    private var detailViewModel: DetailViewModel?
    
    var subsribeViewController: UIViewController?
    
    var item: Item?
    
    var channelItem: ChannelItem?
    
    private var comments: [CommentThread] = []
    
    var videoURL: URL?
    
    var detailVideoView: DetailVideoView?
    
    // MARK: - LifeCycle
    // 기본 init 추가
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    // 새로운 init 메서드에 super.init 호출 추가
    convenience init(viewController: UIViewController?,
                     item: Item?,
                     videoURL: URL?) {
        self.init(nibName: nil, bundle: nil)
        self.subsribeViewController = viewController
        self.item = item
        self.videoURL = videoURL
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailVideoView = DetailVideoView(frame: view.bounds)
        
        if let detailVideoView = detailVideoView {
            detailVideoView.tableView.parentViewController = self.subsribeViewController
            view.addSubview(detailVideoView)
        }
        
        detailViewModel = DetailViewModel(item: item,
                                          channelItem: channelItem,
                                          videoURL: videoURL)
        detailViewModel?.requestCommentsAPI(item: item)
        
        setupVideoPlayer()
        setupData()
        
        detailVideoView?.tableView.requestInVideoVC()
    }
    
    deinit {
        print("VideoViewController 해제")
    }
    
    // MARK: - Methods
    
    private func setupData() {
        
        guard let detailViewModel = detailViewModel,
              let detailVideoView = detailVideoView else { return }
        
        detailVideoView.titleLabel.text = detailViewModel.title
        detailVideoView.subtitleLabel.text = "조회수 \(detailViewModel.viewCount!)  \(detailViewModel.videoPulished!)"
        detailVideoView.channelTitleLabel.text = detailViewModel.channelTitle
        detailVideoView.subscriberCountLabel.text = detailViewModel.subscriberCount
        
        if let channelImageURL = detailViewModel.channelImageUrl {
            detailViewModel.setImage(for: detailVideoView.profileImageButton)
        }
    }
    
    func setupVideoPlayer() {
        guard let videoURL = detailViewModel?.videoURL,
              let detailVideoView = detailVideoView else { return }
        let request = URLRequest(url: videoURL)
        detailVideoView.webView.load(request)
        detailVideoView.webView.uiDelegate = self
    }
}

// MARK: - WKUIDelegate

extension DetailVideoViewController: WKUIDelegate {}

// MARK: - UIScrollViewDelegate

//extension DetailVideoViewController: UIScrollViewDelegate {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.contentOffset.y < 0 {
//            scrollView.contentOffset.y = 0
//        }
//    }
//}

//extension DetailVideoViewController {
//    
//    func requestCommentsAPI() {
//        guard let videoID = item?.id else {
//            print("Video ID가 없습니다.")
//            return
//        }
//        
//        APIManager.shared.requestCommentsAPIData(videoId: videoID.videoId, maxResults: 1) { [weak self] result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let comments):
//                    self?.comments = comments
//                    if let firstComment = comments.first {
//                        self?.detailVideoView?.commentLabel.text = firstComment.snippet.topLevelComment.snippet.textOriginal
//                    }
//                    print("👿👿👿👿\(comments)")
//                case .failure(let error):
//                    print("Failed to fetch comments: \(error)")
//                }
//            }
//        }
//    }
//}
