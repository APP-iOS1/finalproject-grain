//
//  NaverAPIType.swift
//  Grain
//
//  Created by 지정훈 on 2023/01/29.
//

import Foundation

struct GeocodeDTO: Codable {
    let addresses: [Address]
    let errorMessage: String
}

struct Address: Codable {
    let roadAddress, jibunAddress, englishAddress: String
    let x, y: String
    let distance: Double
    
}
