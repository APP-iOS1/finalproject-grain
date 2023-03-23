//
//  CommunityDTO.swift
//  Grain
//
//  Created by 지정훈 on 2023/01/20.
//

import Foundation


struct CommunityResponse: Codable {
    var documents: [CommunityDocument]
    let nextPageToken: String?
}

struct CommunityDocument: Codable,Hashable{
    var name: String
    var fields: CommunityFields
    var createTime, updateTime: String
    // MARK: 로직
    /* renderTime()을 쓰기 위한 노력: Date타입에 쓸 수 있음 Date -> String (ex."n시간 전")
     우리가 받아오는 community.createTime은 "2023-02-08T14:13:07.734982Z"형식의 String
     renderTime()을 쓰려면 "yyyy-MM-dd"의 String에서 .toDate()를 통해 Date타입으로 바꿔야함
     "2023-02-08T14:13:07.734982Z" 문자열을 잘라줘서 "2023-02-08"(subString)으로 바꾼뒤 String으로 형변환 - communityDateStr
     toDate() 함수를 써서 String -> Date로 바꿈 - dateTime
     renderTime() 함수를 써서 n시간 전 String으로 계산
     communityDate에 최종적으로 넣어줌 */
    var createdDate: Date? {
        let startIndex = createTime.startIndex
        let endIndex = createTime.index(createTime.startIndex, offsetBy: 9)
        let range = startIndex...endIndex
        //2023-02-08형태의 String
        let createdAt = String(createTime[range])
        return createdAt.toDate()
    }
    
}

struct CommunityFields: Codable,Hashable{
    var title, category, content, profileImage, introduce: CommunityCategory
    var state: CommunityCategory
    var nickName: CommunityCategory
    var image: CommunityImage
    var userID: CommunityCategory
    var id: CommunityCategory
}

struct CommunityCategory: Codable,Hashable {
    var stringValue: String
}

struct CommunityImage: Codable,Hashable {
    var arrayValue: CommunityArrayValue
}

struct CommunityArrayValue: Codable,Hashable{
    var values: [CommunityCategory]
}
