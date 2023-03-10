//
//  ReportMapDTO.swift
//  Grain
//
//  Created by 지정훈 on 2023/03/07.
//


import Foundation

struct ReportMapResponse: Codable {
    let documents: [ReportMapDocument]
}


struct ReportMapDocument: Codable {
    let fields: ReportMapFields
    let createTime, updateTime: String
}


struct ReportMapFields: Codable {
    let longitude, latitude: ReportMapDoubleValue
    let storeName, category: ReportMapStringValue
}


struct ReportMapStringValue: Codable {
    let stringValue: String
}

struct ReportMapDoubleValue: Codable {
    let doubleValue: Double
}
