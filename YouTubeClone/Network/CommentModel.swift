//
//  CommentModel.swift
//  YouTubeClone
//
//  Created by yujaehong on 6/12/24.
//

import Foundation

struct CommentThreadResponse: Codable {
    let items: [CommentThread]
}

struct CommentThread: Codable {
    let snippet: CommentThreadSnippet
}

struct CommentThreadSnippet: Codable {
    ///  최상위 댓글 정보
    let topLevelComment: TopLevelComment
    /// 댓글에 대한 답글
    let replies: Replies?
}

/// 최상위 댓글
struct TopLevelComment: Codable {
    let snippet: CommentSnippet
}

/// 댓글에 대한 답글들의 리스트
struct Replies: Codable {
    /// Comment 객체들의 리스트
    let comments: [Comment]
}

/// 개별 댓글
struct Comment: Codable {
    let snippet: CommentSnippet
}

struct CommentSnippet: Codable {
    /// 댓글의 텍스트 내용
    let textOriginal: String
    /// 댓글을 작성한 사용자의 표시 이름
    let authorDisplayName: String
    /// 댓글이 받은 좋아요 수
    let likeCount: Int
    /// 댓글을 작성한 사용자의 프로필 이미지 URL
    let authorProfileImageUrl: String
}
