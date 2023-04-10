//
//  ReportMapRouter.swift
//  Grain
//
//  Created by 지정훈 on 2023/03/07.
//

import Foundation

enum ReportMapRouter {
    
    case post(reportMapData: ReportMapFields, docID: String)
    
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
            var reportString : String = ""
            if let infolist = Bundle.main.infoDictionary {
                if let str = infolist["UuidMapReport"] as? String {
                    reportString = str
                }
            }
            return reportString
        }
    
    private enum HTTPMethod {
       
        case post
       
        var value: String {
            switch self {
            case .post: return "POST"
           
            }
        }
    }
    
    private var endPoint: String {
        switch self {
        default:
            return "/" + "\(queryItemString)"
        }
    }
    
    private var method: HTTPMethod {
        switch self {
        case .post :
            return .post
        default:
            return .post
        }
    }
    
    var parameters: URLQueryItem? {
        switch self {
        case let .post(_ , docID):
            let params: URLQueryItem = URLQueryItem(name: "documentId", value: docID)
            return params
        default :
            let params: URLQueryItem? = nil
            return params
        }
    }
    
    
    private var data: Data? {
        switch self {
        case let .post(reportMapData, docID):
            return ReportMapQuery.insertReportMapQuery(data: reportMapData, docID: docID)
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
   
        return request
    }
}
