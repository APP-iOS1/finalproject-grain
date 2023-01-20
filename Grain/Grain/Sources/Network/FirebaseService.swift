//
//  FirebaseService.swift
//  Grain
//
//  Created by 지정훈 on 2023/01/18.
//

import Foundation
import Combine



enum FirebaseService{
    private enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case patch = "PATCH"
    }
    
    
    // MARK: 매거진 데이터 넣기
    static func insertMagazine(userID: String, cameraInfo: String, nickName: String, image: String, content: String, title: String){
        let firestoreURL = "https://firestore.googleapis.com/v1/projects/grain-final/databases/(default)/documents"
        guard let url = URL(string: "\(firestoreURL)/Magazine") else {
            return
        }
        
        var request = URLRequest(url: url )
        
        // MARK: 리퀘스트 헤더 설정
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") //서버에 길이 알림
        request.httpMethod = HTTPMethod.post.rawValue   //post 방식
        request.httpBody = MagazineQuery.insertMagazineQuery(userID: userID, cameraInfo: cameraInfo, nickName: nickName, image: image, content: content, title: title)
        
        
        // 서버 통신
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
        }.resume()
        
    }
    
    // MARK: 커뮤니티 데이터 넣기
    static func insertCommunity(profileImage: String,nickName: String,category: String,image: String,userID: String,title: String,content: String){
        let firestoreURL = "https://firestore.googleapis.com/v1/projects/grain-final/databases/(default)/documents"
        guard let url = URL(string: "\(firestoreURL)/Community") else {
            return
        }
        
        var request = URLRequest(url: url)
        
        // MARK: 리퀘스트 헤더 설정
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") //서버에 길이 알림
        request.httpMethod = HTTPMethod.post.rawValue   //post 방식
        request.httpBody = MagazineQuery.insertCommunityQuery(profileImage: profileImage,nickName: nickName,category: category,image: image,userID: userID,title: title,content: content)
        
        
        // 서버 통신
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
        }.resume()
        
    }
    
//    static func getMagazine() {
//        let firestoreURL = "https://firestore.googleapis.com/v1/projects/grain-final/databases/(default)/documents/Magazine"
//        guard let url = URL(string: firestoreURL) else {
//
//            return
//        }
//        var request = URLRequest(url: url)
//
//        request.httpMethod = HTTPMethod.get.rawValue
////        URLSession.shared.dataTask(with: request)
//
//        URLSession.shared.dataTask(with: request) { (data, response, error) in
//
//            //            // status 코드가 200번대여야 성공적인 네트워크라 판단
//            //            let successsRange = 200..<300
//            //            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
//            //                  successsRange.contains(statusCode) else { return }
//            //
//            guard let data = data, error == nil else{
//                fatalError("error")
//            }
//            //
//            let response = try? JSONDecoder().decode(MagazineResponse.self, from: data)
//
//            if let response = response{
//
//                for i in response.magazines{
//                    print(resultArray)
//                }
//            }
//        }.resume()
//    }
}
