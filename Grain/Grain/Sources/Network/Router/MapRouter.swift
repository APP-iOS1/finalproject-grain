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
    case post(magazineData: MagazineFields, docID: String)
    case delete
    case put
    
    private var baseURL: URL {
        var baseUrlString : String = "https://"
        if let infolist = Bundle.main.infoDictionary {
            if let url = infolist["FireStore"] as? String {
                baseUrlString += url
            }
        }
        return URL(string: baseUrlString) ?? URL(string: "")!
    }
    
    private enum HTTPMethod {
        case get
        case post
        case put
        case delete
        case getNext
        var value: String {
            switch self {
            case .get: return "GET"
            case .post: return "POST"
            case .put: return "PUT"
            case .delete: return "DELETE"
            case .getNext: return "GET"
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
        case let .post(_ , docID):
            let params: URLQueryItem = URLQueryItem(name: "documentId", value: docID)
            return params
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
        case let .post(magazineData, docID):
            guard let magazinequery = MapQuery.insertMapQuery(data: magazineData, docID: docID) else { return nil }
            print( String(decoding: magazinequery, as: UTF8.self))
            return MapQuery.insertMapQuery(data: magazineData, docID: docID)
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
