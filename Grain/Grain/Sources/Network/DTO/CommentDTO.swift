//
//  CommentDTO.swift
//  Grain
//
//  Created by 지정훈 on 2023/02/10.
//

import Foundation

// MARK: - CommentResponse: Comment 컬렉션 아래 [ 문서 ID ]
struct CommentResponse: Codable {
    let documents: [CommentDocument]
}
// MARK: - CommentDocument: 문서
/// name:  해당 응답 path( 경로 값 ) ex)  "projects/grain-final/databases/(default)/documents/Magazine/1BA19CE5-119C-4898-9EC2-0BB920EAC64D/Comment/93Ku6eSMImVC8gJJbN6a",
///  fields: 타고 들어가 유저 필드값을 뽑을수 있음 fields.userId
/// createTime: 최초 만들어진 날짜
/// updateTime: 업데이트 된 날짜
struct CommentDocument: Codable {
    let name: String
    let fields: CommentFields
    let createTime, updateTime: String
}
struct CommentFields: Codable {
    let comment, profileImage, nickName, userID: CommentString
}
// FIXME: - stringValue 통합해야 할듯
struct CommentString: Codable {
    let stringValue: String
}
