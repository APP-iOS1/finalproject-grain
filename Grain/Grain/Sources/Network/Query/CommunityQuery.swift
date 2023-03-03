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
            
            for i in 0..<images.count {
                str += """
                     { "stringValue": "\(images[i])" },
                    """
            }
            
            str.removeLast()
            
            var state : String = ""
            switch data.category.stringValue{
            case "매칭","클래스":
                state = "모집중"
            case "마켓":
                state = "판매중"
            case "정보":
                state = "Tip"
            default:
                state = "default"
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
                                "stringValue": "\(data.nickName.stringValue)"
                            },
                            "category": {
                                "stringValue": "\(data.category.stringValue)"
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
                            "introduce": {
                                "stringValue": "\(data.introduce.stringValue)"
                            },
                            "state": {
                                "stringValue": "\(state)"
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
            
            for i in data.fields.image.arrayValue.values {
                str += """
                     { "stringValue": "\(i.stringValue)" },
                    """
            }
            str.removeLast()
            
            return
            """
            {
            "fields": {
                            "profileImage": {
                                "stringValue": "\(data.fields.profileImage.stringValue)"
                            },
                            "nickName": {
                                "stringValue": "\(data.fields.nickName.stringValue)"
                            },
                            "category": {
                                "stringValue": "\(data.fields.category.stringValue)"
                            },
                            "image": {
                                "arrayValue": {
                                    "values": [
                                        \(str)
                                    ]
                                }
                            },
                            "introduce": {
                                "stringValue": "\(data.fields.introduce.stringValue)"
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

