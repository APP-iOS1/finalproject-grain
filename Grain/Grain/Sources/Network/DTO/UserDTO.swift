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

struct UserDocument: Codable {
    let name: String
    let fields: UserFields
    let createTime, updateTime: String
}

struct UserFields: Codable {
    let myFilm, bookmarkedMagazineID, myCamera, postedCommunityID: BookmarkedCommunityID?
    let postedMagazineID, likedMagazineID, lastSearched, bookmarkedCommunityID: BookmarkedCommunityID?
    let recentSearch: UserEmail?
    let id: UserEmail
    let following, myLens: BookmarkedCommunityID?
    let profileImage: UserEmail?
    let follower: BookmarkedCommunityID?
    let nickName, name, email: UserEmail?

    enum CodingKeys: String, CodingKey {
        case myFilm, bookmarkedMagazineID, myCamera, postedCommunityID, postedMagazineID
        case likedMagazineID = "likedMagazineId"
        case lastSearched, bookmarkedCommunityID, recentSearch, id, following, myLens, profileImage, follower, nickName, name, email
    }
}


struct BookmarkedCommunityID: Codable {
    let arrayValue: UserArrayValue
}


struct UserArrayValue: Codable {
    let values: [UserEmail]
}


struct UserEmail: Codable {
    let stringValue: String
}
