//
//  CommunityRouter.swift
//  Grain
//
//  Created by 박희경 on 2023/01/20.
//

import Foundation

// 커뮤니티 라우터
enum CommunityRouter {
    
    case get
    case post(communityData: CommunityFields, images: [String], docID: String)
    case delete(docID : String)
    case patch(putData: CommunityDocument, docID: String)
    case patchState(state: String, docID: String)
    
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
        var communityString : String = ""
        if let infolist = Bundle.main.infoDictionary {
            if let str = infolist["UuidCommmunity"] as? String {
                communityString = str
            }
        }
        return communityString
    }
    
    
    private enum HTTPMethod {
        case get
        case post
        case patch
        case patchState
        case delete
        
        var value: String {
            switch self {
            case .get: return "GET"
            case .post: return "POST"
            case .patch: return "PATCH"
            case .patchState: return "PATCH"
            case .delete: return "DELETE"
            }
        }
    }
    
    
    
    private var endPoint: String {
        switch self {
        case let .patch(_, docID):
            return "/" + "\(queryItemString)" + "/" + "\(docID)"
        case let .patchState(_, docID):
            return "/" + "\(queryItemString)" + "/" + "\(docID)"
        case let .delete(docID):
            return "/" + "\(queryItemString)" + "/" + "\(docID)"
        default:
            return "/" + "\(queryItemString)"
        }
    }
    
    var parameters: URLQueryItem? {
        switch self {
        case let .post(_ , _ , docID):
            let params: URLQueryItem = URLQueryItem(name: "documentId", value: docID)
            return params
        case let .patchState(_, docID):
            let params: URLQueryItem = URLQueryItem(name: "updateMask.fieldPaths", value: docID)
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
        case let .post(communityData, images, docID):
            return CommunityQuery.insertCommunityQuery(data: communityData, images: images, docID: docID)
        case let .patch(putData, docID):
            return CommunityQuery.updateCommunityQuery(data: putData, docID: docID)
        case let .patchState(state, _):
            return CommunityQuery.updateCommunityStateQuery(state: state)
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
            request.httpBody = data
        }
        
        // [x] TODO: Encoding 하는 방식으로 data 넘겨주기
        //        request.httpBody = try JSONEncoding.default.encode(request, with: parameters).httpBody
        
        return request
    }
}
