//
//  ChannelDTO.swift
//  YouTubeClone
//
//  Created by yujaehong on 6/1/24.
//

import Foundation

struct ChannelDTO: Codable {
    let items: [ChannelItem]
}

struct ChannelItem: Codable {
    let snippet: ChannelSnippet
}

struct ChannelSnippet: Codable {
    let thumbnails: ChannelThumbnails
}

struct ChannelThumbnails: Codable {
    let high: ChannelThumbnail
}

struct ChannelThumbnail: Codable {
    /// 채널 이미지 url
    let url: String
}

struct ChannelStatistics: Codable {
    /// 구독자 수
    let subscriberCount: String
}
