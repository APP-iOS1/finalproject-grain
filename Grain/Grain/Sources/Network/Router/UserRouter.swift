//
//  UserRouter.swift
//  Grain
//
//  Created by 지정훈 on 2023/02/01.
//


import Foundation

enum UserRouter {

    case get
    case post(myFilm: String, bookmarkedMagazineID: String,email: String, myCamera: String, postedCommunityID: String, postedMagazineID: String, likedMagazineId: String, lastSearched: String, bookmarkedCommunityID: String, recentSearch: String, id: String, following: String, myLens : String, profileImage: String, name: String, follower: String, nickName: String, introduce: String)
    case patchArr(type: String, arr: [String],  docID: String)
    case patchString(type: String, string: String, docID: String)
    case patchProfile(profileImage: String, nickName: String, introduce: String, docID: String)
    case delete(docID: String)
    
    private var baseURL: URL {
        let baseUrlString = Bundle.main.infoDictionary?["FireStore"] ?? ""
        return URL(string: baseUrlString as! String)!
    }

    private enum HTTPMethod {
        case get
        case post
        case patchArr
        case patchString
        case patchProfile
        case delete
        
        var value: String {
            switch self {
            case .get: return "GET"
            case .post: return "POST"
            case .patchArr: return "PATCH"
            case .patchString: return "PATCH"
            case .patchProfile: return "PATCH"
            case .delete: return "DELETE"
            }
        }
    }
    
    private var endPoint: String {
        switch self {
        case let .patchArr(_,_, docID):
            return "/User/\(docID)"
        case let .patchString(_,_, docID):
            return "/User/\(docID)"
        case let .patchProfile(_,_,_, docID):
            return "/User/\(docID)"
        case let .delete(docID: docID):
            return "/User/\(docID)"
        default:
            return "/User"
        }
    }
    
    var parameters: [URLQueryItem]? {
        switch self {
        case let .post(myFilm, bookmarkedMagazineID, email, myCamera, postedCommunityID, postedMagazineID, likedMagazineId, lastSearched, bookmarkedCommunityID, recentSearch, id, following, myLens , profileImage, name, follower, nickName, introduce):
            var params: [URLQueryItem] = [URLQueryItem(name: "documentId", value: id)]
            return params
            
        case let .patchArr(type, _, _):
            let params: [URLQueryItem] = [URLQueryItem(name: "updateMask.fieldPaths", value: type)]
            return params
        case let .patchString(type, _, _):
            let params: [URLQueryItem] = [URLQueryItem(name: "updateMask.fieldPaths", value: type)]
            return params
        case let .patchProfile(profileImage, _, _, _):
            let param1 = URLQueryItem(name: "updateMask.fieldPaths", value: "profileImage")
            let param2 = URLQueryItem(name: "updateMask.fieldPaths", value: "nickName")
            let param3 = URLQueryItem(name: "updateMask.fieldPaths", value: "introduce")
            var params: [URLQueryItem] = []
            if profileImage == "" {
                params = [param2, param3]
            } else {
                params = [param1, param2, param3]
            }
            return params
        default :
            let params: [URLQueryItem]? = nil
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
        case .patchArr:
            return .patchArr
        default:
            return .patchString
        }
    }
    
    private var data: Data? {
        switch self {
        case let .post(myFilm, bookmarkedMagazineID, email, myCamera, postedCommunityID,postedMagazineID: postedMagazineID,likedMagazineId,lastSearched,bookmarkedCommunityID, recentSearch, id, following,myLens,profileImage,name,follower,nickName, introduce):
            return UserQuery.insertUserQuery(myFilm: myFilm,bookmarkedMagazineID: bookmarkedMagazineID,email: email,myCamera: myCamera,postedCommunityID: postedCommunityID, postedMagazineID: postedMagazineID, likedMagazineId: likedMagazineId, lastSearched: lastSearched, bookmarkedCommunityID: bookmarkedCommunityID, recentSearch: recentSearch, id: id, following: following, myLens: myLens, profileImage: profileImage, name: name, follower: follower, nickName: nickName, introduce: introduce)
        case let .patchArr(type, arr, _):
            return UserQuery.updateUserArray(type: type, arr: arr)
        case let .patchString(type, string, _):
            return UserQuery.updateUserString(type: type, string: string)
        case let .patchProfile(profileImage, nickName, introduce, _):
            return UserQuery.updateUserProfile(profileImage: profileImage, nickName: nickName, introduce: introduce)
        default:
            return nil
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(endPoint)
        
        var component = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        
        if let param = parameters {
            component.queryItems = param
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
