//
//  CommentQuery.swift
//  Grain
//
//  Created by 지정훈 on 2023/02/10.
//

import Foundation

enum CommentQuery {
    
    // MARK: Comment 컬렉션에 저장할 데이터 JSON 구조 쿼리 만듬
    /// .data(using: .utf8)을 이용하여 문자열을 데이터 형식?으로 바꿔줌
    static func insertCommentQuery(data: CommentFields ) -> Data? {
        
        return
        """
        {
            "fields": {
                "nickName": {
                    "stringValue": "\(data.nickName.stringValue)"
                },
                "profileImage": {
                    "stringValue": "\(data.profileImage.stringValue)"
                },
                "userID": {
                    "stringValue": "\(data.userID.stringValue)"
                },
                "comment": {
                    "stringValue": "\(data.comment.stringValue)"
                },
                "id": {
                    "stringValue": "\(data.id.stringValue)"
                }
            }
        }
        """.data(using: .utf8)
    }
    
    static func updateCommentQuery(updateComment: String, data: CommentFields ) -> Data? {
        
        return
        """
        {
            "fields": {
                "nickName": {
                    "stringValue": "\(data.nickName.stringValue)"
                },
                "profileImage": {
                    "stringValue": "\(data.profileImage.stringValue)"
                },
                "userID": {
                    "stringValue": "\(data.userID.stringValue)"
                },
                "comment": {
                    "stringValue": "\(updateComment)"
                },
                "id": {
                    "stringValue": "\(data.id.stringValue)"
                }
            }
        }
        """.data(using: .utf8)
    }
    
    static func insertRecommentQuery(data: CommentFields ) -> Data? {
        return
        """
        {
            "fields": {
                "nickName": {
                    "stringValue": "\(data.nickName.stringValue)"
                },
                "profileImage": {
                    "stringValue": "\(data.profileImage.stringValue)"
                },
                "userID": {
                    "stringValue": "\(data.userID.stringValue)"
                },
                "comment": {
                    "stringValue": "\(data.comment.stringValue)"
                },
                "id": {
                    "stringValue": "\(data.id.stringValue)"
                }
            }
        }
        """.data(using: .utf8)
    }
    
    
    static func updateRecommentQuery(updateComment: String, data: CommentFields ) -> Data? {
        
        return
        """
        {
            "fields": {
                "nickName": {
                    "stringValue": "\(data.nickName.stringValue)"
                },
                "profileImage": {
                    "stringValue": "\(data.profileImage.stringValue)"
                },
                "userID": {
                    "stringValue": "\(data.userID.stringValue)"
                },
                "comment": {
                    "stringValue": "\(updateComment)"
                },
                "id": {
                    "stringValue": "\(data.id.stringValue)"
                }
            }
        }
        """.data(using: .utf8)
    }
}

