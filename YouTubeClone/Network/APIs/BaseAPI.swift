//
//  BaseAPI.swift
//  YouTubeClone
//
//  Created by yujaehong on 7/3/24.
//

import Alamofire

protocol BaseAPI: TargetType {
    var urlPath: String { get }
}

extension BaseAPI {
    
    var baseURL: String {
        return APIConstants.baseURL
    }
    
    var headers: HTTPHeaders? {
        return ["Content-Type": "application/json"]
    }
    
    var path: String {
        return urlPath
    }

}

