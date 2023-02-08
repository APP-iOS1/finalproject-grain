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
        
        do {
            let request = try CommunityRouter.get.asURLRequest()
            return URLSession
                .shared
                .dataTaskPublisher(for: request)
                .map{ $0.data }
                .decode(type: CommunityResponse.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: HTTPError.requestError).eraseToAnyPublisher()
        }
    }
    
    //MARK: - 커뮤니티 데이터 넣기
    static func insertCommunity(profileImage: String, nickName: String,category: String,image: String,userID: String,title: String,content: String ) -> AnyPublisher<CommunityResponse, Error> {
       
        do {
            let requestRouter = CommunityRouter.post(profileImage: profileImage, nickName: nickName, category: category, image: image, userID: userID, title: title, content: content)
            let request = try requestRouter.asURLRequest()
            return URLSession
                .shared
                .dataTaskPublisher(for: request)
                .map{ $0.data }
                .decode(type: CommunityResponse.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: HTTPError.requestError).eraseToAnyPublisher()
        }
    }
    
}
