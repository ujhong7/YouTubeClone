//
//  ChannelDTO.swift
//  YouTubeClone
//
//  Created by yujaehong on 6/1/24.
//

import Foundation

struct ChannelModel: Codable {
    let items: [ChannelItem]
}

struct ChannelItem: Codable {
    let snippet: ChannelSnippet
    let statistics: ChannelStatistics
}

struct ChannelSnippet: Codable {
    let thumbnails: ChannelThumbnails
}

struct ChannelThumbnails: Codable {
    let high: ChannelThumbnail
}

struct ChannelThumbnail: Codable {
    let url: String
}

struct ChannelStatistics: Codable {
    let subscriberCount: String
}

