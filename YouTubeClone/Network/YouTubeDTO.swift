//
//  YouTubeDTO.swift
//  YouTubeClone
//
//  Created by yujaehong on 5/31/24.
//

import Foundation

// UUID 란?

// MARK: - VideoDTO
struct YouTubeDTO: Codable {
    let items: [Item]
}

// MARK: - Item
struct Item: Codable {
    let id: String // 동영상 ID를 위한 필드 추가
    let snippet: Snippet
    let statistics: Statistics
}

// MARK: - Snippet
struct Snippet: Codable {
    let publishedAt: String // Date -> String
    let channelId : String // 채널아이디 (채널 프로필이미지 구하기 위함)
    let title: String
    let thumbnails: Thumbnails
    let channelTitle: String // 채널제목
}

// MARK: - Thumbnails
struct Thumbnails: Codable {
    let medium: ThumbnailDetail
}

// MARK: - ThumbnailDetail
struct ThumbnailDetail: Codable {
    let url: String
}

// MARK: - Statistics
struct Statistics: Codable {
    let viewCount, likeCount, favoriteCount, commentCount: String
}
