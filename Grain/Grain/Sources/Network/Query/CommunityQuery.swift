//
//  CommunityQuery.swift
//  Grain
//
//  Created by 지정훈 on 2023/01/20.
//

import Foundation

enum CommunityQuery {
    
    // MARK: 커뮤니티 DB에 데이터 저장
    static func insertCommunityQuery(data: CommunityFields, images: [String], docID: String) -> Data? {
        
        var str : String = ""
        var comment : String = ""
        
        for i in 0..<images.count {
            str += """
                 { "stringValue": "\(images[i])" },
                """
        }
        // FIXME: comment 부분 추가해야함.
        return
        """
        {
        "fields": {
                        "profileImage": {
                            "stringValue": "\(data.profileImage.stringValue)"
                        },
                        "nickName": {
                            "stringValue": "\(data.nickName.stringValue))"
                        },
                        "category": {
                            "stringValue": "\(data.category.stringValue))"
                        },
                        "image": {
                            "arrayValue": {
                                "values": [
                                    \(str)
                                ]
                            }
                        },
                        "userID": {
                            "stringValue": "\(data.userID.stringValue)"
                        },
                        "state": {
                            "stringValue": "모집중"
                        },
                        "id": {
                            "stringValue": "\(docID)"
                        },
                        "title": {
                            "stringValue": "\(data.title.stringValue)"
                        },
                        "content": {
                            "stringValue": "\(data.content.stringValue)"
                        }
                    }
        }
        """.data(using: .utf8)
    }
    
    // MARK: 커뮤니티 DB에 데이터 upate
    static func updateCommunityQuery(data: CommunityDocument, docID: String) -> Data? {
        
        var str : String = ""
        
        // FIXME: comment 부분 추가해야함.
        return
        """
        {
        "fields": {
                        "profileImage": {
                            "stringValue": "\(data.fields.profileImage.stringValue)"
                        },
                        "nickName": {
                            "stringValue": "\(data.fields.nickName.stringValue))"
                        },
                        "category": {
                            "stringValue": "\(data.fields.category.stringValue))"
                        },
                        "image": {
                            "arrayValue": {
                                "values": [
                                    \(str)
                                ]
                            }
                        },
                        "state": {
                            "stringValue": "\(data.fields.state.stringValue)"
                        },
                        "userID": {
                            "stringValue": "\(data.fields.userID.stringValue)"
                        },
                        "id": {
                            "stringValue": "\(docID)"
                        },
                        "title": {
                            "stringValue": "\(data.fields.title.stringValue)"
                        },
                        "content": {
                            "stringValue": "\(data.fields.content.stringValue)"
                        }
                    }
        }
        """.data(using: .utf8)
        
    }
    
    //MARK: - 커뮤니티 DB에 모집중 <-> 모집마감 상태 update 쿼리 리턴 메소드
    static func updateCommunityStateQuery(state: String) -> Data? {
        let query = """
                        {
                          "fields": {
                               "state": {
                                    "stringValue": "\(state)"
                        }
                    }
                }
                """.data(using: .utf8)
        
        return query
    }
}

