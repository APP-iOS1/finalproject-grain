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
        let firestoreURL =  "https://firestore.googleapis.com/v1/projects/grain-final/databases/(default)/documents)"
        let url = URL(string: "\(firestoreURL)/Magazine/\(UUID().uuidString)")
        
        var request = URLRequest(url: url ?? URL(fileURLWithPath: ""))
//        print(request)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = MagazineQuery.insert()
//        print(request)
        
        URLSession.shared.dataTask(with: request) {  data, response, error in
            print(data)
            print("성공???")
        }.resume()
    }
}







