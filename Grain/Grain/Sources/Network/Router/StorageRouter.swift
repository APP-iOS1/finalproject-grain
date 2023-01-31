//
//  StorageRouter.swift
//  Grain
//
//  Created by 지정훈 on 2023/01/31.
//

import Foundation


enum StorageRouter {

    case get
    case post
    case delete
    case put
    
    private var baseURL: URL {
        let baseUrlString = "https://firebasestorage.googleapis.com/v0/b/grain-final.appspot.com/o"
    
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
            return "/Magazine"
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
   
    
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL
//        let url = baseURL.appendingPathComponent(endPoint)
        
        var request = URLRequest(url: url)
        
        request.httpMethod = method.value
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
    
}
