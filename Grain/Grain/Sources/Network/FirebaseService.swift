//
//  FirebaseService.swift
//  Grain
//
//  Created by 지정훈 on 2023/01/18.
//

import Foundation

enum FirebaseService{
    private enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case patch = "PATCH"
    }
    
    static func insertMagazine(){
        let firestoreURL = "https://firestore.googleapis.com/v1/projects/grain-final/databases/(default)/documents"
        
//        "\(firestoreURL)/user")
        guard let url = URL(string: "\(firestoreURL)/Magazine") else {
            return
        }
        var request = URLRequest(url: url )
        //        print(request)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
//        print(request.httpMethod!)
        request.httpBody = MagazineQuery.insert()
//        print(request.httpBody!)
        //        print(request)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
           
//            // 응답 처리 로직
//            DispatchQueue.main.async() {
//                // 서버로부터 응답된 스트링 표시
//                let outputStr = String(data: data!, encoding: String.Encoding.utf8)
//                print("result: \(outputStr!)")
//            }
        }.resume()
//        task
    }
}

