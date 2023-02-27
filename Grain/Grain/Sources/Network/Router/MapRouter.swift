//
//  MapRouter.swift
//  Grain
//
//  Created by 박희경 on 2023/01/20.
//

import Foundation

enum MapRouter {

    case get
    case getNext(nextPageToken: String)
    case post(latitude: Double,url: String,id: String,category: Int,magazineId: String,longitude: Double)
    case delete
    case put
    
    private var baseURL: URL {
        let baseUrlString = Bundle.main.infoDictionary?["FireStore"] ?? ""
        print(baseUrlString)
        return URL(string: baseUrlString as! String)!
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
            return "/MapData"
        }
    }
    
    private var method: HTTPMethod {
        switch self {
        case .get :
            return .get
        case .getNext :     //getNext로 불러오면 get 사용
            return .get
        case .post :
            return .post
        case .delete:
            return .delete
        default:
            return .put
        }
    }
    
    var parameters: URLQueryItem? {
        switch self {
        case let .getNext(nextPageToken):
            let params: URLQueryItem = URLQueryItem(name: "pageToken", value: nextPageToken)
            return params
        default :
            let params: URLQueryItem? = nil
            return params
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
        
        if let data = data {
            request.httpBody = data
        }
        
        // [x] TODO: Encoding 하는 방식으로 data 넘겨주기
//        request.httpBody = try JSONEncoding.default.encode(request, with: parameters).httpBody
        
        return request
    }
}
