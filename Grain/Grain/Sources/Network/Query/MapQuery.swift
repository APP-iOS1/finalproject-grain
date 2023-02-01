//
//  MapQuery.swift
//  Grain
//
//  Created by 지정훈 on 2023/01/31.
//
import Foundation

enum MapQuery {
    
    // MARK: 커뮤니티 DB에 데이터 저장
    static func insertMapQuery(latitude: Double,url: String,id: String,category: Int,magazineId: String,longitude: Double) -> Data? {
  
        return
        """
        {
        "fields": {
                        "latitude": {
                            "doubleValue": \(latitude)
                        },
                        "url": {
                            "stringValue": "\(url)"
                        },
                        "id": {
                            "stringValue": "id패스"
                        },
                        "category": {
                            "integerValue": \(category)
                        },
                        "magazineId": {
                            "arrayValue": {
                                "values": [
                                    {
                                        "stringValue": "\(magazineId)"
                                    }
                                ]
                            }
                        },
                        "longitude": {
                            "doubleValue": \(longitude)
                        }
                    }
                }
        }
        """.data(using: .utf8)
    }
}
