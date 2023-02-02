//
//  StorageRouter.swift
//  Grain
//
//  Created by 지정훈 on 2023/01/31.
//

import Foundation
import UIKit


enum StorageRouter {

    case get
    case post
    case delete
    
    private var baseURL: URL {
        let baseUrlString = "https://firebasestorage.googleapis.com/v0/b/grain-final.appspot.com/o/"
        return URL(string: baseUrlString)!
    }
    
    private enum HTTPMethod {
            case get
            case post
            case delete
            
            var value: String {
                switch self {
                case .get: return "GET"
                case .post: return "POST"
                case .delete: return "DELETE"
                }
            }
        }
    private var method: HTTPMethod {
        switch self {
        case .get :
            return .get
        case .post :
            return .post
        default:
            return .delete
        }
    }
//    private var data: Data? {
//        switch self {
//        case let .post(image):
//            return CommunityQuery.insertCommunityQuery()
//        default:
//            return nil
//        }
//    }
    func makeBody(imageArray: [UIImage]){
        print("makeBody 실행\(imageArray)")
        let boundary: String = "Boundary-\(UUID().uuidString)"
        
        let imageArray1: [UIImage] = [
            UIImage(named: "kakaoLoginButtonwide")!,
            UIImage(named: "kakaoLoginLarge")!,
        ]

        
        let requestBody = multipartFormDataBody(boundary, "CodeBrah",imageArray)
        let request = generateRequest(httpBody: requestBody,boundary: boundary)
        print("request:\(request)")
        URLSession.shared.dataTask(with: request) { data, resp, error in
            if let error = error {
                print(error)
                return
            }
            print(data)
            print(resp)
            print("success")
        }.resume()
    }
    

    func asURLRequest() throws -> URLRequest {
        let url = baseURL
//        let url = baseURL.appendingPathComponent(endPoint)
        
        var request = URLRequest(url: url)
        
        request.httpMethod = method.value
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
    
    // post방식
    func generateRequest(httpBody: Data,boundary: String) -> URLRequest {
        let url = baseURL
        
        var request = URLRequest(url: url)
        
        request.httpMethod = method.value   // 메서드 정하고
        request.httpBody = httpBody
        request.setValue("multipart/form-data; boundary=" + boundary, forHTTPHeaderField: "Content-Type")
        
        return request
    }
    
    private func multipartFormDataBody(_ boundary: String, _ fromName: String, _ images: [UIImage]) -> Data {
        
        let lineBreak = "\r\n"
        var body = Data()


        
        for image in images {
            print("갯수")
            if let uuid = UUID().uuidString.components(separatedBy: "-").first {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"imageUploads\"; filename=\"\(uuid).jpg\"\(lineBreak)")
                body.append("Content-Type: image/jpg\(lineBreak + lineBreak)")
                body.append(lineBreak)
            }
        }
        
        body.append("--\(boundary)--\(lineBreak)") // End multipart form and return
        print("리턴전 \(body)")
        return body
    }
    
}
extension Data {
    
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
//enum FirebaseStorageConfiguration {
//    static let baseURL = "https://firebasestorage.googleapis.com/v0/b"
//    static let projectNamePath = "/mate-runner-e232c.appspot.com/o"
//    static let profileImageName = "profile.png"
//    static let downloadTokens = "downloadTokens"
//    static let altMediaParameter = "alt=media"
//    static let tokenParameter = "token="
//    static let mediaContentType = ["Content-Type": "image/png"]
//}

//
//func uploadImage(imageData: Data) {
//    let request = MultipartFormDataRequest(url: URL(string: "https://server.com/uploadPicture%22)!)
//    request.addDataField(named: "profilePicture", data: imageData, mimeType: "img/jpeg")
//    URLSession.shared.dataTask(with: request, completionHandler: {
//        ...
//    }).resume()
//}
