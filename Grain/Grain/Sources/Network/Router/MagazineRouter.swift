//
//  MagazineRouter.swift
//  Grain
//
//  Created by 박희경 on 2023/01/20.
//

import Foundation

enum MagazineRouter {

    case get
    case post(magazineData: MagazineDocument, docID: String)
    case delete(docID : String)
    case patch(putData: MagazineDocument, docID: String)
    
    private var baseURL: URL {
        let baseUrlString = "https://firestore.googleapis.com/v1/projects/grain-final/databases/(default)/documents"
    
        return URL(string: baseUrlString)!
    }
    
    private enum HTTPMethod {
        case get
        case post
        case patch
        case delete
        
        var value: String {
            switch self {
            case .get: return "GET"
            case .post: return "POST"
            case .patch: return "PATCH"
            case .delete: return "DELETE"
            }
        }
    }
    
    // url = f'https://firestore.googleapis.com/v1/projects/{project_id}/databases/(default)/documents/{collection_name}?documentId={your_custom_doc_id}&key={web_api_key}'maga
    
    private var endPoint: String {
        switch self {
        case let .post(_, docID):
            return "/Magazine/?documentId=\(docID)"
        case let .patch(_, docID):
            return "/Magazine/\(docID)"
        case let .delete(docID):
            return "/Magazine/\(docID)"
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
            return .patch
        }
    }
   
    private var data: Data? {
        switch self {
        case let .post(magazineData, docID):
            return MagazineQuery.insertMagazineQuery(data: magazineData, docID: docID)
        case let .patch(putData, docID):
            // FIXME: 변수명 고치기
            let structData = MagazineDocument(fields: putData.fields, name: putData.name, createTime: putData.createTime, updateTime: putData.updateTime)
            return MagazineQuery.updateMagazineQuery(data: structData, docID: docID)
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
        
        // FIXME: Encoding 하는 방식으로 data 넘겨주기
        //        request.httpBody = try JSONEncoding.default.encode(request, with: parameters).httpBody
        return request
    }

    
}

