//
//  MagazineQuery.swift
//  Grain
//
//  Created by 지정훈 on 2023/01/18.
//

import Foundation


enum MagazineQuery {
    
    
   // MARK: 매거진 DB에 데이터 저장
    static func insertMagazineQuery(userID: String, cameraInfo: String, nickName: String, image: String, content: String, title: String ) -> Data?{
        return
        """
        {
                    "fields": {
                                    "likedNum": {
                                        "integerValue": "0"
                                    },
                                    "userID": {
                                        "stringValue": "\(userID)"
                                    },
                                    "id": {
                                        "stringValue": "패스"
                                    },
                                    "cameraInfo": {
                                        "stringValue": "\(cameraInfo)"
                                    },
                                    "nickName": {
                                        "stringValue": "\(nickName)"
                                    },
                                    "image": {
                                        "stringValue": "\(image)"
                                    },
                                    "content": {
                                        "stringValue": "\(content)"
                                    },
                                    "title": {
                                        "stringValue": "\(title)"
                                    }
                                }
                }
        """.data(using: .utf8)
    }
    // MARK: 커뮤니티 DB에 데이터 저장
    static func insertCommunityQuery(profileImage: String,nickName: String,category: String,image: String,userID: String,title: String,content: String ) -> Data?{
  
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
