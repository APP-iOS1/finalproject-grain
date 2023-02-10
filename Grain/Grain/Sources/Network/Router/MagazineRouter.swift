//
//  MagazineRouter.swift
//  Grain
//
//  Created by 박희경 on 2023/01/20.
//

import Foundation

enum MagazineRouter {

    case get
    case post(magazineData: MagazineFields, images: [String], docID: String)
    case delete(docID : String)
    case patch(putData: MagazineDocument, docID: String)
    case patchLikedNum(likedNum: String, docID: String)
    
    private var baseURL: URL {
        let baseUrlString = "https://firestore.googleapis.com/v1/projects/grain-final/databases/(default)/documents"
        return URL(string: baseUrlString)!
    }
    
    private enum HTTPMethod {
        case get
        case post
        case patch
        case patchLikedNum
        case delete
        
        var value: String {
            switch self {
            case .get: return "GET"
            case .post: return "POST"
            case .patch: return "PATCH"
            case .patchLikedNum: return "PATCH"
            case .delete: return "DELETE"
            }
        }
    }
    
    private var endPoint: String {
        switch self {
        case let .patch(_, docID):
            return "/Magazine/\(docID)"
        case let .patchLikedNum(_, docID):
            return "/Magazine/\(docID)"
        case let .delete(docID):
            return "/Magazine/\(docID)"
        default:
            return "/Magazine"
        }
    }
    
    var parameters: URLQueryItem? {
        switch self {
        case let .post(_ , _ , docID):
            let params: URLQueryItem = URLQueryItem(name: "documentId", value: docID)
            return params
        case let .patchLikedNum(_, docID):
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
        case let .post(magazineData, images, docID):
            guard let magazinequery = MagazineQuery.insertMagazineQuery(data: magazineData, images: images, docID: docID) else { return nil }
            print( String(decoding: magazinequery, as: UTF8.self))
            return MagazineQuery.insertMagazineQuery(data: magazineData, images: images, docID: docID)
        case let .patch(putData, docID):
            return MagazineQuery.updateMagazineQuery(data: putData, docID: docID)
        case let .patchLikedNum(likedNum, _):
            return MagazineQuery.updateLikedNumQuery(num: likedNum)
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
        
        // FIXME: Encoding 하는 방식으로 data 넘겨주기
        //        request.httpBody = try JSONEncoding.default.encode(request, with: parameters).httpBody
        return request
    }

    
}

