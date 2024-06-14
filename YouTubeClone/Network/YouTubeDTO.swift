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
    /// videoID
    let id: String // 동영상 ID를 위한 필드 추가
    let snippet: Snippet
    let statistics: Statistics
}

// MARK: - Snippet
struct Snippet: Codable {
    
    /// 동영상이 게시된 날짜
    let publishedAt: String // Date -> String
    
    /// 채널 고유 식별 ID
    let channelId : String
    
    /// 동영상 제목
    let title: String
    
    let thumbnails: Thumbnails
    
    /// 동영상이 속한 채널의 채널 제목
    let channelTitle: String
}

// MARK: - Thumbnails
struct Thumbnails: Codable {
    /// 썸네일 이미지의 고해상도 버전
    let medium: ThumbnailDetail
}

// MARK: - ThumbnailDetail
struct ThumbnailDetail: Codable {
    /// 이미지의 URL
    let url: String
}

// MARK: - Statistics
struct Statistics: Codable {
    /// 조회수
    let viewCount: String
    /// 좋아요 수
    let likeCount: String
    /// 댓글 수
    let commentCount: String?
}
