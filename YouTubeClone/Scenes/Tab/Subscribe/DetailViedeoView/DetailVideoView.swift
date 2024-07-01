//
//  DetailVideoView.swift
//  YouTubeClone
//
//  Created by yujaehong on 6/30/24.
//

import UIKit
import WebKit

class DetailVideoView: UIView {
    
    // MARK: - Properties
    
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    private(set) lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    private(set) var profileImageButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .systemGray6
        button.contentMode = .scaleAspectFill
        button.widthAnchor.constraint(equalToConstant: 36).isActive = true
        button.heightAnchor.constraint(equalToConstant: 36).isActive = true
        button.layer.cornerRadius = 36 / 2
        button.layer.masksToBounds = true
        return button
    }()
    
    private(set) lazy var channelTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    private(set) lazy var subscriberCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private(set) var tabViewCollectionView: TabButtonCollectionView = {
        let view = TabButtonCollectionView(postion: .detailViewController)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private(set) var commentView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 10
        return view
    }()
    
    private(set) var commentDetailView: CommentDetailView? = nil
    
    private(set) var commentTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "댓글"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    private(set) lazy var commentCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private(set) lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.text = "댓글입니다."
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private(set) var tableView: VideoTableView = {
        let tableView = VideoTableView()
        tableView.isPresentAnimation = false
        return tableView
    }()
    
    private(set) var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.allowsInlineMediaPlayback = true
        let wkWebView = WKWebView(frame: .zero, configuration: webConfiguration)
        return wkWebView
    }()
    
    private(set) var panGestureRecognizer: UIPanGestureRecognizer!
    
    let scrollView = UIScrollView()
    
    let contentView = UIView()
    
    var tableViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupView() {
        backgroundColor = .white
        setupCollectionView()
        setupTapGesture()
        setupPanGesture()
    }
    
    private func setupCollectionView() {
        tabViewCollectionView.register(TabButtonCollectionViewCell.self, forCellWithReuseIdentifier: "TabButtonCell")
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCommentViewTap))
        commentView.addGestureRecognizer(tapGesture)
    }
    
    private func setupPanGesture() {
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        webView.addGestureRecognizer(panGestureRecognizer)
        panGestureRecognizer.delegate = self
    }
    
    // 🚨
    @objc private func handleCommentViewTap() {
        // Comment view tap handling logic
        
    }
    
    // 🚨
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        // Pan gesture handling logic
        
    }
    
    // MARK: - Auto Layout
    
    private func setupAutoLayout() {
        [scrollView, contentView, webView, titleLabel, subtitleLabel, profileImageButton, channelTitleLabel, subscriberCountLabel, tabViewCollectionView, commentView, commentTitleLabel, commentCountLabel, commentLabel, tableView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        addSubview(webView)
        addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        [titleLabel, subtitleLabel, profileImageButton, channelTitleLabel, subscriberCountLabel, tabViewCollectionView, commentView, tableView].forEach { contentView.addSubview($0) }
        
        [commentTitleLabel, commentCountLabel, commentLabel].forEach { commentView.addSubview($0) }
        
        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 400)
        tableViewHeightConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 212),
            
            scrollView.topAnchor.constraint(equalTo: webView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
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
            tableViewHeightConstraint
        ])
        
        tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    // ⭐️
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize", let tableView = object as? UITableView {
            tableViewHeightConstraint.constant = tableView.contentSize.height
        }
    }
}

// MARK: - UIGestureRecognizerDelegate

extension DetailVideoView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
