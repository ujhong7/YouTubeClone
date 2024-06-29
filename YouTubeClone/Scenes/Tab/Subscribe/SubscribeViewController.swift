//
//  SubscribeViewController.swift
//  YouTubeClone
//
//  Created by yujaehong on 4/15/24.
//

import UIKit

final class SubscribeViewController: UIViewController {
    
    struct UI {
        /// 비디오 테이블 뷰의 높이
        static let tableHeight: CGFloat = 306
        static let channelViewHeight: CGFloat = 104
        static let tabViewHeight: CGFloat = 48
    }
    
    // MARK: - Properties
    
    private let tabTitles = ["전체", "오늘", "동영상", "Shorts",
                             "이어서 시청하기", "라이브", "게시물"]
    
    private var channelCollectionView: ChannelCollectionView = {
        let view = ChannelCollectionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var tabViewCollectionView: TabButtonCollectionView = {
        let view = TabButtonCollectionView(postion: .subscribe)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var videoTableView: VideoTableView = {
        let view = VideoTableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// 구독 클릭시 생성되는 테이블뷰
    private var subscribeTableView: VideoTableView = {
        let view = VideoTableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

//    private var refreshControl = UIRefreshControl()
    
    /// 제약조건 설정을 위한 프로퍼티
    private var channelViewHeightConstraint: NSLayoutConstraint!
    private var tabViewHeightConstraint: NSLayoutConstraint!
    private var subscribeTableViewTopConstraint: NSLayoutConstraint!
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLeftNavigationItem()
        setupRightNavigationItems()
        configure()
        setupAutoLayout()
        //setupRefreshControl()
    }
    
    // MARK: - Methods
    
    private func setupLeftNavigationItem() {
        let logoImage = UIImage(named: "YouTubeLogo")
        let logoImageView = UIImageView(image: logoImage)
        logoImageView.contentMode = .scaleAspectFit
        let logoItem = UIBarButtonItem(customView: logoImageView)
        navigationItem.leftBarButtonItem = logoItem
    }
    
    private func setupRightNavigationItems() {
        let windowSharingButton = UIBarButtonItem(image: UIImage(named: "windowSharingIcon"), style: .plain, target: self, action: #selector(windowSharingButtonTapped))
        let notificationButton = UIBarButtonItem(image: UIImage(named: "NotificationIcon"), style: .plain, target: self, action: #selector(notificationButtonTapped))
        let searchButton = UIBarButtonItem(image: UIImage(named: "SearchIcon"), style: .plain, target: self, action: #selector(searchButtonTapped))
        navigationItem.rightBarButtonItems = [searchButton, notificationButton, windowSharingButton]
    }
    
    private func configure() {
        view.backgroundColor = .systemBackground
        view.addSubview(channelCollectionView)
        view.addSubview(tabViewCollectionView)
        view.addSubview(videoTableView)
        view.addSubview(subscribeTableView)
        
        videoTableView.parentViewController = self
        
        videoTableView.requestInSubscribeVC()
        
        /// 구독 채널 클릭했을때 좌측 상단 네비게이션바 버튼 수정 + 테이블뷰 생성
        channelCollectionView.onDataReceived = { [weak self] videos in
            
            if let channelTitle = videos.first?.snippet.channelTitle {
                self?.setupSubscribeLeftNavigationItem(title: channelTitle)
            }
            
            self?.subscribeTableView.updateVideos(videos) {
                self?.showSubscribeTableView()
            }
        }
    }
    
    /// 구독 채널 클릭시 좌측 상단 네비게이션바 설정
    func setupSubscribeLeftNavigationItem(title: String) {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.setTitle(title, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        button.tintColor = .black
        button.addTarget(self, action: #selector(hideSubscribeTableView), for: .touchUpInside)
        button.sizeToFit()
        let barButtonItem = UIBarButtonItem(customView: button)
        navigationItem.leftBarButtonItem = barButtonItem
    }
    
    private func showSubscribeTableView() {
        [tabViewCollectionView, videoTableView].forEach { view in
            view.isHidden = true
        }
        animateSubscribeTableView(isShow: true)
    }

    /// 구독 채널을 눌렀을때 올라오는 테이블뷰를 닫기 위함
    @objc private func hideSubscribeTableView() {
        setupLeftNavigationItem()
        [tabViewCollectionView, videoTableView].forEach { view in
            view.isHidden = false
        }
        animateSubscribeTableView(isShow: false)
    }
    
    private func animateSubscribeTableView(isShow: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.subscribeTableViewTopConstraint.constant = isShow ? 0 : 800
            
            UIView.animate(withDuration: 0.3) {
                self?.view.layoutIfNeeded()
            }
        }
    }
    
//    private func setupRefreshControl() {
//        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
//        videoTableView.refreshControl = refreshControl
//    }
    
}

// MARK: - @objc

extension SubscribeViewController {
    
    @objc func windowSharingButtonTapped() {
        print(#function)
    }
    
    @objc func notificationButtonTapped() {
        print(#function)
    }
    
    @objc func searchButtonTapped() {
        print(#function)
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
//    @objc private func refreshData() {
//        print(#function)
//        // 리프레시 인디케이터가 잠시 고정되도록
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
//            self.requestYouTubeAPI()
//        }
//    }
    
}

// MARK: - Layout

extension SubscribeViewController {
    
    private func setupAutoLayout() {
        channelViewHeightConstraint = channelCollectionView.heightAnchor.constraint(equalToConstant: UI.channelViewHeight)
        tabViewHeightConstraint = tabViewCollectionView.heightAnchor.constraint(equalToConstant: UI.tabViewHeight)
        subscribeTableViewTopConstraint = subscribeTableView.topAnchor.constraint(equalTo: channelCollectionView.bottomAnchor, constant: 800)

        
        NSLayoutConstraint.activate([
            channelCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            channelCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            channelCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            channelCollectionView.heightAnchor.constraint(equalToConstant: 104),
            channelViewHeightConstraint,
            
            tabViewCollectionView.topAnchor.constraint(equalTo: channelCollectionView.bottomAnchor),
            tabViewCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tabViewCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tabViewCollectionView.heightAnchor.constraint(equalToConstant: 48),
            tabViewHeightConstraint,
            
            videoTableView.topAnchor.constraint(equalTo: tabViewCollectionView.bottomAnchor),
            videoTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            videoTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            videoTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            subscribeTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            subscribeTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            subscribeTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            subscribeTableViewTopConstraint
        ])
    }
    
}

// MARK: - 화면전환

extension SubscribeViewController {
    
    private func presentVideoViewController(with item: Item) {
        let url = URL(string: "https://www.youtube.com/embed/" + item.id.videoId)!
        
        print("⭐️⭐️⭐️⭐️⭐️\(url)⭐️⭐️⭐️⭐️")
        let videoViewController = DetailVideoViewController()
        

        // ☀️ 이런식으로 Item을 다 받아와야 확장성있게 데이터를 사용할 수 있음...
//        let videoItems = videoTableView.getVideoItems()
//        videoViewController.currentItem = videoItems
        
//        videoViewController.videoURL = url
//        videoViewController.videoTitle = item.snippet.title
//        videoViewController.videoPublishedAt = item.snippet.publishedAt
        
        videoViewController.videoURL = url
        videoViewController.item = item  // Item 객체를 전달
        // videoViewController.videoDescription = video.description
        
        videoViewController.modalPresentationStyle = .overFullScreen
        videoViewController.modalTransitionStyle = .coverVertical
        present(videoViewController, animated: true, completion: nil)
    }
    
}

//>>>>>>> development
// MARK: - UIScrollViewDelegate

extension SubscribeViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= 100 {
            DispatchQueue.main.async { [weak self] in
                self?.channelViewHeightConstraint.constant = 0
                self?.tabViewHeightConstraint.constant = 0
                
                UIView.animate {
                    self?.view.layoutIfNeeded()
                }
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.channelViewHeightConstraint.constant = UI.channelViewHeight
                self?.tabViewHeightConstraint.constant = UI.tabViewHeight
                UIView.animate {
                    self?.view.layoutIfNeeded()
                }
            }
        }
    }
    
}
