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
    static func insertMagazineQuery(userID: String, cameraInfo: String, nickName: String, image: String, content: String, title: String,lenseInfo:String,longitude: Double,likedNum: Int,filmInfo: String, customPlaceName: String,latitude: Double,comment: String,roadAddress: String) -> Data?{
        return
        """
        {
            "fields": {
                        "longitude": {
                            "integerValue": \(longitude)
                        },
                        "likedNum": {
                            "integerValue": \(likedNum)
                        },
                        "nickName": {
                            "stringValue": "\(nickName)"
                        },
                        "cameraInfo": {
                            "stringValue": "\(cameraInfo)"
                        },
                        "latitude": {
                            "integerValue": \(latitude)
                        },
                        "title": {
                            "stringValue": "\(title)"
                        },
                        "image": {
                            "arrayValue": {
                                "values": [
                                    {
                                        "stringValue":  "\(image)"
                                    }
                                ]
                            }
                        },
                        "filmInfo": {
                            "stringValue": "\(filmInfo)"
                        },
                        "customPlaceName": {
                            "stringValue": "\(customPlaceName)"
                        },
                        "content": {
                            "stringValue": "\(content)"
                        },
                        "userID": {
                            "stringValue": "\(userID)"
                        },
                        "lenseInfo": {
                            "stringValue": "\(lenseInfo)"
                        },
                        "comment": {
                            "arrayValue": {
                                "values": [
                                    {
                                        "stringValue": "\(comment)"
                                    }
                                ]
                            }
                        },
                        "id": {
                            "stringValue":  "id패스"
                        },
                        "roadAddress": {
                            "stringValue": "\(roadAddress)"
                        }
                    }
            }
        """.data(using: .utf8)
    }
}
