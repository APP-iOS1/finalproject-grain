//
//  Ex+Color.swift
//  Grain
//
//  Created by 조형구 on 2023/01/18.
//

import Foundation
import SwiftUI

extension Color { // 사용법: Color(hex: "#439F47")
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >>  8) & 0xFF) / 255.0
        let b = Double((rgb >>  0) & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
    static let textGray = Color(hex: "495057")
    static let boxGray = Color(hex: "323232")
    static let brightGray = Color(hex: "bbbbbb")
    static let middlebrightGray = Color(hex: "9a9a9a")
    static let middleDarkGray = Color(hex: "616161")
    static let middleDarkRed = Color(hex: "d61500")
}
