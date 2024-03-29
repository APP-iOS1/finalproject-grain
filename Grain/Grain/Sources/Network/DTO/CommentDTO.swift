//
//  CommentDTO.swift
//  Grain
//
//  Created by 지정훈 on 2023/02/10.
//

import Foundation

// MARK: - CommentResponse: Comment 컬렉션 아래 [ 문서 ID ]
struct CommentResponse: Codable,Hashable {
    var documents: [CommentDocument]
    let nextPageToken: String?
}
// MARK: - CommentDocument: 문서
///  fields: 타고 들어가 유저 필드값을 뽑을수 있음 fields.userId
/// createTime: 최초 만들어진 날짜
/// updateTime: 업데이트 된 날짜
struct CommentDocument: Codable,Hashable {
    var name: String
    var fields: CommentFields
    var createTime, updateTime: String
    
    var createdDate: Date? {
        let startIndex = updateTime.startIndex
        let endIndex = updateTime.index(updateTime.startIndex, offsetBy: 9)
        let range = startIndex...endIndex
        //2023-02-08형태의 String
        let createdAt = String(updateTime[range])
        return createdAt.toDate()
    }
}
struct CommentFields: Codable,Hashable {
    var comment, profileImage, nickName, userID, id: CommentString
}
// FIXME: - stringValue 통합해야 할듯
struct CommentString: Codable,Hashable {
    var stringValue: String
}
