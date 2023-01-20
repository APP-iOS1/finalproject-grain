//
//  TestService.swift
//  Grain
//
//  Created by 지정훈 on 2023/01/20.
//

import Foundation
import Combine


final class TestService {
    
    private enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case patch = "PATCH"
    }
    
    func getMagazine() -> AnyPublisher<MagazineResponse, Error> {
        print("TestService getMagazine start")
        let firestoreURL = "https://firestore.googleapis.com/v1/projects/grain-final/databases/(default)/documents/Magazine"
        
        var request = URLRequest(url: (URL(string: firestoreURL) ?? URL(string: ""))! )
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") //서버에 길이 알림
        request.httpMethod = HTTPMethod.get.rawValue
//        URLSession.shared.dataTask(with: request
        return URLSession
            .shared
            .dataTaskPublisher(for: request)
            .map{ $0.data}
            .decode(type: MagazineResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    
    
}
