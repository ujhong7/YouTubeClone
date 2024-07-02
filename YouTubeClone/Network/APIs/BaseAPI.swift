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
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        var urlRequest = try URLRequest(url: url.appendingPathComponent(path), method: method)
        
        if let headers = headers {
            urlRequest.headers = headers
        }
        
        switch parameters {
        case .query(let query):
            var components = URLComponents(string: url.appendingPathComponent(path).absoluteString)
            components?.queryItems = query.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            urlRequest.url = components?.url
            
        case .requestBody(let body):
            urlRequest.httpBody = try JSONEncoder().encode(body)
            
        case .requestPlain:
            break
        }
        
        return urlRequest
    }
}

