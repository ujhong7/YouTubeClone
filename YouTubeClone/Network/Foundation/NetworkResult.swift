//
//  NetworkResult.swift
//  YouTubeClone
//
//  Created by yujaehong on 7/3/24.
//

import Foundation

enum NetworkResult<T> {
    case success(T)
    case requestErr
    case serverErr
    case networkFail
    case parsingErr
}
