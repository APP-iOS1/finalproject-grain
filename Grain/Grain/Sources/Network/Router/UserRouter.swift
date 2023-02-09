//
//  UserRouter.swift
//  Grain
//
//  Created by 지정훈 on 2023/02/01.
//


import Foundation

enum UserRouter {

    case get
    case post(myFilm: String, bookmarkedMagazineID: String,email: String, myCamera: String, postedCommunityID: String, postedMagazineID: String, likedMagazineId: String, lastSearched: String, bookmarkedCommunityID: String, recentSearch: String, id: String, following: String, myLens : String, profileImage: String, name: String, follower: String, nickName: String)
    case delete(docID: String)
    case patch(putData: CurrentUserFields, docID: String)
    
    private var baseURL: URL {
        let baseUrlString = "https://firestore.googleapis.com/v1/projects/grain-final/databases/(default)/documents"
        return URL(string: baseUrlString)!
    }

    private enum HTTPMethod {
        case get
        case post
        case patch
        case delete
        
        var value: String {
            switch self {
            case .get: return "GET"
            case .post: return "POST"
            case .patch: return "PATCH"
            case .delete: return "DELETE"
            }
        }
    }
    
    private var endPoint: String {
        switch self {
        case let .patch(_, docID):
            return "/User/\(docID)"
        case let .delete(docID: docID):
            return "/User/\(docID)"
        default:
            return "/User"
        }
    }
    
    var parameters: URLQueryItem? {
        switch self {
        case let .post(myFilm, bookmarkedMagazineID, email, myCamera, postedCommunityID, postedMagazineID, likedMagazineId, lastSearched, bookmarkedCommunityID, recentSearch, id, following, myLens , profileImage, name, follower, nickName):
            let params: URLQueryItem = URLQueryItem(name: "documentId", value: id)
            return params
        default :
            let params: URLQueryItem? = nil
            return params
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
            return .patch
        }
    }
   
    private var data: Data? {
        switch self {
        case let .post(myFilm, bookmarkedMagazineID, email, myCamera, postedCommunityID,postedMagazineID: postedMagazineID,likedMagazineId,lastSearched,bookmarkedCommunityID, recentSearch, id, following,myLens,profileImage,name,follower,nickName):
            return UserQuery.insertUserQuery(myFilm: myFilm,bookmarkedMagazineID: bookmarkedMagazineID,email: email,myCamera: myCamera,postedCommunityID: postedCommunityID, postedMagazineID: postedMagazineID, likedMagazineId: likedMagazineId, lastSearched: lastSearched, bookmarkedCommunityID: bookmarkedCommunityID, recentSearch: recentSearch, id: id, following: following, myLens: myLens, profileImage: profileImage, name: name, follower: follower, nickName: nickName)
        case let .patch(putData, docID):
            var data = UserQuery.updateUserQuery(userData: putData, docID: docID)
            print(String(decoding: data!, as: UTF8.self))
            return UserQuery.updateUserQuery(userData: putData, docID: docID)
        default:
            return nil
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(endPoint)
        
        var component = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        
        if let param = parameters {
            component.queryItems = [param]
        }
        
        var request = URLRequest(url: component.url!)
        
        request.httpMethod = method.value
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let data = data {
            print("query: \(data)")
            request.httpBody = data
        }
        
        return request
    }
    
    // 현재 로그인한 유저의 값 가져오기 위해
    func asURLRequestCurrent(request: URLRequest) throws -> URLRequest {
        var returnRequest = request
        returnRequest.httpMethod = method.value
        returnRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if let data = data {
            returnRequest.httpBody = data
        }
        return returnRequest
    }
    
}
