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
    
    var videos: [Video] = []
    
    /// API 호출 후 데이터를 받기위한 배열
    var items: [Item] = []
    
    private var channelItems: [String: ChannelItem] = [:]
    
    private var comments: [CommentThread] = []
    
    var videoID: String?
    
    var videoURL: URL?
    
    var videoTitle: String?
    
    var videoPublishedAt: String?
    
    var viewCount: String?
    
    var channelTitle: String?
    
    var commentCount: String?
    
    var channelImageURL: String?
    
    var subscriberCount: String?
    
    weak var parentTableView: UITableView?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = videoTitle
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "조회수 \(viewCount!)  \(videoPublishedAt!)"
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
        label.text = channelTitle
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    private lazy var subscriberCountLabel: UILabel = {
        let label = UILabel()
        label.text = Int(subscriberCount!)?.formattedSubscriberCount()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private var tabViewCollectionView: TabButtonCollectionView = {
        let view = TabButtonCollectionView()
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
        // label.text = commentCount
        label.text = "\(commentCount ?? "0") 개"
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.text = "댓글입니다."
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private var tableView: UITableView = {
        let tableView =  UITableView(frame: .zero)
        return tableView
    }()
    
//    private var tableView: DetailVideoTableView = {
//        let view = DetailVideoTableView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
    
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
        requestYouTubeAPI()
        loadChannelImage()
        setupVideoPlayer()
        setupAutoLayout()
        setupTableView()
        setupCollectionView()
        setupTapGesture()
        setupPanGesture()
        setupScrollView()
        requestCommentsAPI()
    }
    
    deinit {
        print("VideoViewController 해제")
    }
    
    // MARK: - Methods
    
    private func loadChannelImage() {
        guard let channelImageURLString = channelImageURL, let url = URL(string: channelImageURLString) else {
            return
        }
        setImage(for: profileImageButton, from: url)
    }
    
    private func setImage(for button: UIButton, from url: URL) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
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
    
    func setupVideoPlayer() {
        guard let videoURL = videoURL else { return }
        let request = URLRequest(url: videoURL)
        webView.load(request)
        webView.uiDelegate = self
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(VideoTableViewCell.self, forCellReuseIdentifier: "VideoCell")
    }
    
    private func setupScrollView() {
        scrollView.delegate = self
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
    
    @objc private func handleCommentViewTap() {
        print(#function)
        // videoID가 존재하는지 확인하고 안전하게 언래핑
        guard let videoID = videoID else {
            print("Video ID가 없습니다.")
            return
        }
        
        commentDetailView = CommentDetailView()
        
        if let commentDetailView = commentDetailView {
            commentDetailView.requestCommentsAPI(videoID: videoID)
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
    
    @objc func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - Autolayout

extension DetailVideoViewController {
    
    func setupAutoLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        webView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        profileImageButton.translatesAutoresizingMaskIntoConstraints = false
        channelTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subscriberCountLabel.translatesAutoresizingMaskIntoConstraints = false
        tabViewCollectionView.translatesAutoresizingMaskIntoConstraints = false
        commentView.translatesAutoresizingMaskIntoConstraints = false
        commentTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        commentCountLabel.translatesAutoresizingMaskIntoConstraints = false
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(webView)
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(profileImageButton)
        contentView.addSubview(channelTitleLabel)
        contentView.addSubview(subscriberCountLabel)
        contentView.addSubview(tabViewCollectionView)
        contentView.addSubview(commentView)
        contentView.addSubview(tableView)
        
        commentView.addSubview(commentTitleLabel)
        commentView.addSubview(commentCountLabel)
        commentView.addSubview(commentLabel)
        
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

// MARK: - 비디오 to 비디오
extension DetailVideoViewController {
    
    // MARK: - Networking
    private func requestYouTubeAPI() {
        print(#function)
        APIManager.shared.requestYouTubeAPIData { [weak self] result in
            switch result {
            case .success(let data):
                dump(data)
                DispatchQueue.main.async {
                    self?.items = data
                    
                    // ☀️ 이런식으로 필터 (필터할때 가장 좋은 방법은 고유 ID로 비교)
                    // self?.items = data.filter { $0.id != self?.videoTitle}
                    
                    self?.tableView.reloadData()
                    //self?.refreshControl.endRefreshing() // refresh종료를 위해..
                }
                
                // channelId를 추출하고 requestChannelProfileImageAPI 호출
                data.forEach { item in
                    // 'Item' 모델에 'channelId'가 있다고 가정
                    self?.requestChannelProfileImageAPI(with: item.snippet.channelId)
                    
                }
                
            case .failure(let error):
                print("데이터를 받아오는데 실패했습니다: \(error)")
                // self?.refreshControl.endRefreshing()
            }
        }
    }
    
    private func requestChannelProfileImageAPI(with channelId: String) {
        print(#function)
        APIManager.shared.requestChannelAPIData(channelId: channelId) { [weak self] result in
            switch result {
            case .success(let data):
                dump(data)
                DispatchQueue.main.async {
                    // channelId를 키로 하여 channelItems 딕셔너리에 추가
                    //                    self?.channelItems[channelId] = data
                    self?.channelItems[channelId] = data.first
                    self?.tableView.reloadData() // 새로운 데이터로 테이블 뷰 갱신
                }
            case .failure(let error):
                print("에러: \(error)")
            }
        }
    }
    
    // MARK: - 화면전환
    private func presentVideoViewController(with item: Item) {
        print(#function)
        
        print("⭐️⭐️⭐️⭐️⭐️\(url)⭐️⭐️⭐️⭐️")
        
        let videoViewController = DetailVideoViewController()
        videoViewController.videoID = item.id
        videoViewController.videoURL = url
        videoViewController.videoTitle = item.snippet.title
        videoViewController.videoPublishedAt = item.snippet.publishedAt.toDate()?.timeAgoSinceDate()
        videoViewController.viewCount = Int(item.statistics.viewCount)?.formattedViewCount()
        videoViewController.channelTitle = item.snippet.channelTitle
        videoViewController.commentCount = item.statistics.commentCount
        
        // 채널이미지, 채널구독자 수
        if let channelItem = channelItems[item.snippet.channelId] {
            videoViewController.channelImageURL = channelItem.snippet.thumbnails.high.url
            videoViewController.subscriberCount = channelItem.statistics.subscriberCount
        }
    }
    
}

// MARK: - UITableViewDataSource

extension DetailVideoViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as? VideoTableViewCell else {
            return UITableViewCell()
        }
        
        let item = items[indexPath.row]
        
        // item의 channelId를 사용하여 channelItems 딕셔너리에서 해당 채널 데이터 찾기
        
        if let channelItem = channelItems[item.snippet.channelId] {
            cell.configure(item: item, channelItem: channelItem)
        } else {
            // 채널 데이터가 없는 경우, 기본 정보만으로 셀 구성
            // ???
        }
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension DetailVideoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 306
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
        let item = items[indexPath.row]
        presentVideoViewController(with: item)
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
         guard let videoID = videoID else {
             print("Video ID가 없습니다.")
             return
         }
         
         APIManager.shared.requestCommentsAPIData(videoId: videoID, maxResults: 1) { [weak self] result in
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
