//
//  CommunityDTO.swift
//  Grain
//
//  Created by 지정훈 on 2023/01/20.
//

import Foundation

// MARK: documents -> 처음 documents 값을 뻄


struct CommunityResponse: Codable{
    let community : [CommunityDTO]
    // 배열로 받았다.
    private enum CodingKeys: String, CodingKey {
        case community = "documents"
    }

}


//CommunityDTO 변수명 바꿔야함
struct CommunityDTO: Codable,Hashable{
    let likedNum: String
    let id: String
    let userID: String
    let title: String
    let content: String
    let cameraInfo: String
    let nickName: String
    let image: String
    
    private enum MagazineKeys: String, CodingKey {
        case fields
    }
    private enum FieldKeys: String, CodingKey {
        case likedNum
        case id
        case userID
        case title
        case content
        case cameraInfo
        case nickName
        case image
    }
//    private enum ArrayValueFieldKey: String, CodingKey{
//        case arrayValue
//    }
//    private enum ValuesFieldKey: String, CodingKey{
//        case values
//    }
    

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MagazineKeys.self)       //fields
        let fieldContainer = try container.nestedContainer(keyedBy: FieldKeys.self, forKey: .fields)
        
        image = try fieldContainer.decode(StringValue.self, forKey: .image).value
        likedNum = try fieldContainer.decode(IntegerValue.self, forKey: .likedNum).value
        id = try fieldContainer.decode(StringValue.self, forKey: .id).value
        userID = try fieldContainer.decode(StringValue.self, forKey: .userID).value
        title = try fieldContainer.decode(StringValue.self, forKey: .title).value
        content = try fieldContainer.decode(StringValue.self, forKey: .content).value
        cameraInfo = try fieldContainer.decode(StringValue.self, forKey: .cameraInfo).value
        nickName = try fieldContainer.decode(StringValue.self, forKey: .nickName).value

    }

}
