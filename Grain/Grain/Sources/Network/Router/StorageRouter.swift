////
////  StorageRouter.swift
////  Grain
////
////  Created by 지정훈 on 2023/01/31.
////
//
//import Foundation
//
//
//enum StorageRouter {
//
//    case get
//    case post(image: UIImage)
//    case delete
//    
//    private var baseURL: URL {
//        let baseUrlString = "https://firebasestorage.googleapis.com/v0/b/grain-final.appspot.com/o"
//        return URL(string: baseUrlString)!
//    }
//    
//    private enum HTTPMethod {
//            case get
//            case post
//            case delete
//            
//            var value: String {
//                switch self {
//                case .get: return "GET"
//                case .post: return "POST"
//                case .delete: return "DELETE"
//                }
//            }
//        }
//    private var method: HTTPMethod {
//        switch self {
//        case .get :
//            return .get
//        case .post :
//            return .post
//        default:
//            return .delete
//        }
//    }
//    private var data: Data? {
//        switch self {
//        case let .post(image):
//            return CommunityQuery.insertCommunityQuery()
//        default:
//            return nil
//        }
//    }
//
//
//    func asURLRequest() throws -> URLRequest {
//        let url = baseURL
////        let url = baseURL.appendingPathComponent(endPoint)
//        
//        var request = URLRequest(url: url)
//        
//        request.httpMethod = method.value
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        return request
//    }
//    
//    // post방식
//    func asURLRequestPost(image: UIImage) throws -> URLRequest {
//        let url = baseURL 
//
//        var request = URLRequest(url: url)
//        
//        request.httpMethod = method.value   // 메서드 정하고
//        request.addValue("image/png", forHTTPHeaderField: "Content-Type")
//        
//        return request
//    }
//    
//}
//
////enum FirebaseStorageConfiguration {
////    static let baseURL = "https://firebasestorage.googleapis.com/v0/b"
////    static let projectNamePath = "/mate-runner-e232c.appspot.com/o"
////    static let profileImageName = "profile.png"
////    static let downloadTokens = "downloadTokens"
////    static let altMediaParameter = "alt=media"
////    static let tokenParameter = "token="
////    static let mediaContentType = ["Content-Type": "image/png"]
////}
//
//
//func uploadImage(imageData: Data) {
//    let request = MultipartFormDataRequest(url: URL(string: "https://server.com/uploadPicture%22)!)
//    request.addDataField(named: "profilePicture", data: imageData, mimeType: "img/jpeg")
//    URLSession.shared.dataTask(with: request, completionHandler: {
//        ...
//    }).resume()
//}
