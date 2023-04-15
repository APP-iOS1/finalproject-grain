//
//  CurrentUserDTO.swift
//  Grain
//
//  Created by 지정훈 on 2023/02/02.
//
//
import Foundation

struct CurrentUserResponse: Codable {
    var name : String
    var fields: CurrentUserFields
    var createTime, updateTime: String
    let nextPageToken: String?
}
struct CurrentUserFields: Codable {
    var bookmarkedCommunityID, lastSearched, follower, following: CurrentUserUpperArrayValue
    var myFilm: CurrentUserUpperArrayValue
    var name: CurrentUserStringValue
    var myLens: CurrentUserUpperArrayValue
    var nickName, introduce: CurrentUserStringValue
    var bookmarkedMagazineID, myCamera, fcmToken: CurrentUserUpperArrayValue
    var profileImage: CurrentUserStringValue
    var postedCommunityID: CurrentUserUpperArrayValue
    var email, id: CurrentUserStringValue
    var recentSearch, likedMagazineID, postedMagazineID: CurrentUserUpperArrayValue
    var blocking, blocked: CurrentUserUpperArrayValue

    enum CodingKeys: String, CodingKey {
        case bookmarkedCommunityID, lastSearched, follower, following, myFilm, name, myLens, nickName, bookmarkedMagazineID, myCamera, introduce, profileImage, postedCommunityID, email, id, recentSearch, fcmToken, blocking, blocked
        case likedMagazineID = "likedMagazineId"
        case postedMagazineID
    }
}
struct CurrentUserUpperArrayValue: Codable {
    var arrayValue: CurrentUserArrayValue
}
struct CurrentUserArrayValue: Codable {
    var values: [CurrentUserStringValue]
}
struct CurrentUserStringValue: Codable, Hashable {
    var stringValue: String
}
