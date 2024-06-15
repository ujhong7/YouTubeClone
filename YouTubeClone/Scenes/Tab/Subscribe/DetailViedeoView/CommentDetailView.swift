//
//  CommentDetailView.swift
//  YouTubeClone
//
//  Created by yujaehong on 6/8/24.
//

import UIKit

final class CommentDetailView: UIView {
    
    // MARK: - Properties
    
    private var comments: [CommentThread] = []
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "댓글"
        label.font = UIFont.systemFont(ofSize: 27, weight: .bold)
        return label
    }()
    
    private var closeButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "xmark")
        button.setImage(image, for: .normal)
        button.tintColor = .black  // 버튼 이미지 색상을 변경할 수 있습니다.
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var commentTableView: UITableView = {
        let tableView =  UITableView(frame: .zero)
        return tableView
    }()
    
    private var handleView: UIView = {
        let view =  UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 3
        return view
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
           let indicator = UIActivityIndicatorView(style: .large)
           indicator.hidesWhenStopped = true
           return indicator
       }()
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("CommentDetailView initialized")
        setupView()
        setupTableView()
        setupAutoLayout()
        setupPanGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .white
        layer.cornerRadius = 15 // 원하는 반경으로 설정하세요.
        layer.masksToBounds = true
    }
    
    private func setupTableView() {
        commentTableView.dataSource = self
        commentTableView.delegate = self
        commentTableView.register(CommentTableViewCell.self, forCellReuseIdentifier: "CommentCell")
    }
    
    private func setupAutoLayout() {
        addSubview(handleView)
        addSubview(label)
        addSubview(closeButton)
        addSubview(commentTableView)
        
        handleView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        commentTableView.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            handleView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            handleView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            handleView.widthAnchor.constraint(equalToConstant: 40),
            handleView.heightAnchor.constraint(equalToConstant: 4),
            
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            
            closeButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            closeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            
            commentTableView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
            commentTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            commentTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            commentTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
    }
    
    private func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        self.addGestureRecognizer(panGesture)
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        
        if gesture.state == .changed {
            self.transform = CGAffineTransform(translationX: 0, y: max(0, translation.y))
        } else if gesture.state == .ended {
            let velocity = gesture.velocity(in: self)
            if translation.y > 100 || velocity.y > 500 {
                UIView.animate(withDuration: 0.3, animations: {
                    self.transform = CGAffineTransform(translationX: 0, y: self.frame.height)
                }) { _ in
                    self.removeFromSuperview()
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.transform = .identity
                }
            }
        }
    }
    
    @objc private func closeButtonTapped() {
        UIView.animate(withDuration: 0.3, animations: {
            self.transform = CGAffineTransform(translationX: 0, y: self.frame.height)
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
}

// MARK: - Networking

extension CommentDetailView {
    
    func requestCommentsAPI(videoID: String) {
        print(#function)
        
        print("Fetching comments for videoID: \(videoID)")
        activityIndicator.startAnimating()
        APIManager.shared.requestCommentsAPIData(videoId: videoID, maxResults: 10) { [weak self] result in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                switch result {
                case .success(let comments):
                    self?.comments = comments
                    self?.commentTableView.reloadData()
                case .failure(let error):
                    print("Failed to fetch comments: \(error)")
                }
            }
        }
    }
    
}

// MARK: - UITableViewDataSource

extension CommentDetailView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as? CommentTableViewCell else {
            return UITableViewCell()
        }
        
        let comment = comments[indexPath.row]
        cell.configure(comments: comment)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CommentDetailView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}


//// MARK: - UIScrollViewDelegate
//
//extension CommentDetailView: UIScrollViewDelegate {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.contentOffset.y < 0 {
//            scrollView.contentOffset.y = 0
//        }
//    }
//}
