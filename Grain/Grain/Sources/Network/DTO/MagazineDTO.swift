//
//  MagazineDTO.swift
//  Grain
//
//  Created by 지정훈 on 2023/01/18.
//

// MARK: documents -> 처음 documents 값을 뻄
struct MagazineResponse: Codable{
    let magazines : [Magazine]

    private enum CodingKeys: String, CodingKey {
        case magazines = "documents"
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

// TODO: 배열쪽 도전중 
//struct ArrayImage: Codable{
//    let values: String
//    private enum MagazineKeys: String, CodingKey {
//        case arrayValue
//
//    }
//    private enum ArrayImageFieldKeys: String, CodingKey {
//        case values
//    }
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: MagazineKeys.self)
//
//        self.values = try container.decode(String.self, forKey: .values)
//    }
//}

// fields
struct Magazine: Codable{
    let likedNum: String
//    let image: [ArrayImage]
    let id: String
    let userID: String
    let title: String
    let content: String
    let cameraInfo: String
    let nickName: String
    
    private enum MagazineKeys: String, CodingKey {
        case fields
    }
    
    private enum FieldKeys: String, CodingKey {
        case likedNum
        case image
        case id
        case userID
        case title
        case content
        case cameraInfo
        case nickName
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MagazineKeys.self)
        let fieldContainer = try container.nestedContainer(keyedBy: FieldKeys.self, forKey: .fields)
        likedNum = try fieldContainer.decode(IntegerValue.self, forKey: .likedNum).value
//        image = try fieldContainer.decode(StringValue.self, forKey: .image).value
        id = try fieldContainer.decode(StringValue.self, forKey: .id).value
        userID = try fieldContainer.decode(StringValue.self, forKey: .userID).value
        title = try fieldContainer.decode(StringValue.self, forKey: .title).value
        content = try fieldContainer.decode(StringValue.self, forKey: .content).value
        cameraInfo = try fieldContainer.decode(StringValue.self, forKey: .cameraInfo).value
        nickName = try fieldContainer.decode(StringValue.self, forKey: .nickName).value

    }
    
}
