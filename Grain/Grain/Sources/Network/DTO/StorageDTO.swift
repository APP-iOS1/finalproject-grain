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



// MARK: 전체적으로 구조 코드 수정 1.31일
// MARK: documents -> 처음 documents 값을 뻄
//struct StorageResponse: Codable{
//    let storages : [StorageDTO]
//    // 배열로 받았다.
//    private enum CodingKeys: String, CodingKey {
//        case storages = "items"
//    }
//
//}
//struct StorageDTO: Codable,Hashable{
//    let name: String
//
//    private enum StorageKeys: String, CodingKey {
//        case name
//        //case bucket 필요 없을거 같음
//
//    }
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
////        let container = try decoder.container(keyedBy: StorageKeys.self)
////        print(container)
//        let fieldContainer = try container.nestedContainer(keyedBy: StorageKeys.self, forKey: .name)
////        print(fieldContainer)
//        name = try container.decode(NameValue.self, forKey: .name).value
////        print(name)
//
//    }
//
//}
// MARK: StringValue
//struct NameValue: Codable{
//    let value: String
//    private enum CodingKeys: String, CodingKey {
//        case value = "name"
//    }
//}
