//
//  EditorDTO.swift
//  Grain
//
//  Created by 지정훈 on 2023/03/21.
//

import Foundation

import Foundation


struct EditorResponse: Codable,Hashable {
    let documents: [EditorDocument]
}

struct EditorDocument: Codable,Hashable {
    let name: String
    let fields: EditoFields
    let createTime, updateTime: String
}

struct EditoFields: Codable,Hashable {
    
    var nickName : EditorStringValue
    var profileImage : EditorStringValue
    var region : EditorStringValue
    var title : EditorStringValue
    var userID : EditorStringValue
    
    var postContent1 : EditorStringValue
    var postContent2 : EditorStringValue
    var postContent3 : EditorStringValue
    var postContent4 : EditorStringValue
    var postContent5 : EditorStringValue
    
    var postImage1 : EditorStringValue
    var postImage2 : EditorStringValue
    var postImage3 : EditorStringValue
    var postImage4 : EditorStringValue
    var postImage5 : EditorStringValue
    var thumbnailTitle1 : EditorStringValue
    var thumbnailTitle2 : EditorStringValue
    var thumbnailTitle3 : EditorStringValue
    
}

struct EditorStringValue : Codable,Hashable {
    var stringValue: String
}
