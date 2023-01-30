//
//  MagazineDTO.swift
//  Grain
//
//  Created by 지정훈 on 2023/01/18.
//

// MARK: documents -> 처음 documents 값을 뻄
struct MagazineResponse: Codable{
    let magazines : [MagazineDTO]
    // 배열로 받았다.
    private enum CodingKeys: String, CodingKey {
        case magazines = "documents"
    }

}

struct ArrayValue: Codable{
    let values : String
    private enum CodingKeys: String, CodingKey {
        case values = "values"
    }
}
//객체를 디코딩하고 있음

struct MagazineDTO: Codable,Hashable{
    let likedNum: String
    let id: String
    let userID: String
    let title: String
    let content: String
    let cameraInfo: String
    let nickName: String
    let image: String
    let filmInfo: String
    let latitude: String
    let lenseInfo: String
    let longitude: String
    let roadAddress: String
    
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
        case filmInfo
        case latitude
        case lenseInfo
        case longitude
        case roadAddress
    }


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
        filmInfo = try fieldContainer.decode(StringValue.self, forKey: .filmInfo).value
        latitude = try fieldContainer.decode(StringValue.self, forKey: .latitude).value
        lenseInfo = try fieldContainer.decode(IntegerValue.self, forKey: .lenseInfo).value
        longitude = try fieldContainer.decode(IntegerValue.self, forKey: .longitude).value
        roadAddress = try fieldContainer.decode(StringValue.self, forKey: .roadAddress).value
    }

}

// MARK: StringValue
struct StringValue: Codable{
    let value: String
    private enum CodingKeys: String, CodingKey {
        case value = "stringValue"
    }
}
// MARK: IntegerValue
struct IntegerValue: Codable{
    let value: String
    private enum CodingKeys: String, CodingKey {
        case value = "integerValue"
    }
}

