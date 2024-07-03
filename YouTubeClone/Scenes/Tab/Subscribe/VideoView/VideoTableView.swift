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
    
    var viewModel = VideoTableViewModel()
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero, style: .plain)
        configureTableView()
        bindViewModel()
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
    
    private func bindViewModel() {
        viewModel.updateTableViewClosure = { [weak self] in
            self?.reloadData()
        }
    }
    
    func updateVideos(_ videos: [Item], completion: @escaping () -> Void) {
        viewModel.updateVideos(videos, completion: completion)
    }
    
    func presentVideoViewController(with item: Item) {
        
        let url = URL(string: "https://www.youtube.com/embed/" + item.id.videoId)!
        
        print("⭐️⭐️⭐️⭐️⭐️\(url)⭐️⭐️⭐️⭐️")
        
        let videoViewController = DetailVideoViewController(viewController: parentViewController,
                                                            item: item,
                                                            videoURL: url)
        
        if let channelItem = viewModel.channelItems[item.snippet.channelId] {
            videoViewController.channelItem = channelItem
        }
        
        videoViewController.modalPresentationStyle = .overFullScreen
        videoViewController.modalTransitionStyle = .coverVertical
        
        if let parentVC = parentViewController as? SubscribeViewController {
            parentVC.dismiss(animated: false) {
                parentVC.present(videoViewController, animated: self.viewModel.isPresentAnimation)
            }
        }
    }
    
    func requestInSubscribeVC() {
        viewModel.fetchVideos()
    }
    
    func requestInVideoVC() {
        viewModel.fetchVideos()
    }
    
}

// MARK: - UITableViewDataSource

extension VideoTableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as? VideoTableViewCell else {
            let cell = UITableViewCell()
            return cell
        }
        
        let item = viewModel.items[indexPath.row]
        
        if let channelItem = viewModel.channelItems[item.snippet.channelId] {
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
        let item = viewModel.items[indexPath.row]
        presentVideoViewController(with: item)
    }
}
