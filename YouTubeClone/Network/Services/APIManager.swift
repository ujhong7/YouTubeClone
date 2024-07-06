//
//  APIManager.swift
//  YouTubeClone
//
//  Created by yujaehong on 7/3/24.
//

import UIKit
import Alamofire

class APIManager {
    static let shared = APIManager()
    
    private init() {}
    
    private let networkProvider = NetworkProvider<YouTubeAPI>()
    
    // MARK: - 동영상 불러오기
    func requestYouTubeAPIData(completion: @escaping (Result<[Item], AFError>) -> Void) {
        networkProvider.request(.fetchVideos(regionCode: "KR")) { (result: Result<YouTubeModel, AFError>) in
            switch result {
            case .success(let youTubeDTO):
                completion(.success(youTubeDTO.items))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - 채널 프로필 이미지 가져오기
    func requestChannelAPIData(channelId: String, completion: @escaping (Result<[ChannelItem], AFError>) -> Void) {
        networkProvider.request(.fetchChannel(channelId: channelId)) { (result: Result<ChannelModel, AFError>) in
            switch result {
            case .success(let channelDTO):
                completion(.success(channelDTO.items))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - 댓글 가져오기
    func requestCommentsAPIData(videoId: String, maxResults: Int, completion: @escaping (Result<[CommentThread], AFError>) -> Void) {
        networkProvider.request(.fetchComments(videoId: videoId, maxResults: maxResults)) { (result: Result<CommentThreadResponse, AFError>) in
            switch result {
            case .success(let commentThreadResponse):
                completion(.success(commentThreadResponse.items))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - 구독채널 클릭 후 데이터 가져오기
    func requestSubscribeVideoData(channelId: String, completion: @escaping (Result<[Item], AFError>) -> Void) {
        networkProvider.request(.fetchSubscribeVideos(channelId: channelId)) { (result: Result<YouTubeModel, AFError>) in
            switch result {
            case .success(let youTubeDTO):
                completion(.success(youTubeDTO.items))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

