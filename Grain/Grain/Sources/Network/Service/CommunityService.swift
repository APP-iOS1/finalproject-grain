//
//  CommunityService.swift
//  Grain
//
//  Created by 박희경 on 2023/01/20.
//

import Foundation
import Combine

enum CommunityService {
    
    private enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case patch = "PATCH"
    }
    
    
    // MARK: - 커뮤니티 데이터 가져오기
    static func getCommunity() -> AnyPublisher<CommunityResponse, Error> {
        print("FirebaseService getCommunity start")
        
        let firestoreURL = "https://firestore.googleapis.com/v1/projects/grain-final/databases/(default)/documents/Community"
        
        // FIXME: 확인 필요  -> firestoreURL)!)
        var request = URLRequest(url: URL(string: firestoreURL)!)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.get.rawValue
        
        return URLSession
            .shared
            .dataTaskPublisher(for: request)
            .map{ $0.data}
            .decode(type: CommunityResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    //MARK: - 커뮤니티 데이터 넣기
    static func insertCommunity(profileImage: String,nickName: String,category: String,image: String,userID: String,title: String,content: String ) -> AnyPublisher<CommunityResponse, Error> {
        let firestoreURL = "https://firestore.googleapis.com/v1/projects/grain-final/databases/(default)/documents"
        let url = URL(string: "\(firestoreURL)/Community")
        
        // FIXME: 확인 필요 -> url!)
        var request = URLRequest(url: url!)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue   //post 방식
        request.httpBody = CommunityQuery.insertCommunityQuery(profileImage: profileImage, nickName: nickName, category: category, image: image, userID: userID, title: title, content: content)
        
        return URLSession
            .shared
            .dataTaskPublisher(for: request)
            .map{ $0.data }
            .decode(type: CommunityResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
}
