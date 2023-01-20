////
////  FirebaseService.swift
////  Grain
////
////  Created by 지정훈 on 2023/01/18.
////
//
//import Foundation
//import Combine
//
//
//enum FirebaseService{
//    
//    private enum HTTPMethod: String {
//        case get = "GET"
//        case post = "POST"
//        case patch = "PATCH"
//    }
//    
//    // MARK: - 매거진 데이터 가져오기
//    static func getMagazine() -> AnyPublisher<MagazineResponse, Error> {
//        print("FirebaseServic getMagazine start")
//        let firestoreURL = "https://firestore.googleapis.com/v1/projects/grain-final/databases/(default)/documents/Magazine"
//        
//        // FIXME: 확인 필요  -> firestoreURL)!)
//        var request = URLRequest(url: URL(string: firestoreURL)!)
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpMethod = HTTPMethod.get.rawValue
//
//        return URLSession
//            .shared
//            .dataTaskPublisher(for: request)
//            .map{ $0.data}
//            .decode(type: MagazineResponse.self, decoder: JSONDecoder())
//            .eraseToAnyPublisher()
//    }
//    
//    // MARK: - 매거진 데이터 넣기
//    static func insertMagazine(userID: String, cameraInfo: String, nickName: String, image: String, content: String, title: String,lenseInfo:String,longitude: String,likedNum: String,filmInfo: String, customPlaceName: String,latitude: String,comment: String,roadAddress: String ) -> AnyPublisher<MagazineResponse, Error> {
//        print("FirebaseServic insertMagazine start")
//        
//        let firestoreURL = "https://firestore.googleapis.com/v1/projects/grain-final/databases/(default)/documents"
//        guard let url = URL(string: "\(firestoreURL)/Magazine") else {
//            return
//        }
//
//        var request = URLRequest(url: url)
//        
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpMethod = HTTPMethod.post.rawValue   //post 방식
//        request.httpBody = MagazineQuery.insertMagazineQuery(userID: userID, cameraInfo: cameraInfo, nickName: nickName, image: image, content: content, title: title, lenseInfo: lenseInfo, longitude: longitude, likedNum: likedNum, filmInfo: filmInfo, customPlaceName: customPlaceName, latitude: latitude, comment: comment, roadAddress: roadAddress)
//
//        return URLSession
//            .shared
//            .dataTaskPublisher(for: request)
//            .map{ $0.data }
//            .decode(type: MagazineResponse.self, decoder: JSONDecoder())
//            .eraseToAnyPublisher()
//    }
//    
//    
//    // MARK: - 커뮤니티 데이터 가져오기
//    static func insertCommunity() -> AnyPublisher<CommunityResponse, Error> {
//        print("FirebaseService getCommunity start")
//        
//        let firestoreURL = "https://firestore.googleapis.com/v1/projects/grain-final/databases/(default)/documents/Community"
//        
////        var request = URLRequest(url: (URL(string: firestoreURL) ?? URL(string: ""))! )
//        
//        var request = URLRequest(url: URL(string: firestoreURL)!)
//        
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpMethod = HTTPMethod.get.rawValue
//
//        return URLSession
//            .shared
//            .dataTaskPublisher(for: request)
//            .map{ $0.data}
//            .decode(type: CommunityResponse.self, decoder: JSONDecoder())
//            .eraseToAnyPublisher()
//    }
//    
//    //MARK: - 커뮤니티 데이터 넣기
//    static func insertCommunity(profileImage: String,nickName: String,category: String,image: String,userID: String,title: String,content: String) -> AnyPublisher<CommunityResponse, Error> {
//        let firestoreURL = "https://firestore.googleapis.com/v1/projects/grain-final/databases/(default)/documents"
//        guard let url = URL(string: "\(firestoreURL)/Community") else {
//            return
//        }
//
//        var request = URLRequest(url: url)
//        
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpMethod = HTTPMethod.post.rawValue   //post 방식
//        request.httpBody = CommunityQuery.insertCommunityQuery(profileImage: profileImage, nickName: nickName, category: category, image: image, userID: userID, title: title, content: content)
//
//        return URLSession
//            .shared
//            .dataTaskPublisher(for: request)
//            .map{ $0.data }
//            .decode(type: CommunityResponse.self, decoder: JSONDecoder())
//            .eraseToAnyPublisher()
//    }
//    
//    
////
////    // MARK: 매거진 데이터 넣기
////    static func insertMagazine(userID: String, cameraInfo: String, nickName: String, image: String, content: String, title: String){
////        let firestoreURL = "https://firestore.googleapis.com/v1/projects/grain-final/databases/(default)/documents"
////        guard let url = URL(string: "\(firestoreURL)/Magazine") else {
////            return
////        }
////
////        var request = URLRequest(url: url )
////
////        // MARK: 리퀘스트 헤더 설정
////        request.addValue("application/json", forHTTPHeaderField: "Content-Type") //서버에 길이 알림
////        request.httpMethod = HTTPMethod.post.rawValue   //post 방식
////        request.httpBody = MagazineQuery.insertMagazineQuery(userID: userID, cameraInfo: cameraInfo, nickName: nickName, image: image, content: content, title: title)
////
////
////        // 서버 통신
////        URLSession.shared.dataTask(with: request) { (data, response, error) in
////
////        }.resume()
////
////    }
////
////    // MARK: 커뮤니티 데이터 넣기
////    static func insertCommunity(profileImage: String,nickName: String,category: String,image: String,userID: String,title: String,content: String){
////        let firestoreURL = "https://firestore.googleapis.com/v1/projects/grain-final/databases/(default)/documents"
////        guard let url = URL(string: "\(firestoreURL)/Community") else {
////            return
////        }
////
////        var request = URLRequest(url: url)
////
////        // MARK: 리퀘스트 헤더 설정
////        request.addValue("application/json", forHTTPHeaderField: "Content-Type") //서버에 길이 알림
////        request.httpMethod = HTTPMethod.post.rawValue   //post 방식
////        request.httpBody = MagazineQuery.insertCommunityQuery(profileImage: profileImage,nickName: nickName,category: category,image: image,userID: userID,title: title,content: content)
////
////
////        // 서버 통신
////        URLSession.shared.dataTask(with: request) { (data, response, error) in
////
////        }.resume()
////
////    }
////
//
//}
