//
//  Int+.swift
//  YouTubeClone
//
//  Created by Kant on 6/11/24.
//

import Foundation

extension Int {
    /// 뷰카운트 String 전환
    func changeFormatToString() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        // 백만회 이상일 때 소수점 없이 표시
        if self >= 1000000 {
            let formattedNumber = Double(self) / 10000 // 만 단위로 나누기
            numberFormatter.minimumFractionDigits = 0 // 소수점 없음
            numberFormatter.maximumFractionDigits = 0 // 소수점 없음
            return "\(numberFormatter.string(from: NSNumber(value: formattedNumber))!)만회"
        }
        // 십만회 이상 백만회 미만일 때 소수점 첫째 자리까지 표시
        else if self >= 100000 {
            let formattedNumber = Double(self) / 10000 // 만 단위로 나누기
            numberFormatter.minimumFractionDigits = 0 // 소수점 첫째 자리
            numberFormatter.maximumFractionDigits = 0 // 소수점 첫째 자리
            return "\(numberFormatter.string(from: NSNumber(value: formattedNumber))!)만회"
        }
        // 천회 이상 십만회 미만일 때 소수점 첫째 자리까지 표시
        else if self >= 1000 {
            let formattedNumber = Double(self) / 1000 // 천 단위로 나누기
            numberFormatter.minimumFractionDigits = 1 // 소수점 첫째 자리
            numberFormatter.maximumFractionDigits = 1 // 소수점 첫째 자리
            return "\(numberFormatter.string(from: NSNumber(value: formattedNumber))!)천회"
        }
        // 백회 이상 천회 미만일 때는 정수로 표시
        else if self >= 100 {
            let formattedNumber = Double(self) / 100 // 백 단위로 나누기
            numberFormatter.minimumFractionDigits = 0 // 소수점 없음
            numberFormatter.maximumFractionDigits = 0 // 소수점 없음
            return "\(numberFormatter.string(from: NSNumber(value: formattedNumber))!)백회"
        }
        // 백회 미만일 때는 정수로 표시
        else {
            return "\(numberFormatter.string(from: NSNumber(value: self))!)회"
        }
    }
}
