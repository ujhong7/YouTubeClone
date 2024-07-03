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
        
        videoTableView.parentViewController = self
        
        videoTableView.requestInSubscribeVC()
        
        channelCollectionView.onDataReceived = { [weak self] videos in
            
//            self?.tabViewCollectionView.isHidden = true
            
            if let channelTitle = videos.first?.snippet.channelTitle {
                self?.setupSubscribeLeftNavigationItem(title: channelTitle)
            }
            
            self?.videoTableView.updateVideos(videos, completion: {
                //
            })
            
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

    /// 구독 채널을 눌렀을때 올라오는 테이블뷰를 닫기 위함
    @objc private func hideSubscribeTableView() {
        setupLeftNavigationItem()
        channelCollectionView.deselectCell()
        videoTableView.requestInVideoVC()
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
        let url = URL(string: "https://www.youtube.com/embed/" + item.id.videoId)!
        
        print("⭐️⭐️⭐️⭐️⭐️\(url)⭐️⭐️⭐️⭐️")
        let videoViewController = DetailVideoViewController()
        
        videoViewController.videoURL = url
        videoViewController.item = item
        
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
