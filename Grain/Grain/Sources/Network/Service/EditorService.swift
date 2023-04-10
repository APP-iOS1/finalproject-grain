//
//  EditorService.swift
//  Grain
//
//  Created by 지정훈 on 2023/03/21.
//

import Foundation
import Combine

enum EditorService {
    
    
    static func getEditor() -> AnyPublisher<EditorResponse, Error> {
        
        do {
            let request = try EditorRouter.get.asURLRequest()
            return URLSession
                .shared
                .dataTaskPublisher(for: request)
                .map{ $0.data}
                .decode(type: EditorResponse.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: HTTPError.requestError).eraseToAnyPublisher()
        }
    }
        
}
