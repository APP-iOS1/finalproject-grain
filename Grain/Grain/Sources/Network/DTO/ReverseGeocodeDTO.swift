//
//  ReverseGeocodeDTO.swift
//  Grain
//
//  Created by 지정훈 on 2023/02/01.
//

import Foundation

struct ReverseGeocodeDTO: Codable {
    let results: [ReverseGeocodeResult]
}
struct ReverseGeocodeResult:  Codable,Hashable {
    let region: Region
}

struct Region:  Codable,Hashable {
    let area1: Area
    let area2: Area
    let area3: Area
    let area4: Area
}
struct Area:  Codable,Hashable {
    let name: String
}


