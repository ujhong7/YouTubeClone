//
//  Date+.swift
//  YouTubeClone
//
//  Created by yujaehong on 6/11/24.
//

import Foundation

extension Date {
    /// // '몇 시간 전' 형식으로 변환
    func timeAgoSinceDate(currentDate: Date = Date(), numericDates: Bool = true) -> String {
        let calendar = Calendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let components = calendar.dateComponents(unitFlags, from: self, to: currentDate)
        
        if let year = components.year, year >= 2 {
            return "\(year)년 전"
        } else if let year = components.year, year >= 1 {
            if numericDates {
                return "1년 전"
            } else {
                return "작년"
            }
        } else if let month = components.month, month >= 2 {
            return "\(month)개월 전"
        } else if let month = components.month, month >= 1 {
            if numericDates {
                return "1개월 전"
            } else {
                return "지난 달"
            }
        } else if let week = components.weekOfYear, week >= 2 {
            return "\(week)주 전"
        } else if let week = components.weekOfYear, week >= 1 {
            if numericDates {
                return "1주 전"
            } else {
                return "지난 주"
            }
        } else if let day = components.day, day >= 2 {
            return "\(day)일 전"
        } else if let day = components.day, day >= 1 {
            if numericDates {
                return "1일 전"
            } else {
                return "어제"
            }
        } else if let hour = components.hour, hour >= 2 {
            return "\(hour)시간 전"
        } else if let hour = components.hour, hour >= 1 {
            if numericDates {
                return "1시간 전"
            } else {
                return "한 시간 전"
            }
        } else if let minute = components.minute, minute >= 2 {
            return "\(minute)분 전"
        } else if let minute = components.minute, minute >= 1 {
            if numericDates {
                return "1분 전"
            } else {
                return "한 분 전"
            }
        } else if let second = components.second, second >= 3 {
            return "\(second)초 전"
        } else {
            return "방금 전"
        }
    }
}

