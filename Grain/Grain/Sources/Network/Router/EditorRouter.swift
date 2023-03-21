//
//  EditorRouter.swift
//  Grain
//
//  Created by 지정훈 on 2023/03/21.
//

import Foundation

enum EditorRouter {

    case get
    private enum HTTPMethod {
            case get
        
            var value: String {
                switch self {
                case .get: return "GET"
                }
            }
        }
    
    private var baseURL: URL {
        
        var baseUrlString : String = "https://"
        if let infolist = Bundle.main.infoDictionary {
            if let url = infolist["FireStore"] as? String {
                baseUrlString += url
            }
        }
        return URL(string: baseUrlString) ?? URL(string: "")!
    }
    
    private var method: HTTPMethod {
        switch self {
        case .get :
            return .get
        default:
            return .get
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent("Editor")
        
        var component = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        
        var request = URLRequest(url: component.url!)
        
        request.httpMethod = method.value
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
   
}
