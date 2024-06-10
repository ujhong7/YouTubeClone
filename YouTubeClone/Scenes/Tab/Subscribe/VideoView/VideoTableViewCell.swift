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
    
    // 🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨
//    func configure(item: Item) {
//        titleLabel.text = item.snippet.title
//        
//        let viewCount = Int(item.statistics.viewCount)!
//        let formattedViewCount = formatViewCount(viewCount)
//        let channelName = item.snippet.channelTitle
//        
//        if let publishedDate = parseDate(dateString: item.snippet.publishedAt) {
//            subtitleLabel.text = "\(channelName) ・ \(formattedViewCount) ・ \(timeAgoSinceDate(publishedDate, currentDate: Date(), numericDates: true))"
//        }
//        
//        loadThumbnailImage(from: item.snippet.thumbnails.medium.url)
//    }
    
    func configure(item: Item, channelItem: ChannelItem) {
        titleLabel.text = item.snippet.title
        
        let viewCount = Int(item.statistics.viewCount)!
        let formattedViewCount = formatViewCount(viewCount)
        let channelName = item.snippet.channelTitle
        
        if let publishedDate = parseDate(dateString: item.snippet.publishedAt) {
            subtitleLabel.text = "\(channelName) ・ \(formattedViewCount) ・ \(timeAgoSinceDate(publishedDate, currentDate: Date(), numericDates: true))"
        }
        
        loadThumbnailImage(from: item.snippet.thumbnails.medium.url)
        loadChannelImage(from: channelItem.snippet.thumbnails.high.url)
    }
    
    
    func formatViewCount(_ count: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        // 백만회 이상일 때 소수점 없이 표시
        if count >= 1000000 {
            let formattedNumber = Double(count) / 10000 // 만 단위로 나누기
            numberFormatter.minimumFractionDigits = 0 // 소수점 없음
            numberFormatter.maximumFractionDigits = 0 // 소수점 없음
            return "\(numberFormatter.string(from: NSNumber(value: formattedNumber))!)만회"
        }
        // 십만회 이상 백만회 미만일 때 소수점 첫째 자리까지 표시
        else if count >= 100000 {
            let formattedNumber = Double(count) / 10000 // 만 단위로 나누기
            numberFormatter.minimumFractionDigits = 0 // 소수점 첫째 자리
            numberFormatter.maximumFractionDigits = 0 // 소수점 첫째 자리
            return "\(numberFormatter.string(from: NSNumber(value: formattedNumber))!)만회"
        }
        // 천회 이상 십만회 미만일 때 소수점 첫째 자리까지 표시
        else if count >= 1000 {
            let formattedNumber = Double(count) / 1000 // 천 단위로 나누기
            numberFormatter.minimumFractionDigits = 1 // 소수점 첫째 자리
            numberFormatter.maximumFractionDigits = 1 // 소수점 첫째 자리
            return "\(numberFormatter.string(from: NSNumber(value: formattedNumber))!)천회"
        }
        // 백회 이상 천회 미만일 때는 정수로 표시
        else if count >= 100 {
            let formattedNumber = Double(count) / 100 // 백 단위로 나누기
            numberFormatter.minimumFractionDigits = 0 // 소수점 없음
            numberFormatter.maximumFractionDigits = 0 // 소수점 없음
            return "\(numberFormatter.string(from: NSNumber(value: formattedNumber))!)백회"
        }
        // 백회 미만일 때는 정수로 표시
        else {
            return "\(numberFormatter.string(from: NSNumber(value: count))!)회"
        }
    }
    
    // 날짜 문자열 파싱
    func parseDate(dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" // 서버에서 받는 날짜 형식
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // 날짜 형식의 로캘 설정
        return dateFormatter.date(from: dateString)
    }
    
    // '몇 시간 전' 형식으로 변환
    func timeAgoSinceDate(_ date: Date, currentDate: Date, numericDates: Bool) -> String {
        let calendar = Calendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let components = calendar.dateComponents(unitFlags, from: date, to: currentDate)
        
        if let year = components.year, year >= 2 {
            return "\(year)년 전"
        } else if let year = components.year, year >= 1 {
            if numericDates {
                return "1년 전"
            } else {
                return "작년"
            }
        } else if let month = components.month, month >= 2 {
            return "\(month)개월 전"
        } else if let month = components.month, month >= 1 {
            if numericDates {
                return "1개월 전"
            } else {
                return "지난 달"
            }
        } else if let week = components.weekOfYear, week >= 2 {
            return "\(week)주 전"
        } else if let week = components.weekOfYear, week >= 1 {
            if numericDates {
                return "1주 전"
            } else {
                return "지난 주"
            }
        } else if let day = components.day, day >= 2 {
            return "\(day)일 전"
        } else if let day = components.day, day >= 1 {
            if numericDates {
                return "1일 전"
            } else {
                return "어제"
            }
        } else if let hour = components.hour, hour >= 2 {
            return "\(hour)시간 전"
        } else if let hour = components.hour, hour >= 1 {
            if numericDates {
                return "1시간 전"
            } else {
                return "한 시간 전"
            }
        } else if let minute = components.minute, minute >= 2 {
            return "\(minute)분 전"
        } else if let minute = components.minute, minute >= 1 {
            if numericDates {
                return "1분 전"
            } else {
                return "한 분 전"
            }
        } else if let second = components.second, second >= 3 {
            return "\(second)초 전"
        } else {
            return "방금 전"
        }
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

