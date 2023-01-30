//
//  CommunityQuery.swift
//  Grain
//
//  Created by 지정훈 on 2023/01/20.
//

import Foundation

enum CommunityQuery {
    
    // MARK: 커뮤니티 DB에 데이터 저장
    static func insertCommunityQuery(profileImage: String, nickName: String, category: String, image: String, userID: String, title: String, content: String) -> Data? {
  
        return
        
        """
        {
        "fields": {
                        "profileImage": {
                            "stringValue": "\(profileImage)"
                        },
                        "nickName": {
                            "stringValue": "\(nickName)"
                        },
                        "category": {
                            "stringValue": "\(category)"
                        },
                        "image": {
                            "stringValue": "\(image)"
                        },
                        "userID": {
                            "stringValue": "\(userID)"
                        },
                        "id": {
                            "stringValue": "패스"
                        },
                        "title": {
                            "stringValue": "\(title)"
                        },
                        "content": {
                            "stringValue": "\(content)"
                        }
                    }
        }
        """.data(using: .utf8)
    }
}
