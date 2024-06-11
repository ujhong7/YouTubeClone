//
//  String+.swift
//  YouTubeClone
//
//  Created by yujaehong on 6/11/24.
//

import Foundation

extension String {
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" // 서버에서 받는 날짜 형식
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // 날짜 형식의 로캘 설정
        return dateFormatter.date(from: self)
    }
}

