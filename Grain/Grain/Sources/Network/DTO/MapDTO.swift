//
//  MapDTO.swift
//  Grain
//
//  Created by 지정훈 on 2023/01/31.
//

import Foundation

struct MapResponse: Codable {
    let documents: [MapDocument]
    let nextPageToken: String?   // DB에 데이터가 많을 때 다음 페이지로 쿼리를 날려야 하기 때문에 선언!
}

struct MapDocument: Codable,Hashable {
    let fields: Fields
    let createTime, updateTime: String
}

struct Fields: Codable,Hashable {
    let magazineID: MagazineID
    let id: MapID
    let longitude: MapLocation
    let url: MapID
    let latitude: MapLocation
    let category: MapID
    
    enum CodingKeys: String, CodingKey {
        case magazineID = "magazineId"
        case id, longitude, url, latitude, category
    }
}

// FIXME: 분명 Firebase Store에서는 숫자 타입이고 postman에서 실험할떄는 String형으로 나오는지??
// MARK: category: MapCategory -> category: MapID
//struct MapCategory: Codable,Hashable {
//    let integerValue: String
//}

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
