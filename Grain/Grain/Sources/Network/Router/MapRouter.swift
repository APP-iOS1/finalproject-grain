//
//  MapRouter.swift
//  Grain
//
//  Created by 지정훈 on 2023/02/01.
//

import Foundation


//
//  MagazineRouter.swift
//  Grain
//
//  Created by 박희경 on 2023/01/20.
//

import Foundation

enum MapRouter {

    case get
    case post(latitude: Double,url: String,id: String,category: Int,magazineId: String,longitude: Double)
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
            return "/Map"
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
        case let .post(latitude, url, id, category, magazineId, longitude):
            return MapQuery.insertMapQuery(latitude: latitude,url: url,id: id,category: category,magazineId: magazineId,longitude: longitude)
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
