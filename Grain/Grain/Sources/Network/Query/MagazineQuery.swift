//
//  MagazineQuery.swift
//  Grain
//
//  Created by 지정훈 on 2023/01/18.
//

import Foundation


enum MagazineQuery {
    
    // MARK: 매거진 DB에 데이터 저장
    /// id값 패스
    static func insertMagazineQuery(userID: String, cameraInfo: String, nickName: String, image: String, content: String, title: String,lenseInfo:String,longitude: String,likedNum: String,filmInfo: String, customPlaceName: String,latitude: String,comment: String,roadAddress: String) -> Data?{
        return
        """
        {
                   "fields": {
                                   "customPlaceName": {
                                       "stringValue": "\(customPlaceName)"
                                   },
                                   "image": {
                                       "stringValue": "\(image)"
                                   },
                                   "filmInfo": {
                                       "stringValue": "\(filmInfo)"
                                   },
                                   "roadAddress": {
                                       "stringValue": "\(roadAddress)"
                                   },
                                   "userID": {
                                       "stringValue": "\(userID)"
                                   },
                                   "lenseInfo": {
                                       "stringValue": "\(lenseInfo)"
                                   },
                                   "id": {
                                       "stringValue": "패스"
                                   },
                                   "cameraInfo": {
                                       "stringValue": "\(cameraInfo)"
                                   },
                                   "likedNum": {
                                       "stringValue": "\(likedNum)"
                                   },
                                   "title": {
                                       "stringValue": "\(title)"
                                   },
                                   "latitude": {
                                       "stringValue": "\(latitude)"
                                   },
                                   "longitude": {
                                       "stringValue": "\(longitude)"
                                   },
                                   "content": {
                                       "stringValue": "\(content)"
                                   },
                                   "nickName": {
                                       "stringValue": "\(nickName)"
                                   }
                               }
                }
        """.data(using: .utf8)
    }
}
