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
    
    private let channel = ChannelData()
    
//    /// 유튜브 API 데이터
//    private var items: [Item] = []
//    
//    //    var channelItems: [ChannelItem] = []
//    private var channelItems: [String: ChannelItem] = [:]
    
    private var channelCollectionView: ChannelCollectionView = {
        let view = ChannelCollectionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var tabViewCollectionView: TabButtonCollectionView = {
        let view = TabButtonCollectionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var videoTableView: VideoTableView = {
        let view = VideoTableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

//    private var refreshControl = UIRefreshControl()
    
    /// ,,,
    private var channelViewHeightConstraint: NSLayoutConstraint!
    private var tabViewHeightConstraint: NSLayoutConstraint!
    
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
        
        videoTableView.parentViewController = self
        
        videoTableView.requestInSubscribeVC()
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
            videoTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
}

// MARK: - 화면전환

extension SubscribeViewController {
    
    private func presentVideoViewController(with item: Item) {
        let url = URL(string: "https://www.youtube.com/embed/" + item.id)!
        
        print("⭐️⭐️⭐️⭐️⭐️\(url)⭐️⭐️⭐️⭐️")
        let videoViewController = VideoViewController()
        

        // ☀️ 이런식으로 Item을 다 받아와야 확장성있게 데이터를 사용할 수 있음...
//        let videoItems = videoTableView.getVideoItems()
//        videoViewController.currentItem = videoItems
        
        videoViewController.videoURL = url
        videoViewController.videoTitle = item.snippet.title
        videoViewController.videoPublishedAt = item.snippet.publishedAt
        // videoViewController.videoDescription = video.description
        
        videoViewController.modalPresentationStyle = .overFullScreen
        videoViewController.modalTransitionStyle = .coverVertical
        present(videoViewController, animated: true, completion: nil)
    }
    
}

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
