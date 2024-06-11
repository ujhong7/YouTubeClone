//
//  String+.swift
//  YouTubeClone
//
//  Created by Kant on 6/11/24.
//

import Foundation

extension String {
    /// 날짜 문자열 파싱
    func parseDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" // 서버에서 받는 날짜 형식
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // 날짜 형식의 로캘 설정
        return dateFormatter.date(from: self)
    }
}
