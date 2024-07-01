//
//  CommentDetailViewModel.swift
//  YouTubeClone
//
//  Created by yujaehong on 7/1/24.
//

import Foundation

class CommentDetailViewModel {
    
    private var comments: [CommentThread] = []
    
    // 클로저를 이용하여 댓글 업데이트를 관찰할 수 있도록 설정
    var didUpdateComments: (() -> Void)?
    
    // 댓글 데이터를 가져오는 함수
    func fetchComments(for videoID: String) {
        APIManager.shared.requestCommentsAPIData(videoId: videoID, maxResults: 10) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let comments):
                    self?.comments = comments
                    self?.didUpdateComments?()
                case .failure(let error):
                    print("Failed to fetch comments: \(error)")
                }
            }
        }
    }
    
    // TableView에 필요한 댓글 수
    func numberOfComments() -> Int {
        return comments.count
    }
    
    // 각 셀에 필요한 댓글 데이터
    func comment(at index: Int) -> CommentThread? {
        guard index < comments.count else { return nil }
        return comments[index]
    }
}

