//
//  UserService.swift
//  Grain
//
//  Created by 지정훈 on 2023/02/01.
//

import Foundation
import Combine

// TODO: 유저가 좋아요 누른 게시물 id update method [x]
// TODO: 유저가 좋아요 누른 커뮤니티 글 id update method [x]
// TODO: 유저가 즐겨찾기한 사람 id update method [x]

enum UserService {
    
    // MARK: - 스토리지 이미지 가져오기
    static func getUser() -> AnyPublisher<UserResponse, Error> {
       
        do {
            let request = try UserRouter.get.asURLRequest()
            return URLSession
                .shared
                .dataTaskPublisher(for: request)
                .map{ $0.data}
                .decode(type: UserResponse.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: HTTPError.requestError).eraseToAnyPublisher()
        }
    }
    
    // MARK: - 맵 데이터 넣기
    static func insertUser(myFilm: String,bookmarkedMagazineID: String,email: String,myCamera: String,postedCommunityID: String,postedMagazineID: String,likedMagazineId: String,lastSearched: String,bookmarkedCommunityID: String,recentSearch: String,id: String,following: String,myLens : String,profileImage: String,name: String,follower: String,nickName: String ) -> AnyPublisher<UserDocument, Error> {
       
        
        let requestRouter = UserRouter.post(myFilm: myFilm,bookmarkedMagazineID: bookmarkedMagazineID,email: email,myCamera: myCamera,postedCommunityID: postedCommunityID,postedMagazineID: postedMagazineID,likedMagazineId: likedMagazineId,lastSearched: lastSearched,bookmarkedCommunityID: bookmarkedCommunityID,recentSearch: recentSearch,id: id,following: following,myLens :myLens,profileImage: profileImage,name: name,follower: follower,nickName: nickName)
        
        do {
            let request = try requestRouter.asURLRequest()
            return URLSession
                .shared
                .dataTaskPublisher(for: request)
                .map{ $0.data }
                .decode(type: UserDocument.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: HTTPError.requestError).eraseToAnyPublisher()
        }
    }
    
    static func getCurrentUser(userID: String) -> AnyPublisher<CurrentUserResponse, Error> {

        let firestoreURL = "https://firestore.googleapis.com/v1/projects/grain-final/databases/(default)/documents/User/\(userID)"
        let encodeQueryURL = firestoreURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

        var request = URLRequest(url: URL(string: encodeQueryURL)!)
        
        do {
            request = try UserRouter.get.asURLRequestCurrent(request: request)
            return URLSession
                .shared
                .dataTaskPublisher(for: request)
                .map{ $0.data}
                .decode(type: CurrentUserResponse.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: HTTPError.requestError).eraseToAnyPublisher()
        }
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
