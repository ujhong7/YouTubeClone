//
//  ChannelCollectionViewCell.swift
//  youtubeSubsTab
//
//  Created by yujaehong on 5/7/24.
//

import UIKit

final class ChannelCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private let channelImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray6
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.widthAnchor.constraint(equalToConstant: 58).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 58).isActive = true
        imageView.layer.cornerRadius = 58 / 2
        return imageView
    }()
    
    private let channelNameTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Your Text"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setupAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func configureUI() {
        backgroundColor = .systemBackground
    }
    
    private func setupAutoLayout() {
        [channelImageView, channelNameTextLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            channelImageView.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            channelImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 7),
            channelImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -7),
            channelImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
            
            channelNameTextLabel.topAnchor.constraint(equalTo: channelImageView.bottomAnchor, constant: 5),
            channelNameTextLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 7),
            channelNameTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -7)
        ])
    }
    
    func configure(_ channel: Channel) {
        channelNameTextLabel.text = channel.name
        channelImageView.loadImage(from: channel.thumbnail)
    }
    
    func resetBackgroundColor() {
        backgroundColor = .systemBackground
    }
    
    func changeSelectedBackgroundColor() {
        self.backgroundColor = .systemGray6
    }
}
