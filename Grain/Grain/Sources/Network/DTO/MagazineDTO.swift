//
//  MagazineDTO.swift
//  Grain
//
//  Created by 지정훈 on 2023/01/18.
//

import Foundation

struct MagazineResponse: Codable {
    var documents: [MagazineDocument]
}

struct MagazineDocument: Codable,Hashable {
    var fields: MagazineFields
    var name: String
    var createTime: String
    var updateTime: String
    
    var createdDate: Date? {
        let startIndex = createTime.startIndex
        let endIndex = createTime.index(createTime.startIndex, offsetBy: 9)
        let range = startIndex...endIndex
        //2023-02-08형태의 String
        let createdAt = String(createTime[range])
        return createdAt.toDate()
    }
}

struct MagazineFields: Codable,Hashable{
    var filmInfo, id, customPlaceName: MagazineString
    var longitude: MagazineLocation
    var title: MagazineString
    var comment: MagazineComment
    var lenseInfo, userID: MagazineString
    var image: MagazineComment
    var likedNum: LikedNum
    var latitude: MagazineLocation
    var content, nickName, roadAddress, cameraInfo: MagazineString
    
}

struct MagazineString: Codable ,Hashable{
    var stringValue: String
}

struct MagazineComment: Codable,Hashable {
    var arrayValue: MagazineArrayValue
}

struct MagazineArrayValue: Codable,Hashable {
    var values: [MagazineString]
}

struct MagazineLocation: Codable,Hashable {
    var doubleValue: Double?
}

struct LikedNum: Codable,Hashable {
    var integerValue: String
}
