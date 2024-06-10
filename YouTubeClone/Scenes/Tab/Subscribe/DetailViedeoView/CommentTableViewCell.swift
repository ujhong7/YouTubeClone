//
//  CommentTableViewCell.swift
//  YouTubeClone
//
//  Created by yujaehong on 6/10/24.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
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
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .black
        return label
    }()
    
    private let likeLabel:UILabel = {
        let label = UILabel()
        label.text = "좋아요"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .black
        return label
    }()
    
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
    
    private func setupAutoLayout() {
        [idLabel, commentLabel, likeLabel, profileImageButton].forEach {
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
            commentLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 40),
            
            likeLabel.topAnchor.constraint(equalTo: commentLabel.bottomAnchor, constant: 12),
            likeLabel.leadingAnchor.constraint(equalTo: profileImageButton.trailingAnchor, constant: 10),
        ])
        
    }

}
