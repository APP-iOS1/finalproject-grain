//
//  UserRouter.swift
//  Grain
//
//  Created by 지정훈 on 2023/02/01.
//


import Foundation

enum UserRouter {

    case get(nextPageToken: String)
    case post(myFilm: String, bookmarkedMagazineID: String,email: String, myCamera: String, postedCommunityID: String, postedMagazineID: String, likedMagazineId: String, lastSearched: String, bookmarkedCommunityID: String, recentSearch: String, id: String, following: String, myLens : String, profileImage: String, name: String, follower: String, nickName: String, introduce: String, fcmToken : String, blocking: String, blocked: String)
    case patchArr(type: String, arr: [String],  docID: String)
    case patchString(type: String, string: String, docID: String)
    case patchProfile(profileImage: String, nickName: String, introduce: String, docID: String)
    case delete(docID: String)
    case posetDeleteUser(userDocID: String)
    case postDeclaration(id: String, category: String , reason: String , reasonDetail: String)
    
    private var baseURL: URL {
        var baseUrlString : String = "https://"
        if let infolist = Bundle.main.infoDictionary {
            if let url = infolist["FireStore"] as? String {
                baseUrlString += url
            }
        }
        return URL(string: baseUrlString) ?? URL(string: "")!
    }

    private var queryItemString: String {
        var userString : String = ""
        if let infolist = Bundle.main.infoDictionary {
            if let str = infolist["UuidUser"] as? String {
                userString = str
            }
        }
        return userString
    }
    private var queryItemDeleteString: String {
        var deleteString : String = ""
        if let infolist = Bundle.main.infoDictionary {
            if let str = infolist["UuidDeleteUser"] as? String {
                deleteString = str
            }
        }
        return deleteString
    }
    
    private enum HTTPMethod {
        case get
        case post
        case patchArr
        case patchString
        case patchProfile
        case delete
        case posetDeleteUser
        case postDeclaration
        
        var value: String {
            switch self {
            case .get: return "GET"
            case .post: return "POST"
            case .patchArr: return "PATCH"
            case .patchString: return "PATCH"
            case .patchProfile: return "PATCH"
            case .delete: return "DELETE"
            case .posetDeleteUser: return "POST"
            case .postDeclaration: return "POST"
            }
        }
    }
    
    private var endPoint: String {
        switch self {
        case let .patchArr(_,_, docID):
            return "/" + "\(queryItemString)" + "/" + "\(docID)"
        case let .patchString(_,_, docID):
            return "/" + "\(queryItemString)" + "/" + "\(docID)"
        case let .patchProfile(_,_,_, docID):
            return "/" + "\(queryItemString)" + "/" + "\(docID)"
        case let .delete(docID: docID):
            return "/" + "\(queryItemString)" + "/" + "\(docID)"
        case let .posetDeleteUser(userDocID):
            return "/" + "\(queryItemDeleteString)"
        case let .postDeclaration(_, _, _, _):
            return "/Declaration"
        default:
            return "/" + "\(queryItemString)"
        }
    }
    
    var parameters: [URLQueryItem]? {
        switch self {
        case let .get(nextPageToken):
            let params: [URLQueryItem] = [URLQueryItem(name: "pageToken", value: nextPageToken)]
            return params
        case let .post(myFilm, bookmarkedMagazineID, email, myCamera, postedCommunityID, postedMagazineID, likedMagazineId, lastSearched, bookmarkedCommunityID, recentSearch, id, following, myLens , profileImage, name, follower, nickName, introduce , fcmToken, blocking, blocked):
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
        case .posetDeleteUser :
            return .post
        case .postDeclaration:
            return .post
        default:
            return .patchString
        }
    }
    
    private var data: Data? {
        switch self {
        case let .post(myFilm, bookmarkedMagazineID, email, myCamera, postedCommunityID,postedMagazineID: postedMagazineID,likedMagazineId,lastSearched,bookmarkedCommunityID, recentSearch, id, following,myLens,profileImage,name,follower,nickName, introduce, fcmToken, blocking, blocked):
            return UserQuery.insertUserQuery(myFilm: myFilm,bookmarkedMagazineID: bookmarkedMagazineID,email: email,myCamera: myCamera,postedCommunityID: postedCommunityID, postedMagazineID: postedMagazineID, likedMagazineId: likedMagazineId, lastSearched: lastSearched, bookmarkedCommunityID: bookmarkedCommunityID, recentSearch: recentSearch, id: id, following: following, myLens: myLens, profileImage: profileImage, name: name, follower: follower, nickName: nickName, introduce: introduce, fcmToken: fcmToken, blocking: blocking, blocked: blocked)
        case let .patchArr(type, arr, _):
            return UserQuery.updateUserArray(type: type, arr: arr)
        case let .patchString(type, string, _):
            return UserQuery.updateUserString(type: type, string: string)
        case let .patchProfile(profileImage, nickName, introduce, _):
            return UserQuery.updateUserProfile(profileImage: profileImage, nickName: nickName, introduce: introduce)
        case let .posetDeleteUser(userDocID) :
            return UserQuery.insertDeleteDataCollection(userDocID: userDocID)
        case let .postDeclaration(id, category, reason, reasonDetail):
            return UserQuery.insertDeclaration(id: id, category: category, reason: reason, reasonDetail: reasonDetail)
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
