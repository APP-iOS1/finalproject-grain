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
    let image: String
    let profileImage : String
    let id : String
    let title : String
    let category : String
    let content : String
    let userID : String
    let nickName : String
    
    private enum MagazineKeys: String, CodingKey {
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
        let container = try decoder.container(keyedBy: MagazineKeys.self)       //fields
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
