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
                guard let url = URL(string: "\(firestoreURL)/Magazine") else {
            return
        }
        var request = URLRequest(url: url )

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue

        request.httpBody = MagazineQuery.insert()

        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
           

        }.resume()

    }
    
    static func getMagazine(){
        let firestoreURL = "https://firestore.googleapis.com/v1/projects/grain-final/databases/(default)/documents"
                guard let url = URL(string: "\(firestoreURL)/Magazine") else {
            return
        }
        var request = URLRequest(url: url )

        request.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            
            // TODO: DTO 파일 형식으로 디코딩해보기
            let outputStr = String(data: data, encoding: String.Encoding.utf8)
            print("result: \(outputStr!)")

        }.resume()

    }
}
