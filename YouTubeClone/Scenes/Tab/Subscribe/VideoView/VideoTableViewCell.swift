//
//  VideoTableViewCell.swift
//  youtubeSubsTab
//
//  Created by yujaehong on 5/7/24.
//

import UIKit
import Alamofire

final class VideoTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .gray
        return label
    }()
    
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray6
        return imageView
    }()
    
    static let imageCache = NSCache<NSString, UIImage>()
    
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
    
    private let kebabButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "kebab"), for: .normal)
        button.tintColor = .systemGray
        return button
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        setupAutoLayout()
        setupTapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Methods
    
    private func configureUI() {
        backgroundColor = .systemBackground
    }
    
    private func setupAutoLayout() {
        [thumbnailImageView, profileImageButton, titleLabel, subtitleLabel, kebabButton].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            thumbnailImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 212),
            
            profileImageButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            profileImageButton.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: 12),
            
            titleLabel.leadingAnchor.constraint(equalTo: profileImageButton.trailingAnchor, constant: 11.83),
            titleLabel.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: 12.02),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -45.17),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: profileImageButton.trailingAnchor, constant: 12),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            
            kebabButton.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 10),
            kebabButton.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: 7),
            kebabButton.widthAnchor.constraint(equalToConstant: 26),
            kebabButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func setupTapGesture() {
        let channelImageButtonTapGesture = UITapGestureRecognizer(target: self, action: #selector(channelImageButtonTapped))
        profileImageButton.addGestureRecognizer(channelImageButtonTapGesture)
        
        let kebabButtonTapGesture = UITapGestureRecognizer(target: self, action: #selector(kebabButtonTapped))
        kebabButton.addGestureRecognizer(kebabButtonTapGesture)
    }
    
    // TODO: - 조회수 정보 가져오는 방법 찾기
    func configure(item: Item, channelItem: ChannelItem?) {
        guard let viewCount = Int(item.statistics?.viewCount ?? "0") else { return }
        let formattedViewCount = viewCount.formattedViewCount()
        let channelName = item.snippet.channelTitle
        guard let publishedDate = item.snippet.publishedAt.toDate() else { return }
        
        titleLabel.text = item.snippet.title
        subtitleLabel.text = "\(channelName) ・ \(formattedViewCount) ・ \(publishedDate.timeAgoSinceDate(numericDates: true))"
        loadThumbnailImage(from: item.snippet.thumbnails.medium.url)
        loadChannelImage(from: channelItem?.snippet.thumbnails.high.url ?? "")
    }

    // MARK: - loadImage
    
    private func loadThumbnailImage(from urlString: String) {
        // 캐시에서 이미지를 먼저 확인 ( object -> NSCache를 이용해서 메모리 캐시에서 이미지 획득)
        if let cachedImage = VideoTableViewCell.imageCache.object(forKey: urlString as NSString) {
            thumbnailImageView.image = cachedImage
            return
        }
        
        // URL 문자열을 URL 인스턴스로 변환
        guard let url = URL(string: urlString) else {
            return
        }
        
        // Alamofire를 사용하여 이미지 데이터 요청
        AF.request(url, method: .get).responseData { [weak self] response in
            guard let self = self else { return }
            
            switch response.result {
            case .success(let data):
                // 받은 데이터로부터 UIImage 인스턴스 생성
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        // 이미지 뷰에 이미지 설정
                        self.thumbnailImageView.image = image
                        // 캐시에 이미지 저장 ( setObject -> NSCache를 이용해서 이미지를 메모리 캐시에 저장)
                        VideoTableViewCell.imageCache.setObject(image, forKey: urlString as NSString)
                    }
                }
            case .failure(let error):
                // 에러 처리 로직
                print("이미지 로딩 에러: \(error.localizedDescription)")
            }
        }
    }
    
    private func loadChannelImage(from urlString: String) {
        // 캐시에서 이미지를 먼저 확인
        if let cachedImage = VideoTableViewCell.imageCache.object(forKey: urlString as NSString) {
            self.profileImageButton.setImage(cachedImage, for: .normal)
            return
        }
        
        // URL 문자열을 URL 인스턴스로 변환
        guard let url = URL(string: urlString) else {
            return
        }
        
        // Alamofire를 사용하여 이미지 데이터 요청
        AF.request(url, method: .get).responseData { [weak self] response in
            guard let self = self else { return }
            
            switch response.result {
            case .success(let data):
                // 받은 데이터로부터 UIImage 인스턴스 생성
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        // 버튼에 이미지 설정
                        self.profileImageButton.setImage(image, for: .normal)
                        // 캐시에 이미지 저장
                        VideoTableViewCell.imageCache.setObject(image, forKey: urlString as NSString)
                    }
                }
            case .failure(let error):
                // 에러 처리 로직
                print("채널 이미지 로딩 에러: \(error.localizedDescription)")
            }
        }
    }
    
    
    // MARK: - @objc
    
    @objc private func contentViewTapped() {
        print(#function)
    }
    
    @objc private func channelImageButtonTapped() {
        print(#function)
    }
    
    @objc private func kebabButtonTapped() {
        print(#function)
    }
}
