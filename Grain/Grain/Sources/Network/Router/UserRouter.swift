//
//  UserRouter.swift
//  Grain
//
//  Created by 지정훈 on 2023/02/01.
//


import Foundation

enum UserRouter {

    case get
    case post(myFilm: String,bookmarkedMagazineID: String,email: String,myCamera: String,postedCommunityID: String,postedMagazineID: String,likedMagazineId: String,lastSearched: String,bookmarkedCommunityID: String,recentSearch: String,id: String,following: String,myLens : String,profileImage: String,name: String,follower: String,nickName: String )
    case delete
    case put
    
    private var baseURL: URL {
        let baseUrlString = "https://firestore.googleapis.com/v1/projects/grain-final/databases/(default)/documents"
    
        return URL(string: baseUrlString)!
    }
    
    private enum HTTPMethod {
            case get
            case post
            case put
            case delete
            
            var value: String {
                switch self {
                case .get: return "GET"
                case .post: return "POST"
                case .put: return "PUT"
                case .delete: return "DELETE"
                }
            }
        }
    
    private var endPoint: String {
        switch self {
        default:
            return "/User"
        }
    }
    
    private var method: HTTPMethod {
        switch self {
        case .get :
            return .get
        case .post :
            return .post
        case .delete:
            return .delete
        default:
            return .put
        }
    }
   
    private var data: Data? {
        switch self {
        case let .post(myFilm,bookmarkedMagazineID, email,myCamera, postedCommunityID,postedMagazineID: postedMagazineID,likedMagazineId,lastSearched,bookmarkedCommunityID, recentSearch, id, following,myLens,profileImage,name,follower,nickName ):
            return UserQuery.insertUserQuery(myFilm: myFilm,bookmarkedMagazineID: bookmarkedMagazineID,email: email,myCamera: myCamera,postedCommunityID: postedCommunityID,postedMagazineID: postedMagazineID,likedMagazineId: likedMagazineId,lastSearched: lastSearched,bookmarkedCommunityID: bookmarkedCommunityID,recentSearch: recentSearch,id: id,following: following,myLens :myLens,profileImage: profileImage,name: name,follower: follower,nickName: nickName )
        default:
            return nil
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(endPoint)
        
        var request = URLRequest(url: url)
        
        request.httpMethod = method.value
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        print(request)
        if let data = data {
            request.httpBody = data
        }
        
        // [x] TODO: Encoding 하는 방식으로 data 넘겨주기
//        request.httpBody = try JSONEncoding.default.encode(request, with: parameters).httpBody
        
        return request
    }
}
