//
//  MapQuery.swift
//  Grain
//
//  Created by 지정훈 on 2023/01/31.
//
import Foundation

enum MapQuery {
    
    // MARK: 커뮤니티 DB에 데이터 저장
    static func insertMapQuery(data: MagazineFields , docID: String) -> Data? {
  
        return
        """
        {
        "fields": {
                        "latitude": {
                            "doubleValue": \(data.latitude.doubleValue!)
                        },
                        "url": {
                            "stringValue": "default"
                        },
                        "id": {
                            "stringValue": "\(docID)"
                        },
                        "category": {
                            "stringValue": "포토스팟"
                        },
                        "magazineId": {
                            "arrayValue": {
                                "values": [
                                    {
                                        "stringValue": "\(data.id.stringValue)"
                                    }
                                ]
                            }
                        },
                        "longitude": {
                            "doubleValue": \(data.longitude.doubleValue!)
                        }
                }
        }
        
        
        """.data(using: .utf8)
    }
}
