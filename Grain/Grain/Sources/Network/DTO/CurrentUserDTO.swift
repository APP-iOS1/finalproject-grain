//
//  CurrentUserDTO.swift
//  Grain
//
//  Created by 지정훈 on 2023/02/02.
//
//
import Foundation

struct CurrentUserResponse: Codable {
    let name : String
    let fields: CurrentUserFields
    let createTime, updateTime: String
}
struct CurrentUserFields: Codable {
    let bookmarkedCommunityID, lastSearched, follower, following: CurrentUserUpperArrayValue
    let myFilm: CurrentUserUpperArrayValue
    let name: CurrentUserStringValue
    let myLens: CurrentUserUpperArrayValue
    let nickName: CurrentUserStringValue
    let bookmarkedMagazineID, myCamera: CurrentUserUpperArrayValue
    let profileImage: CurrentUserStringValue
    let postedCommunityID: CurrentUserUpperArrayValue
    let email, id: CurrentUserStringValue
    let recentSearch, likedMagazineID, postedMagazineID: CurrentUserUpperArrayValue

    enum CodingKeys: String, CodingKey {
        case bookmarkedCommunityID, lastSearched, follower, following, myFilm, name, myLens, nickName, bookmarkedMagazineID, myCamera, profileImage, postedCommunityID, email, id, recentSearch
        case likedMagazineID = "likedMagazineId"
        case postedMagazineID
    }
}
struct CurrentUserUpperArrayValue: Codable {
    let arrayValue: CurrentUserArrayValue
}
struct CurrentUserArrayValue: Codable {
    let values: [CurrentUserStringValue]
}
struct CurrentUserStringValue: Codable, Hashable {
    let stringValue: String
}

