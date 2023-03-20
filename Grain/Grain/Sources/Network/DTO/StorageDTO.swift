//
//  StorageDTO.swift
//  Grain
//
//  Created by 지정훈 on 2023/01/31.
//


import Foundation

struct StorageResponse: Codable {
    let items: [StoragePath]
}
struct StoragePath: Codable,Hashable {
    let name : String
}

struct StorageResponsePost: Codable,Hashable {
    let name: String
    let bucket: String
    let storageClass: String
    let size: String
    let downloadTokens: String

    enum CodingKeys: String, CodingKey {
        case name
        case bucket
        case storageClass
        case size
        case downloadTokens
    }
}
