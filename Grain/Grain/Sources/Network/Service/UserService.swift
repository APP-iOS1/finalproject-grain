//
//  UserService.swift
//  Grain
//
//  Created by 지정훈 on 2023/02/01.
//

import Foundation
import Combine

enum UserService {
    
    // MARK: - 스토리지 이미지 가져오기
    static func getUser() -> AnyPublisher<UserResponse, Error> {
        
        let firestoreURL = "https://firestore.googleapis.com/v1/projects/grain-final/databases/(default)/documents/User"
        
        var request = URLRequest(url: URL(string: firestoreURL)!)
        do {
            request = try UserRouter.get.asURLRequest()
        } catch {
            // [x] error handling
            print("http error")
        }
        return URLSession
            .shared
            .dataTaskPublisher(for: request)
            .map{ $0.data}
            .decode(type: UserResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    // MARK: - 맵 데이터 넣기
    static func insertUser(myFilm: String,bookmarkedMagazineID: String,email: String,myCamera: String,postedCommunityID: String,postedMagazineID: String,likedMagazineId: String,lastSearched: String,bookmarkedCommunityID: String,recentSearch: String,id: String,following: String,myLens : String,profileImage: String,name: String,follower: String,nickName: String ) -> AnyPublisher<UserResponse, Error> {
       
        
        let requestRouter = UserRouter.post(myFilm: myFilm,bookmarkedMagazineID: bookmarkedMagazineID,email: email,myCamera: myCamera,postedCommunityID: postedCommunityID,postedMagazineID: postedMagazineID,likedMagazineId: likedMagazineId,lastSearched: lastSearched,bookmarkedCommunityID: bookmarkedCommunityID,recentSearch: recentSearch,id: id,following: following,myLens :myLens,profileImage: profileImage,name: name,follower: follower,nickName: nickName)
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
            .decode(type: UserResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
}
