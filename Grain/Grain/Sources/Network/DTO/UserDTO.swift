//
//  UserDTO.swift
//  Grain
//
//  Created by 지정훈 on 2023/02/01.
//

import Foundation

struct UserResponse: Codable {
    let documents: [UserDocument]
}

struct UserDocument: Codable,Hashable {
    let fields: UserFields
    let createTime, updateTime: String
}

struct UserFields: Codable,Hashable {
    let likedMagazineID: UserArrayKey
    let id: UserStringValue
    let myLens, myFilm, postedCommunityID: UserArrayKey
    let nickName: UserStringValue
    let following: UserArrayKey
    let profileImage: UserStringValue
    let recentSearch, bookmarkedCommunityID, follower, lastSearched: UserArrayKey
    let email: UserStringValue
    let postedMagazineID, myCamera, bookmarkedMagazineID: UserArrayKey
    let name: UserStringValue

    enum CodingKeys: String, CodingKey {
        case likedMagazineID = "likedMagazineId"
        case id, myLens, myFilm, postedCommunityID, nickName, following, profileImage, recentSearch, bookmarkedCommunityID, follower, lastSearched, email, postedMagazineID, myCamera, bookmarkedMagazineID, name
    }
}

struct UserArrayKey: Codable,Hashable {
    let arrayValue: UserArrayValue
}
struct UserArrayValue: Codable,Hashable{
    let values: [UserStringValue]
}


struct UserStringValue: Codable,Hashable{
    let stringValue: String
}
