//
//  MagazineQuery.swift
//  Grain
//
//  Created by 지정훈 on 2023/01/18.
//

import Foundation

enum MagazineQuery {
    static func insert() -> Data?{
        return
        """
        {
                    "fields": {
                        "id": {
                            "stringValue": "Mo9Fh2OcOQss3VcYMD5Y"
                        },
                        "cameraInfo": {
                            "stringValue": "후지 instax mini 40"
                        },
                        "image": {
                            "arrayValue": {
                                "values": [
                                    {
                                        "stringValue": ""
                                    }
                                ]
                            }
                        },
                        "content": {
                            "stringValue": "연남동 근방 스팟추천합니다"
                        },
                        "userID": {
                            "stringValue": "DluAWVV7DuUzYTIZHo82"
                        },
                        "nickName": {
                            "stringValue": "승수2"
                        },
                        "title": {
                            "stringValue": "연남동 주변 스팟 추천"
                        },
                        "likedNum": {
                            "integerValue": "12"
                        }
        
                    }
                }
        """.data(using: .utf8)
    }
}
