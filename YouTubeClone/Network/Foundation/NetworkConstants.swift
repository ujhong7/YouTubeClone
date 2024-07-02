//
//  NetworkConstants.swift
//  YouTubeClone
//
//  Created by yujaehong on 7/3/24.
//

import Foundation

enum HeaderType {
    case basic
}

enum HTTPHeaderField: String {
    case contentType = "Content-Type"
    case authorization = "Authorization"
}

enum ContentType: String {
    case json = "application/json"
}

enum RequestParameter {
    case query(_ query: [String: Any])
    case requestBody(_ body: Encodable)
    case requestPlain
}

