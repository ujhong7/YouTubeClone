//
//  VideoViewController.swift
//  YouTubeClone
//
//  Created by yujaehong on 6/1/24.
//

import UIKit
import AVKit
import WebKit

class DetailVideoViewController: UIViewController, WKUIDelegate, UIGestureRecognizerDelegate {
    
    // MARK: - Properties
    
    private var detailViewModel: DetailViewModel?
    
    var item: Item?
    
    var channelItem: ChannelItem?
    
    /// 댓글 API 데이터 받기위한 배열
    private var comments: [CommentThread] = []
    
    var videoURL: URL?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    private let profileImageButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .systemGray6
        button.contentMode = .scaleAspectFill
        button.widthAnchor.constraint(equalToConstant: 36).isActive = true
        button.heightAnchor.constraint(equalToConstant: 36).isActive = true
        button.layer.cornerRadius = 36 / 2
        button.layer.masksToBounds = true
        return button
    }()
    
    private lazy var channelTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    private lazy var subscriberCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private var tabViewCollectionView: TabButtonCollectionView = {
        let view = TabButtonCollectionView(postion: .detailViewController)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let commentView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var commentDetailView: CommentDetailView? = nil
    
    private let commentTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "댓글"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    private lazy var commentCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.text = "댓글입니다."
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    var tableView: VideoTableView = {
        let tableView = VideoTableView()
        tableView.isPresentAnimation = false // VideoViewController 에 존재하는 tableView 를 클릭했을땐 present 애니메이션이 없어야하므로 false 로 설정
        return tableView
    }()
    
    private var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()   // WKWebView 설정을 위한 WKWebViewConfiguration 생성
        webConfiguration.allowsInlineMediaPlayback = true // 인라인 재생 활성화 (전체화면x)⭐️
        let wkWebView = WKWebView(frame: .zero, configuration: webConfiguration)
        return wkWebView
    }()
    
    private var panGestureRecognizer: UIPanGestureRecognizer!
    
    let scrollView = UIScrollView()
    
    let contentView = UIView()
    
    var tableViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        detailViewModel = DetailViewModel(item: item,
                                          channelItem: channelItem,
                                          videoURL: videoURL)
        detailViewModel?.requestCommentsAPI(item: item)
        
        setupVideoPlayer()
        setupAutoLayout()
        setupCollectionView()
        setupTapGesture()
        setupPanGesture()

        setupData()
        
        // TODO: - tableView API 호춣
        tableView.requestInVideoVC()
    }
    
    deinit {
        print("VideoViewController 해제")
    }
    
    // MARK: - Methods
    
    private func setupData() {
        
        guard let detailViewModel = detailViewModel else { return }

        titleLabel.text = detailViewModel.title
        subtitleLabel.text = "조회수 \(detailViewModel.viewCount!)  \(detailViewModel.videoPulished!)"
        channelTitleLabel.text = detailViewModel.channelTitle
        subscriberCountLabel.text = detailViewModel.subscriberCount
        
        if let channelImageURL = detailViewModel.channelImageUrl {
            detailViewModel.setImage(for: profileImageButton)
        }
    }
    
    func setupVideoPlayer() {
        guard let videoURL = detailViewModel?.videoURL else { return }
        let request = URLRequest(url: videoURL)
        webView.load(request)
        self.webView.uiDelegate = self
    }
    
    private func setupCollectionView() {
        tabViewCollectionView.register(TabButtonCollectionViewCell.self, forCellWithReuseIdentifier: "TabButtonCell")
    }
    
    func setupTapGesture() {
        print(#function)
        // 탭 제스처 인식기 추가
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCommentViewTap))
        commentView.addGestureRecognizer(tapGesture)
    }
    
    func setupPanGesture() {
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        webView.addGestureRecognizer(panGestureRecognizer)
        panGestureRecognizer.delegate = self // 이 줄 추가
    }
}

// MARK: - @ojbc

extension DetailVideoViewController {
    
    /// 댓글뷰 탭했을때 댓글화면 올라오기
    @objc private func handleCommentViewTap() {
        print(#function)
        // videoID가 존재하는지 확인하고 안전하게 언래핑
        guard let videoID = detailViewModel?.item?.id else {
            print("Video ID가 없습니다.")
            return
        }
        
        commentDetailView = CommentDetailView()
        
        if let commentDetailView = commentDetailView {
            commentDetailView.requestCommentsAPI(videoID: videoID.videoId)
            view.addSubview(commentDetailView)
            commentDetailView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                commentDetailView.topAnchor.constraint(equalTo: webView.bottomAnchor),
                commentDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                commentDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                commentDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
            
            commentDetailView.transform = CGAffineTransform(translationX: 0, y: 300)
            UIView.animate(withDuration: 0.3) {
                commentDetailView.transform = .identity
            }
        }
    }
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
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

// MARK: - Autolayout

extension DetailVideoViewController {
    
    func setupAutoLayout() {
        [scrollView, contentView, webView, titleLabel, subtitleLabel, profileImageButton, channelTitleLabel, subscriberCountLabel, tabViewCollectionView, commentView, commentTitleLabel, commentCountLabel, commentLabel, tableView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        view.addSubview(webView)
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        [titleLabel, subtitleLabel, profileImageButton, channelTitleLabel, subscriberCountLabel, tabViewCollectionView, commentView, tableView].forEach { contentView.addSubview($0) }
        
        [commentTitleLabel, commentCountLabel, commentLabel].forEach { commentView.addSubview($0) }
        
        // 테이블 뷰의 높이 제약 조건 설정
        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 400) // 임시 높이
        tableViewHeightConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 212),
            
            scrollView.topAnchor.constraint(equalTo: webView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 13),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -13),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 13),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -13),
            
            profileImageButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 12),
            profileImageButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 13),
            profileImageButton.heightAnchor.constraint(equalToConstant: 40),
            profileImageButton.widthAnchor.constraint(equalToConstant: 40),
            
            channelTitleLabel.centerYAnchor.constraint(equalTo: profileImageButton.centerYAnchor),
            channelTitleLabel.leadingAnchor.constraint(equalTo: profileImageButton.trailingAnchor, constant: 9),
            
            subscriberCountLabel.centerYAnchor.constraint(equalTo: channelTitleLabel.centerYAnchor),
            subscriberCountLabel.leadingAnchor.constraint(equalTo: channelTitleLabel.trailingAnchor, constant: 9),
            
            tabViewCollectionView.topAnchor.constraint(equalTo: profileImageButton.bottomAnchor, constant: 16),
            tabViewCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tabViewCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tabViewCollectionView.heightAnchor.constraint(equalToConstant: 48),
            
            commentView.topAnchor.constraint(equalTo: tabViewCollectionView.bottomAnchor, constant: 16),
            commentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 13),
            commentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -13),
            commentView.heightAnchor.constraint(equalToConstant: 65),
            
            commentTitleLabel.topAnchor.constraint(equalTo: commentView.topAnchor, constant: 12),
            commentTitleLabel.leadingAnchor.constraint(equalTo: commentView.leadingAnchor, constant: 10),
            
            commentCountLabel.topAnchor.constraint(equalTo: commentView.topAnchor, constant: 15),
            commentCountLabel.leadingAnchor.constraint(equalTo: commentTitleLabel.trailingAnchor, constant: 5),
            
            commentLabel.topAnchor.constraint(equalTo: commentTitleLabel.bottomAnchor, constant: 8),
            commentLabel.leadingAnchor.constraint(equalTo: commentView.leadingAnchor, constant: 10),
            commentLabel.trailingAnchor.constraint(equalTo: commentView.trailingAnchor, constant: -10),
            
            tableView.topAnchor.constraint(equalTo: commentView.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            tableViewHeightConstraint // 테이블뷰의 높이 제약 조건 활성화
        ])
        
        // 테이블뷰의 고유한 크기를 동적으로 설정
        tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    // ⭐️
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize", let tableView = object as? UITableView {
            tableViewHeightConstraint.constant = tableView.contentSize.height
        }
    }
}

// MARK: - UIScrollViewDelegate

extension DetailVideoViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.contentOffset.y = 0
        }
    }
}

extension DetailVideoViewController {
    
    func requestCommentsAPI() {
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
                        self?.commentLabel.text = firstComment.snippet.topLevelComment.snippet.textOriginal
                    }
                    print("👿👿👿👿\(comments)")
                case .failure(let error):
                    print("Failed to fetch comments: \(error)")
                }
            }
        }
    }
}
