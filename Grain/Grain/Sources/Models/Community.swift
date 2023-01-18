//
//  Community.swift
//  Grain
//
//  Created by 조형구 on 2023/01/18.
//

import Foundation

struct Community: Hashable, Identifiable, Codable {
    var id: String
    var category: Int
    var userID: String
    var image: [String]
    var title: String
    var profileImage: String
    var nickName: String
    
    var location: String
    var content: String
    var createdAt: Date
}

