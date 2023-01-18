//
//  MagazineDTO.swift
//  Grain
//
//  Created by 지정훈 on 2023/01/18.
//

import Foundation
struct MagazineDTO: Codable{
    
    
}
struct MagazineFields: Codable{
    var id: StringField
    var userId: StringField
    var image: ArrayField
    var title: StringField
    var content: StringField
    var likedNum: IntegerField
    var cameraInfo: StringField
    var filmInfo: StringField
    var lenseInfo: StringField
    var createdAt : TimestampField

    var latitude : DoubleField
    var longitude : DoubleField
    var customPlaceName : StringField
    var roadAddress : StringField
//    var comment: [Comment]

}




