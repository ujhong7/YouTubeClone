//
//  Int+.swift
//  YouTubeClone
//
//  Created by yujaehong on 6/11/24.
//

import Foundation

extension Int {
    func formattedViewCount() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        if self >= 1000000 {
            let formattedNumber = Double(self) / 10000 // 만 단위로 나누기
            numberFormatter.minimumFractionDigits = 0 // 소수점 없음
            numberFormatter.maximumFractionDigits = 0 // 소수점 없음
            return "\(numberFormatter.string(from: NSNumber(value: formattedNumber))!)만회"
        } else if self >= 100000 {
            let formattedNumber = Double(self) / 10000 // 만 단위로 나누기
            numberFormatter.minimumFractionDigits = 0 // 소수점 첫째 자리
            numberFormatter.maximumFractionDigits = 0 // 소수점 첫째 자리
            return "\(numberFormatter.string(from: NSNumber(value: formattedNumber))!)만회"
        } else if self >= 1000 {
            let formattedNumber = Double(self) / 1000 // 천 단위로 나누기
            numberFormatter.minimumFractionDigits = 1 // 소수점 첫째 자리
            numberFormatter.maximumFractionDigits = 1 // 소수점 첫째 자리
            return "\(numberFormatter.string(from: NSNumber(value: formattedNumber))!)천회"
        } else if self >= 100 {
            let formattedNumber = Double(self) / 100 // 백 단위로 나누기
            numberFormatter.minimumFractionDigits = 0 // 소수점 없음
            numberFormatter.maximumFractionDigits = 0 // 소수점 없음
            return "\(numberFormatter.string(from: NSNumber(value: formattedNumber))!)백회"
        } else {
            return "\(numberFormatter.string(from: NSNumber(value: self))!)회"
        }
    }
}

