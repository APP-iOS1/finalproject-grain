//
//  Ex+Date.swift
//  Grain
//
//  Created by 조형구 on 2023/01/18.
//

import Foundation

extension Date {
    func isBetween(_ startDate: Date, and endDate: Date) -> Bool {
        return startDate <= self && self < endDate
    }
    ///게시한 시간 몇시간 전 형식으로 표시하는 function
    func renderTime() -> String {
        if Calendar.current.dateComponents([.day], from: self, to: .now).day! > 7 { // 기준 7일
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.timeZone = TimeZone(abbreviation: "KST")
            formatter.amSymbol = "오전"
            formatter.pmSymbol = "오후"
            formatter.dateStyle = .long
            formatter.timeStyle = .short
            formatter.dateFormat = "yyyy.MM.dd"
            return formatter.string(from: self)
        }
        
        // 방금전, 몇초전을 나타내는 함수
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateTimeStyle = .named
        return formatter.localizedString(for: self, relativeTo: .now)
    }
    
    static func fromString(string: String, format: String = "yyyy-MM-dd") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: string)
    }
}
