//
//  MagazineDTO.swift
//  Grain
//
//  Created by 지정훈 on 2023/01/18.
//
import Foundation

struct MagazineResponse: Codable {
    let documents: [MagazineDocument]
}

struct MagazineDocument: Codable,Hashable {
    let fields: MagazineFields
}

struct MagazineFields: Codable,Hashable{
    let filmInfo, id, customPlaceName: MagazineString
    let longitude: MagazineLocation
    let title: MagazineString
    let comment: MagazineComment
    let lenseInfo, userID: MagazineString
    let image: MagazineComment
    let likedNum: LikedNum
    let latitude: MagazineLocation
    let content, nickName, roadAddress, cameraInfo: MagazineString
}

struct MagazineString: Codable ,Hashable{
    let stringValue: String
}

struct MagazineComment: Codable,Hashable {
    let arrayValue: MagazineArrayValue
}

struct MagazineArrayValue: Codable,Hashable {
    let values: [MagazineString]
}

struct MagazineLocation: Codable,Hashable {
    let doubleValue: Double?
}

struct LikedNum: Codable,Hashable {
    let integerValue: String
}


// MARK: 전체적으로 구조 코드 수정 1.31일
//// MARK: documents -> 처음 documents 값을 뻄
//struct MagazineResponse: Codable{
//    let magazines : [MagazineDTO]
//    // 배열로 받았다.
//    private enum CodingKeys: String, CodingKey {
//        case magazines = "documents"
//    }
//
//}
//
////객체를 디코딩하고 있음
//struct MagazineDTO: Codable,Hashable,Identifiable{
//    let likedNum: String
//    let id: String
//    let userID: String
//    let title: String
//    let content: String
//    let cameraInfo: String
//    let nickName: String
//    let image: String
//    let filmInfo: String
//    let latitude: String
//    let lenseInfo: String
//    let longitude: String
//    let roadAddress: String
//    let customPlaceName: String
//
//    private enum MagazineKeys: String, CodingKey {
//        case fields
//    }
//    private enum FieldKeys: String, CodingKey {
//        case likedNum
//        case id
//        case userID
//        case title
//        case content
//        case cameraInfo
//        case nickName
//        case image
//        case filmInfo
//        case latitude
//        case lenseInfo
//        case longitude
//        case roadAddress
//        case customPlaceName
//
//    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: MagazineKeys.self)       //fields
//        let fieldContainer = try container.nestedContainer(keyedBy: FieldKeys.self, forKey: .fields)
//
//        image = try fieldContainer.decode(StringValue.self, forKey: .image).value
//        likedNum = try fieldContainer.decode(StringValue.self, forKey: .likedNum).value
//        id = try fieldContainer.decode(StringValue.self, forKey: .id).value
//        userID = try fieldContainer.decode(StringValue.self, forKey: .userID).value
//        title = try fieldContainer.decode(StringValue.self, forKey: .title).value
//        content = try fieldContainer.decode(StringValue.self, forKey: .content).value
//        cameraInfo = try fieldContainer.decode(StringValue.self, forKey: .cameraInfo).value
//        nickName = try fieldContainer.decode(StringValue.self, forKey: .nickName).value
//        filmInfo = try fieldContainer.decode(StringValue.self, forKey: .filmInfo).value
//        latitude = try fieldContainer.decode(StringValue.self, forKey: .latitude).value
//        lenseInfo = try fieldContainer.decode(StringValue.self, forKey: .lenseInfo).value
//        longitude = try fieldContainer.decode(StringValue.self, forKey: .longitude).value
//        roadAddress = try fieldContainer.decode(StringValue.self, forKey: .roadAddress).value
//        customPlaceName = try fieldContainer.decode(StringValue.self, forKey: .customPlaceName).value
//    }
//
//}
//
//// MARK: StringValue
struct StringValue: Codable{
    let value: String
    private enum CodingKeys: String, CodingKey {
        case value = "stringValue"
    }
}

//// MARK: IntegerValue
//struct IntegerValue: Codable{
//    let value: String
//    private enum CodingKeys: String, CodingKey {
//        case value = "integerValue"
//    }
//}
//struct ArrayValue: Codable{
//    let values : String
//    private enum CodingKeys: String, CodingKey {
//        case values = "values"
//    }
//}
