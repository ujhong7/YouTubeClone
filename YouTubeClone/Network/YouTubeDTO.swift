//
//  YouTubeDTO.swift
//  YouTubeClone
//
//  Created by yujaehong on 5/31/24.
//

import Foundation

// UUID 란?

struct YouTubeDTO: Codable {
    let items: [Item]
}

// MARK: - Item
struct Item: Codable {
    let id: ID
    let snippet: Snippet
    let statistics: Statistics?
}

// MARK: - ID
enum ID: Codable {
    case stringID(String)
    case objectID(VideoID)
    
    struct VideoID: Codable {
        let kind: String
        let videoId: String
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let stringID = try? container.decode(String.self) {
            self = .stringID(stringID)
        } else if let objectID = try? container.decode(VideoID.self) {
            self = .objectID(objectID)
        } else {
            throw DecodingError.typeMismatch(ID.self,
                                             DecodingError.Context(codingPath: decoder.codingPath,
                                                                   debugDescription: "Expected to decode ID but found neither a string nor an object."))
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .stringID(let stringID):
            try container.encode(stringID)
        case .objectID(let objectID):
            try container.encode(objectID)
        }
    }
    
    var videoId: String {
        switch self {
        case .stringID(let stringID):
            return stringID
        case .objectID(let objectID):
            return objectID.videoId
        }
    }
}

// MARK: - Snippet
struct Snippet: Codable {
    let publishedAt: String
    let channelId: String
    let title: String
    let thumbnails: Thumbnails
    let channelTitle: String
}

// MARK: - Thumbnails
struct Thumbnails: Codable {
    let medium: ThumbnailDetail
}

// MARK: - ThumbnailDetail
struct ThumbnailDetail: Codable {
    let url: String
}

struct Statistics: Codable {
    let viewCount: String
    let likeCount: String
    let favoriteCount: String
    let commentCount: String?
}
