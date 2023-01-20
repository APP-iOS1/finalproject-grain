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
    static func insertMagazineQuery(userID: String, cameraInfo: String, nickName: String, image: String, content: String, title: String,lenseInfo:String,longitude: String,likedNum: String,filmInfo: String, customPlaceName: String,latitude: String,comment: String,roadAddress: String ) -> Data?{
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
                                   "userId": {
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
                                       "integerValue": "0"
                                   },
                                   "title": {
                                       "stringValue": "\(title)"
                                   },
                                   "latitude": {
                                       "integerValue": "0"
                                   },
                                   "longitude": {
                                       "integerValue": "0"
                                   },
                                   "content": {
                                       "stringValue": "\(content)"
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
