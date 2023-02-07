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
    static func insertUser(myFilm: String,bookmarkedMagazineID: String,email: String,myCamera: String,postedCommunityID: String,postedMagazineID: String,likedMagazineId: String,lastSearched: String,bookmarkedCommunityID: String,recentSearch: String,id: String,following: String,myLens : String,profileImage: String,name: String,follower: String,nickName: String ) -> AnyPublisher<UserDocument, Error> {
       
        
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
            .decode(type: UserDocument.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    static func getCurrentUser(userID: String) -> AnyPublisher<CurrentUserResponse, Error> {

        let firestoreURL = "https://firestore.googleapis.com/v1/projects/grain-final/databases/(default)/documents/User/\(userID)"
        let encodeQueryURL = firestoreURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

        var request = URLRequest(url: URL(string: encodeQueryURL)!)
        do {
            request = try UserRouter.get.asURLRequestCurrent(request: request)
        } catch {
            // [x] error handling
            print("http error")
        }
        return URLSession
            .shared
            .dataTaskPublisher(for: request)
            .map{ $0.data}
            .decode(type: CurrentUserResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    // 데이터 삭제
//    func deleteCode(){
//        let firestoreRef = "https://firestore.googleapis.com/v1/projects/{PROJECT_ID}/databases/(default)/documents/{DOCUMENT_PATH}"
//        // MARK: 콜렉션 / uuid 값
//        let documentPath = "User/gTQvo3MwawdxVMU0IfYv"
//
//
//        let url = URL(string: firestoreRef.replacingOccurrences(of: "{PROJECT_ID}", with: "grain-final")
//                        .replacingOccurrences(of: "{DOCUMENT_PATH}", with: documentPath))!
//
//        var urlRequest = URLRequest(url: url)
//        urlRequest.httpMethod = "DELETE"
//
//        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
//            if let error = error {
//                print("Error deleting document: \(error)")
//                return
//            }
//            print("Document deleted successfully")
//        }.resume()
//
//    }

}
