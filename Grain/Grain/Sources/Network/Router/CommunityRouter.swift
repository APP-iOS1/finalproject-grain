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
    case post(profileImage: String, nickName: String, category: String, image: String, userID: String, title: String, content: String)
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
            return "/Community"
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
        case let .post(profileImage, nickName, category, image, userID, title, content):
            return CommunityQuery.insertCommunityQuery(profileImage: profileImage, nickName: nickName, category: category, image: image, userID: userID, title: title, content: content)
        default:
            return nil
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(endPoint)
        
        var request = URLRequest(url: url)
        
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
