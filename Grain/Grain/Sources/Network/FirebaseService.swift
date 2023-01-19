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
    
    
    //POST 데이터 넣기
    static func insertMagazine(){
        let firestoreURL = "https://firestore.googleapis.com/v1/projects/grain-final/databases/(default)/documents"
                guard let url = URL(string: "\(firestoreURL)/Magazine") else {
            return
        }
        // https://melod-it.gitbook.io/sagwa/app-frameworks/foundation/url-loading-system/urlrequest 읽어보기
        var request = URLRequest(url: url )

        // MARK: 리퀘스트 헤더 설정
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") //서버에 길이 알림
        request.httpMethod = HTTPMethod.post.rawValue   //post 방식
        request.httpBody = MagazineQuery.insert()
        

        // 서버 통신
        URLSession.shared.dataTask(with: request) { (data, response, error) in
           
        }.resume()
        
    }
    
    
    static func getMagazine(){
        let firestoreURL = "https://firestore.googleapis.com/v1/projects/grain-final/databases/(default)/documents/Magazine"
                guard let url = URL(string: firestoreURL) else {
            return
        }
        var request = URLRequest(url: url)

        request.httpMethod = HTTPMethod.get.rawValue

        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
      
//            // error가 존재하면 종료
//            guard error == nil else { return }
//
//            // status 코드가 200번대여야 성공적인 네트워크라 판단
//            let successsRange = 200..<300
//            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
//                  successsRange.contains(statusCode) else { return }
//
//
//            guard let resultData = data else { return }
//                let resultString = String(data: resultData, encoding: .utf8)
//
//            print(resultString)
            guard let data = data, error == nil else{
                fatalError("error")
            }
            
            let response = try? JSONDecoder().decode(MagazineResponse.self, from: data)
            if let response = response{
                print("response: \(response) \n")
                for i in response.magazines{
                    print(i.title)
                    print(i.likedNum)
                }
            }

        }.resume()

    }
}
