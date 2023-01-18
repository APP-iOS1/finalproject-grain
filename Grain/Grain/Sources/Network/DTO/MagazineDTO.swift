//
//  MagazineDTO.swift
//  Grain
//
//  Created by 지정훈 on 2023/01/18.
//

import Foundation
struct MagazineDTO: Codable{
    let document: Fields<MagazineFields>?
    
    init() {
        self.document = nil
    }
    init(
        id: String,
        userId: String,
        image: [String],
        title: String,
        content: String,
        likedNum: String,
        cameraInfo: String,
        nickName: String
    ){
        let field = MagazineFields(id: StringField(stringValue: id), userId: StringField(stringValue: userId), image: ArrayField(ArrayValue: [InnerArray(innerArrayValue: "1")]), title: StringField(stringValue: title), content: StringField(stringValue: content), likedNum: StringField(stringValue: likedNum), cameraInfo: StringField(stringValue: cameraInfo), nickName: StringField(stringValue: nickName))
        self.document = Fields(name: nil, fields: field)
    }
}
struct MagazineFields: Codable{
    var id: StringField
    var userId: StringField
    var image: ArrayField
    var title: StringField
    var content: StringField
    var likedNum: StringField
    var cameraInfo: StringField
    var nickName: StringField
//    var filmInfo: StringField
//    var lenseInfo: StringField
//    var createdAt : TimestampField
//
//    var latitude : DoubleField
//    var longitude : DoubleField
//    var customPlaceName : StringField
//    var roadAddress : StringField
//    var comment: [Comment]

}




