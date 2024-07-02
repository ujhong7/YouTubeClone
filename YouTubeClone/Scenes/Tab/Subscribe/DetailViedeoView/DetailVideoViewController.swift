//  VideoViewController.swift
//  YouTubeClone
//
//  Created by yujaehong on 6/1/24.
//

import UIKit
import AVKit
import WebKit

class DetailVideoViewController: UIViewController, WKUIDelegate {
    
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
        setupBindings()
        detailVideoView?.tableView.requestInVideoVC()
        
        detailVideoView?.delegate = self
    }
    
    deinit {
        print("VideoViewController 해제")
    }
    
    // MARK: - Methods
    
    private func setupBindings() {
        guard let detailViewModel = detailViewModel,
              let detailVideoView = detailVideoView else { return }
        
        detailVideoView.titleLabel.text = detailViewModel.title
        detailVideoView.subtitleLabel.text = "조회수 \(detailViewModel.viewCount!)  \(detailViewModel.videoPulished!)"
        detailVideoView.channelTitleLabel.text = detailViewModel.channelTitle
        detailVideoView.subscriberCountLabel.text = detailViewModel.subscriberCount
        detailVideoView.commentCountLabel.text = detailViewModel.commentCount

        if let channelImageURL = detailViewModel.channelImageUrl {
            detailViewModel.setImage(for: detailVideoView.profileImageButton)
        }
        
        detailViewModel.didUpdateComments = { [weak self] in
            guard let self = self, let detailViewModel = self.detailViewModel else { return }
            detailVideoView.commentLabel.text = detailViewModel.comment
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

extension DetailVideoViewController: DetailVideoViewDelegate {
    
    func handleCommentViewTap() {
        print("Comment view tapped")
        // 여기에 실제 코멘트 뷰 탭 핸들러 로직 추가
        print(#function)
        // videoID가 존재하는지 확인하고 안전하게 언래핑
        guard let videoID = detailViewModel?.item?.id else {
            print("Video ID가 없습니다.")
            return
        }
        
        // CommentDetailView 초기화
        let commentDetailView = CommentDetailView()
        view.addSubview(commentDetailView)
        commentDetailView.setupConstraints(relativeTo: view, webView: detailVideoView!.webView)
        
        // CommentDetailViewModel을 통해 댓글 데이터 요청
        commentDetailView.fetchComments(for: videoID.videoId)
        
        commentDetailView.transform = CGAffineTransform(translationX: 0, y: 300)
        UIView.animate(withDuration: 0.3) {
            commentDetailView.transform = .identity
        }
    }
    
    func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        // 여기에 실제 팬 제스처 핸들러 로직 추가
        // Pan gesture handling logic
        let translation = gesture.translation(in: view)
        let velocity = gesture.velocity(in: view)
        
        switch gesture.state {
        case .changed:
            if translation.y > 0 {
                view.transform = CGAffineTransform(translationX: 0, y: translation.y)
            }
        case .ended:
            if translation.y > 100 || velocity.y > 500 {
                dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.transform = .identity
                })
            }
        default:
            break
            
        }
    }
}
