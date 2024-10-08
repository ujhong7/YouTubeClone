//
//  APIManager.swift
//  YouTubeClone
//
//  Created by yujaehong on 5/31/24.
//

import UIKit
import Alamofire

enum API {
    static let baseUrl: String = "https://youtube.googleapis.com/youtube/v3/"
    static let key: String = "AIzaSyCvV1WGDwCtMk_SDzvh7Vou9tlLg4DwcqE"
    
    // 준
    // AIzaSyCvV1WGDwCtMk_SDzvh7Vou9tlLg4DwcqE
    
    // 홍
    // AIzaSyBkEL7Su2Bx9Lyu7efXjZWc_EjJGFXeCZU
}

class APIManager {
    static let shared = APIManager()
    
    private init() {}
    
    // MARK: - 동영상 불러오기
    func requestYouTubeAPIData(completion: @escaping (Result<[Item], AFError>) -> Void) {
        let videoURL = API.baseUrl + "videos"
        let parameters: [String: Any] = [
            "part": "snippet, statistics",
            "chart": "mostPopular",
            // 탭에 KR JP US 등등 넣어서 값바꿔보기...
            "regionCode": "KR",
            "maxResults" : "10",
            "key": API.key
        ]
        
        AF.request(videoURL, parameters: parameters)
            .validate()
            .responseDecodable(of: YouTubeDTO.self) { response in
                switch response.result {
                case .success(let youTubeDTO):
                    completion(.success(youTubeDTO.items))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    // MARK: - 채널 프로필 이미지 가져오기
      func requestChannelProfileImage(channelId: String, completion: @escaping (Result<[ChannelItem], AFError>) -> Void) {
          let channelURL = API.baseUrl + "channels"
          let parameters: [String: Any] = [
              "part": "snippet",
              "id": channelId,
              "key": API.key
          ]
          
          AF.request(channelURL, parameters: parameters)
              .validate()
              .responseDecodable(of: ChannelDTO.self) { response in
                  switch response.result {
                  case .success(let channelDTO):
                         completion(.success(channelDTO.items))
                  case .failure(let error):
                      completion(.failure(error))
                  }
              }
      }

}

// ⭐️ 유튜브 동영상 URL 여기다 넣으면됨
// https://www.youtube.com/embed/[VIDEO_ID]
// 비디오 아이디까지 받아와서

// https://www.youtube.com/embed/GV_HP7yoIyc
// https://www.youtube.com/embed/Q3K0TOvTOno

