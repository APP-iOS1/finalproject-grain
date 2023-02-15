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
    static let ultraBrightGray = Color(hex: "EEEEEE")
    
    static let googleBackground = Color(hex: "4285F4")
    static let vivaMagenta = Color(hex: "BB2649")
    static let illuminating = Color(hex: "F5DF4D")
    static let classicBlue = Color(hex: "0F4C81")
    static let livingCoral = Color(hex: "FF6F61")
    static let ultraViolet = Color(hex: "5F4B8B")
    
    static let colorSetOne = Color(hex: "051821")
    static let colorSetTwo = Color(hex: "1A4645")
    static let colorSetThree = Color(hex: "266867")
    static let colorSetFour = Color(hex: "F58800")
    static let colorSetFive = Color(hex: "F8BC24")
    
    static let longBlackOne = Color(hex: "#DB6745")
    static let longBlackTwo = Color(hex: "#5C62ED")
    static let longBlackThree = Color(hex: "#BBE5AB")
    
    static let graySand = Color(hex: "#e5ccaf")
    static let paleKhaki = Color(hex: "#bfaf92")
    

    static let communityPurple = Color(hex: "#807EFC")
    static let communityGreen = Color(hex: "#6CD9B7")
    static let communityLime = Color(hex: "#E3F084")
    static let communityPink = Color(hex: "#FA98E0")

    static let lotionWhite = Color(hex: "#FBFBFB")
    static let floralWhite = Color(hex: "#FFFAF1")
    static let paleWhite = Color(hex: "#f8f8ff")

    
}
