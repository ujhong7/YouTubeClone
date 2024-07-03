//
//  NetworkProvider.swift
//  YouTubeClone
//
//  Created by yujaehong on 7/3/24.
//

import Alamofire

final class NetworkProvider<API: BaseAPI> {
    
    func request<T: Decodable>(
        _ api: API,
        completion: @escaping (Result<T, AFError>) -> Void
    ) {
        AF.request(api)
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let model):
                    completion(.success(model))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
}

