//
//  CommunityService.swift
//  Grain
//
//  Created by 박희경 on 2023/01/20.
//

import Foundation
import Combine

enum CommunityService {

    // MARK: - 커뮤니티 데이터 가져오기
    static func getCommunity() -> AnyPublisher<CommunityResponse, Error> {
        print("FirebaseService getCommunity start")
        
        let firestoreURL = "https://firestore.googleapis.com/v1/projects/grain-final/databases/(default)/documents/Community"
      
        var request = URLRequest(url: URL(string: firestoreURL)!)
        
        do {
            request = try CommunityRouter.get.asURLRequest()
        } catch {
            // [x] error handling
            print("http error")
        }
        
        return URLSession
            .shared
            .dataTaskPublisher(for: request)
            .map{ $0.data }
            .decode(type: CommunityResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    //MARK: - 커뮤니티 데이터 넣기
    static func insertCommunity(profileImage: String, nickName: String,category: String,image: String,userID: String,title: String,content: String ) -> AnyPublisher<CommunityResponse, Error> {
       
        let requestRouter = CommunityRouter.post(profileImage: profileImage, nickName: nickName, category: category, image: image, userID: userID, title: title, content: content)
        var request: URLRequest =  URLRequest(url: URL(string: "dfsfsdfd")!)

        do {
            request = try requestRouter.asURLRequest()
        } catch {
            print("http error!")
        }
        
        return URLSession
            .shared
            .dataTaskPublisher(for: request)
            .map{ $0.data }
            .decode(type: CommunityResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
        
    }
    
}
