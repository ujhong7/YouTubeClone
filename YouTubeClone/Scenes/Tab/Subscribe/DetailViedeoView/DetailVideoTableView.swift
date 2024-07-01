//
//  DetailVideoTableView.swift
//  YouTubeClone
//
//  Created by yujaehong on 6/15/24.
//

import UIKit

final class DetailVideoTableView: UITableView {
    
    // MARK: - Properties
    
    weak var parentViewController: UIViewController?
    
    private var items: [Item] = []
    
    private var channelItems: [String: ChannelItem] = [:]
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero, style: .plain)
        configureTableView()
        requestYouTubeAPI()
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
                    self?.reloadData() // 새로운 데이터로 테이블 뷰 갱신
                }
            case .failure(let error):
                print("에러: \(error)")
            }
        }
    }
    
    private func presentVideoViewController(with item: Item) {
        print(#function)
        let url = URL(string: "https://www.youtube.com/embed/" + item.id.videoId)!
        
        print("⭐️⭐️⭐️⭐️⭐️\(url)⭐️⭐️⭐️⭐️")
        
        
        // TODO: - 이곳도 동일한 구조로 변경이 필요함
        let videoViewController = DetailVideoViewController()

        videoViewController.videoURL = url
        videoViewController.item = item  // Item 객체를 전달
        //videoViewController.detailVideoView.tableView.parentViewController = parentViewController
        //videoViewController.detailVideoView.tableView.parentViewController = parentViewController

        
        // 채널이미지, 채널구독자 수
        if let channelItem = channelItems[item.snippet.channelId] {
            videoViewController.channelItem = channelItem  // ChannelItem 객체를 전달
        }
        
        videoViewController.modalPresentationStyle = .overFullScreen
        //        videoViewController.modalTransitionStyle = .crossDissolve
        
        
        if let parentVC = parentViewController as? DetailVideoViewController {
            let presentedViewController = parentVC.presentedViewController // 지금 ViewController가 띄우는 ViewController -> 여기선 VideoViewController
            let presentingViewControleller = parentVC.presentingViewController // 지금 ViewController를 띄우는 ViewController -> 여기선 ViewController
            
            // animated: false 중요!!!
            parentVC.dismiss(animated: false) {
                print(#function)
                presentingViewControleller?.present(videoViewController, animated: false)
            }
        }
        
    }
    
}

// MARK: - UITableViewDataSource

extension DetailVideoTableView: UITableViewDataSource {
    
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

extension DetailVideoTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 306
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
        let item = items[indexPath.row]
        presentVideoViewController(with: item)
    }
    
}
