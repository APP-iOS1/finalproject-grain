//
//  CommunityDTO.swift
//  Grain
//
//  Created by 지정훈 on 2023/01/20.
//

import Foundation


//struct CommunityResponse: Codable {
//    let documents: [CommunityDocument]
//}
//
//struct CommunityDocument: Codable,Hashable{
//    let name: String
//    let fields: CommunityFields
//    let createTime, updateTime: String
//}
//
//struct CommunityFields: Codable,Hashable{
//    let title, category, content, profileImage: CommunityCategory
//    let nickName: CommunityCategory
//    let image: CommunityImage
//    let userID: CommunityCategory
//    let id: CommunityCategory?
//}
//
//struct CommunityCategory: Codable,Hashable {
//    let stringValue: String
//}
//
//struct CommunityImage: Codable,Hashable {
//    let arrayValue: CommunityArrayValue
//}
//
//struct CommunityArrayValue: Codable,Hashable{
//    let values: [CommunityCategory]
//}


// MARK: 전체적으로 구조 코드 수정 1.31일
//// MARK: documents -> 처음 documents 값을 뻄
struct CommunityResponse: Codable {
    let community : [CommunityDTO]
    // 배열로 받았다.
    private enum CodingKeys: String, CodingKey {
        case community = "documents"
    }
}
//CommunityDTO 변수명 바꿔야함
struct CommunityDTO: Codable,Hashable {
    let image: String
    let profileImage : String
    let id : String
    let title : String
    let category : String
    let content : String
    let userID : String
    let nickName : String

    private enum CommunityKeys: String, CodingKey {
        case fields
    }

    private enum FieldKeys: String, CodingKey {
        case image
        case profileImage
        case id
        case title
        case category
        case content
        case userID
        case nickName

    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CommunityKeys.self)       //fields
        let fieldContainer = try container.nestedContainer(keyedBy: FieldKeys.self, forKey: .fields)

        image = try fieldContainer.decode(StringValue.self, forKey: .image).value
        profileImage = try fieldContainer.decode(StringValue.self, forKey: .profileImage).value
        id = try fieldContainer.decode(StringValue.self, forKey: .id).value
        title = try fieldContainer.decode(StringValue.self, forKey: .userID).value
        category = try fieldContainer.decode(StringValue.self, forKey: .title).value
        content = try fieldContainer.decode(StringValue.self, forKey: .content).value
        userID = try fieldContainer.decode(StringValue.self, forKey: .userID).value
        nickName = try fieldContainer.decode(StringValue.self, forKey: .nickName).value

    }

}
