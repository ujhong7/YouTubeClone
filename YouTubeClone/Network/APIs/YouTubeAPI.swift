//
//  YouTubeAPI.swift
//  YouTubeClone
//
//  Created by yujaehong on 7/3/24.
//

import Alamofire

enum YouTubeAPI {
    case fetchVideos(regionCode: String)
    case fetchChannel(channelId: String)
    case fetchComments(videoId: String, maxResults: Int)
    case fetchSubscribeVideos(channelId: String)
}

extension YouTubeAPI: BaseAPI {
    
    var urlPath: String {
        switch self {
        case .fetchVideos:
            return "videos"
        case .fetchChannel:
            return "channels"
        case .fetchComments:
            return "commentThreads"
        case .fetchSubscribeVideos:
            return "search"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: RequestParameter {
        switch self {
        case .fetchVideos(let regionCode):
            return .query([
                "part": "snippet,statistics",
                "chart": "mostPopular",
                "regionCode": regionCode,
                "maxResults": "10",
                "key": APIConstants.apiKey
            ])
        case .fetchChannel(let channelId):
            return .query([
                "part": "snippet,statistics",
                "id": channelId,
                "key": APIConstants.apiKey
            ])
        case .fetchComments(let videoId, let maxResults):
            return .query([
                "part": "snippet,replies",
                "videoId": videoId,
                "maxResults": maxResults,
                "key": APIConstants.apiKey
            ])
        case .fetchSubscribeVideos(let channelId):
            return .query([
                "channelId": channelId,
                "part": "snippet",
                "type": "video",
                "maxResults": 10,
                "key": APIConstants.apiKey
            ])
        }
    }
}

