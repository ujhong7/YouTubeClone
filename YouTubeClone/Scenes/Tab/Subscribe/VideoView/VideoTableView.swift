//
//  VideoTableView.swift
//  YouTubeClone
//
//  Created by yujaehong on 6/3/24.
//

import UIKit

/// 영상에 대한 전반적인 정보를 담고 있는 테이블뷰
final class VideoTableView: UITableView {
    
    // MARK: - Properties
    
    weak var parentViewController: UIViewController?
    
    /// 유튜브 API 데이터
    private var items: [Item] = []
    
    ///
    private var channelItems: [String: ChannelItem] = [:]
    
    /// present 애니메이션 설정해주기 위한 프로퍼티
    var isPresentAnimation: Bool = true
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero, style: .plain)
        configureTableView()
        //requestYouTubeAPI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func configureTableView() {
        backgroundColor = .systemBackground
        register(VideoTableViewCell.self, forCellReuseIdentifier: "VideoCell")
        dataSource = self
        delegate = self
    }
    

    func updateVideos(_ videos: [Item], completion: @escaping () -> Void) {
        self.items = videos
        
        // channelId를 추출하고 requestChannelProfileImageAPI 호출
        self.items.forEach { item in
            // 'Item' 모델에 'channelId'가 있다고 가정
            self.requestChannelProfileImageAPI(with: item.snippet.channelId)
        }
        
        reloadData()
        completion()
    }
    
    // ☀️ private 프로퍼티를 다른곳에서 사용하는 방법...메서드를 만들자
    //    func getVideoItems() -> [Item] {
    //        return items
    //    }
    
    func presentVideoViewController(with item: Item) {
        
        let url = URL(string: "https://www.youtube.com/embed/" + item.id.videoId)!
        
        print("⭐️⭐️⭐️⭐️⭐️\(url)⭐️⭐️⭐️⭐️")
        
        let videoViewController = DetailVideoViewController()

        videoViewController.videoURL = url
        videoViewController.item = item  // Item 객체를 전달
        videoViewController.tableView.parentViewController = parentViewController
        
        // 채널이미지, 채널구독자 수
        if let channelItem = channelItems[item.snippet.channelId] {
            videoViewController.channelItem = channelItem  // ChannelItem 객체를 전달
        }
        
        videoViewController.modalPresentationStyle = .overFullScreen
        videoViewController.modalTransitionStyle = .coverVertical
        
        // ⭐️
        if let parentVC = parentViewController as? SubscribeViewController {
            parentVC.dismiss(animated: false) {
                parentVC.present(videoViewController, animated: self.isPresentAnimation)
            }
        }
    }
    
    func requestInSubscribeVC() {
        requestYouTubeAPI()
    }
    
    func requestInVideoVC() {
        requestYouTubeAPI()
    }
    
}

// MARK: - Networking

extension VideoTableView {
    
    private func requestYouTubeAPI() {
        print(#function)
        APIManager.shared.requestYouTubeAPIData { [weak self] result in
            switch result {
            case .success(let data):
                dump(data)
                DispatchQueue.main.async {
                    self?.items = data
                    
                    self?.reloadData()
                    //self?.refreshControl.endRefreshing() // refresh종료를 위해..
                }
                
                // channelId를 추출하고 requestChannelProfileImageAPI 호출
                data.forEach { item in
                    // 'Item' 모델에 'channelId'가 있다고 가정
                    self?.requestChannelProfileImageAPI(with: item.snippet.channelId)
                }
                
            case .failure(let error):
                print("데이터를 받아오는데 실패했습니다: \(error)")
                //self?.refreshControl.endRefreshing()
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
                    self?.reloadData() // 새로운 데이터로 테이블 뷰 갱신
                }
            case .failure(let error):
                print("에러: \(error)")
            }
        }
    }
    
}

// MARK: - UITableViewDataSource

extension VideoTableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as? VideoTableViewCell else {
            let cell = UITableViewCell()
            return cell
        }
        
        let item = items[indexPath.row]
        
        if let channelItem = channelItems[item.snippet.channelId] {
            cell.configure(item: item, channelItem: channelItem)
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension VideoTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 306
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        presentVideoViewController(with: item)
    }
}
