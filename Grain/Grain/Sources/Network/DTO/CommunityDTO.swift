//
//  CommunityDTO.swift
//  Grain
//
//  Created by 지정훈 on 2023/01/20.
//

import Foundation


struct CommunityResponse: Codable {
    let documents: [CommunityDocument]
}

struct CommunityDocument: Codable,Hashable{
    let name: String
    let fields: CommunityFields
    var createTime, updateTime: String
    // MARK: 로직
    // renderTime()을 쓰기 위한 노력: Date타입에 쓸 수 있음 Date -> String (ex."n시간 전")
    // 우리가 받아오는 community.createTime은 "2023-02-08T14:13:07.734982Z"형식의 String
    // renderTime()을 쓰려면 "yyyy-MM-dd"의 String에서 .toDate()를 통해 Date타입으로 바꿔야함
    // "2023-02-08T14:13:07.734982Z" 문자열을 잘라줘서 "2023-02-08"(subString)으로 바꾼뒤 String으로 형변환 - communityDateStr
    // toDate() 함수를 써서 String -> Date로 바꿈 - dateTime
    // renderTime() 함수를 써서 n시간 전 String으로 계산
    // communityDate에 최종적으로 넣어줌
    var createdDate: Date? {
        let startIndex = createTime.startIndex
        let endIndex = createTime.index(createTime.startIndex, offsetBy: 9)
        let range = startIndex...endIndex
        //2023-02-08형태의 String
        let createdAt = String(createTime[range])
        return createdAt.toDate()
    }
    
}

struct CommunityFields: Codable,Hashable{
    let title, category, content, profileImage: CommunityCategory
    let state: CommunityCategory
    let nickName: CommunityCategory
    let image: CommunityImage
    let userID: CommunityCategory
    let id: CommunityCategory
}

struct CommunityCategory: Codable,Hashable {
    let stringValue: String
}

struct CommunityImage: Codable,Hashable {
    let arrayValue: CommunityArrayValue
}

struct CommunityArrayValue: Codable,Hashable{
    let values: [CommunityCategory]
}


// MARK: 전체적으로 구조 코드 수정 1.31일
//// MARK: documents -> 처음 documents 값을 뻄
//struct CommunityResponse: Codable {
//    let community : [CommunityDTO]
//    // 배열로 받았다.
//    private enum CodingKeys: String, CodingKey {
//        case community = "documents"
//    }
//}
////CommunityDTO 변수명 바꿔야함
//struct CommunityDTO: Codable,Hashable {
//    let image: String
//    let profileImage : String
//    let id : String
//    let title : String
//    let category : String
//    let content : String
//    let userID : String
//    let nickName : String
//
//    private enum CommunityKeys: String, CodingKey {
//        case fields
//    }
//
//    private enum FieldKeys: String, CodingKey {
//        case image
//        case profileImage
//        case id
//        case title
//        case category
//        case content
//        case userID
//        case nickName
//
//    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CommunityKeys.self)       //fields
//        let fieldContainer = try container.nestedContainer(keyedBy: FieldKeys.self, forKey: .fields)
//
//        image = try fieldContainer.decode(StringValue.self, forKey: .image).value
//        profileImage = try fieldContainer.decode(StringValue.self, forKey: .profileImage).value
//        id = try fieldContainer.decode(StringValue.self, forKey: .id).value
//        title = try fieldContainer.decode(StringValue.self, forKey: .userID).value
//        category = try fieldContainer.decode(StringValue.self, forKey: .title).value
//        content = try fieldContainer.decode(StringValue.self, forKey: .content).value
//        userID = try fieldContainer.decode(StringValue.self, forKey: .userID).value
//        nickName = try fieldContainer.decode(StringValue.self, forKey: .nickName).value
//
//    }
//
//}
