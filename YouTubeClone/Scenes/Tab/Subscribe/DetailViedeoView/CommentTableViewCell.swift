//
//  CommentTableViewCell.swift
//  YouTubeClone
//
//  Created by yujaehong on 6/10/24.
//

import UIKit

final class CommentTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    private let profileImageButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .systemGray5
        button.contentMode = .scaleAspectFill
        button.widthAnchor.constraint(equalToConstant: 36).isActive = true
        button.heightAnchor.constraint(equalToConstant: 36).isActive = true
        button.layer.cornerRadius = 36 / 2
        button.layer.masksToBounds = true
        return button
    }()
    
    private let idLabel:UILabel = {
        let label = UILabel()
        label.text = "아이디"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .black
        return label
    }()
    
    private let commentLabel:UILabel = {
        let label = UILabel()
        label.text = "댓글입니다."
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .black
        return label
    }()
    
    private let likeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "hand.thumbsup.fill") // SF Symbol 사용
        imageView.tintColor = .black
        imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return imageView
    }()
    
    private let likeCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0" // 초기 좋아요 수
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .black
        return label
    }()
    
    private lazy var likeStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [likeImageView, likeCountLabel])
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .center
        return stackView
    }()
    
    // MARK: - LifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        setupAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func configureUI() {
        backgroundColor = .white
    }
    
    func configure(comments: CommentThread) {
        // 최상위 댓글의 snippet에서 필요한 정보 추출
        let topLevelComment = comments.snippet.topLevelComment
        let snippet = topLevelComment.snippet
        
        idLabel.text = snippet.authorDisplayName  // 작성자 이름
        commentLabel.text = snippet.textOriginal  // 원본 댓글 텍스트
        
        let likeCount = snippet.likeCount
        likeCountLabel.text = "\(likeCount)"  // 좋아요 수
        
        // 프로필 이미지 URL 설정 (예시 URL 사용)
        if let profileImageURL = URL(string: snippet.authorProfileImageUrl) {
            // 비동기로 이미지를 다운로드하고 설정합니다.
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: profileImageURL), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.profileImageButton.setImage(image, for: .normal)
                    }
                }
            }
        } else {
            // 기본 이미지 설정 (API에서 프로필 이미지 URL을 받지 못했을 때)
            self.profileImageButton.setImage(UIImage(named: "profile_placeholder"), for: .normal)
        }
    }
    
    private func setupAutoLayout() {
        [idLabel, commentLabel, likeStackView, profileImageButton].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            profileImageButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            profileImageButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            
            idLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            idLabel.leadingAnchor.constraint(equalTo: profileImageButton.trailingAnchor, constant: 10),
            idLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 40),
            
            commentLabel.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: 7),
            commentLabel.leadingAnchor.constraint(equalTo: profileImageButton.trailingAnchor, constant: 10),
            commentLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            
            likeStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
            likeStackView.leadingAnchor.constraint(equalTo: profileImageButton.trailingAnchor, constant: 10)
        ])
    }
    
}
