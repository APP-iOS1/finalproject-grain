//
//  ReportMapQuery.swift
//  Grain
//
//  Created by 지정훈 on 2023/03/07.
//

import Foundation

enum ReportMapQuery {
    
    // MARK: 커뮤니티 DB에 데이터 저장
    static func insertReportMapQuery(data: ReportMapFields , docID: String) -> Data? {
  
        return
        """
        {
        "fields": {
                        "longitude": {
                            "doubleValue": \(data.longitude.doubleValue)
                        },
                        "latitude": {
                            "doubleValue": \(data.latitude.doubleValue)
                        },
                        "storeName": {
                            "stringValue": "\(data.storeName.stringValue)"
                        },
                        "category": {
                            "stringValue": "\(data.category.stringValue)"
                        }
                    }
        }
        
        
        """.data(using: .utf8)
    }
}
