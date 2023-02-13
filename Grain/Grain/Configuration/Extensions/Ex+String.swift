//
//  Ex+String.swift
//  Grain
//
//  Created by 조형구 on 2023/01/18.
//

import Foundation

extension String {
    func toDate() -> Date? { //"yyyy-MM-dd HH:mm:ss"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        dateFormatter.timeZone = TimeZone(identifier: "ko_KR")
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
}

//extension String {
//    func toDate() -> Date? { //"yyyy-MM-dd HH:mm:ss"
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        dateFormatter.timeZone = TimeZone(identifier: "ko_KR")
//        if let date = dateFormatter.date(from: self) {
//            let newDate = date // "yyyy-MM-dd HH:mm:ss" 형태의 date타입
//            let myDateFormatter = DateFormatter()
//            myDateFormatter.dateFormat = "yyyy-MM-dd" // 2020.08.13 오후 04시 30분
//            myDateFormatter.locale = Locale(identifier:"ko_KR") // PM, AM을 언어에 맞게 setting (ex: PM -> 오후)
//            let convertNowStr = myDateFormatter.string(from: newDate) // 현재 시간의 Date를 format에 맞춰 string으로 반환
//            return
//        }
//
//        return Date()
//    }
//}
//
