//
//  UserDTO.swift
//  Grain
//
//  Created by 지정훈 on 2023/02/01.
//

import Foundation

struct UserResponse: Codable {
    var documents: [UserDocument]
}

struct UserDocument: Codable,Hashable {
    var name : String
    var fields: UserFields
    var createTime, updateTime: String
}

struct UserFields: Codable,Hashable {
    var likedMagazineID: UserArrayKey
    var id: UserStringValue
    var myLens, myFilm, postedCommunityID: UserArrayKey
    var nickName: UserStringValue
    var introduce: UserStringValue
    var following: UserArrayKey
    var profileImage: UserStringValue
    var recentSearch, bookmarkedCommunityID, follower, lastSearched: UserArrayKey
    var email: UserStringValue
    var postedMagazineID, myCamera, bookmarkedMagazineID: UserArrayKey
    var name: UserStringValue
    
    enum CodingKeys: String, CodingKey {
        case likedMagazineID = "likedMagazineId"
        case id, myLens, myFilm, postedCommunityID, nickName, introduce, following, profileImage, recentSearch, bookmarkedCommunityID, follower, lastSearched, email, postedMagazineID, myCamera, bookmarkedMagazineID, name
    }
}

struct UserArrayKey: Codable,Hashable {
    var arrayValue: UserArrayValue
}

struct UserArrayValue: Codable,Hashable{
    var values: [UserStringValue]
}


struct UserStringValue: Codable,Hashable{
    var stringValue: String
}
