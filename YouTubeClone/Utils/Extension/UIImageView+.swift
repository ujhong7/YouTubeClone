//
//  UIImageView+.swift
//  YouTubeClone
//
//  Created by Kant on 6/10/24.
//

import UIKit

extension UIImageView {
    // URL에서 이미지를 비동기적으로 로드하여 설정하는 함수
    func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        // URLSession을 사용하여 데이터 다운로드
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error downloading image: \(error)")
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("No data or failed to create image")
                return
            }

            // UI 업데이트는 메인 스레드에서 수행
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}
