////
////  CommunityRouter.swift
////  Grain
////
////  Created by 박희경 on 2023/01/20.
////
//
//import Foundation
//
//
//// 커뮤니티 라우터
//enum CommunityRouter: URLRequestConvertible {
//    
//    case fetch
//    case insert(userID: String, cameraInfo: String, nickName: String, image: String, content: content, title: title)
//    case delete
//    case update
//    
//    var baseURL: URL {
//        return URL(string: ApiClient.BASE_URL)!
//    }
//    
//    var endPoint: String {
//        switch self {
//        default:
//            return "Magazine"
//        }
//    }
//    
//    var method: HTTPMethod {
//        switch self {
//        case .fetch :
//            return .get
//        case .insert :
//            return .post
//        case .delete:
//            return .delete
//        default:
//            return .fetch
//        }
//    }
//    
//    var data: Data {
//        switch self {
//        case let .insert(userID, cameraInfo, nickName, image, content, title):
//            return MagazineQuery.insertMagazineQuery(userID: userID, cameraInfo: cameraInfo, nickName: nickName, image: image, content: content, title: title)
//        default:
//            return nil
//        }
//    }
//    
//    func asURLRequest() throws -> URLRequest {
//        let baseURL = "https://firestore.googleapis.com/v1/projects/grain-final/databases/(default)/documents"
//        let url = baseURL.appendingPathComponent(endPoint)
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = method
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        if let data = data { request.httpBody = data }
//        
//        // [x] TODO: Encoding 하는 방식으로 data 넘겨주기
////        request.httpBody = try JSONEncoding.default.encode(request, with: parameters).httpBody
//        
//        return request
//    }
//}
