//
//  MapDTO.swift
//  Grain
//
//  Created by 지정훈 on 2023/01/31.
//

import Foundation

struct MapResponse: Codable {
    let documents: [MapDocument]
}

struct MapDocument: Codable,Hashable {
    let name: String
    let fields: Fields
    let createTime, updateTime: String
}

struct Fields: Codable,Hashable {
    let magazineID: MagazineID
    let id: MapID
    let longitude: MapLocation
    let url: MapID
    let latitude: MapLocation
    let category: MapCategory
    
    enum CodingKeys: String, CodingKey {
        case magazineID = "magazineId"
        case id, longitude, url, latitude, category
    }
}

struct MapCategory: Codable,Hashable {
    let integerValue: String
}

struct MapID: Codable,Hashable {
    let stringValue: String
}

struct MapLocation: Codable,Hashable {
    let doubleValue: Double
}

struct MagazineID: Codable,Hashable {
    let arrayValue: MapArrayValue
}

struct MapArrayValue: Codable,Hashable {
    let values: [MapID]
}
