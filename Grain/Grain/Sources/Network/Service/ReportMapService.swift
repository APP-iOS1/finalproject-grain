//
//  ReportMapService.swift
//  Grain
//
//  Created by 지정훈 on 2023/03/07.
//

import Foundation
import Combine

enum ReportMapService {
    
    
    static func insertReportMap(data: ReportMapFields) -> AnyPublisher<ReportMapDocument, Error> {

        let docID: String = UUID().uuidString
     
        let requestRouter = ReportMapRouter.post(reportMapData: data, docID: docID)

        do {
            let request = try requestRouter.asURLRequest()
            
            return URLSession
                .shared
                .dataTaskPublisher(for: request)
                .map{ $0.data }
                .decode(type: ReportMapDocument.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: HTTPError.requestError).eraseToAnyPublisher()
        }
    }
    
}
