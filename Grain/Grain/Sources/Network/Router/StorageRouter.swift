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
        let baseUrlString = "https://firebasestorage.googleapis.com/v0/b/grain-final.appspot.com/o/ttttt111.png"
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
    
    func uploadImage(paramName: String, fileName: String, image: [UIImage]) {
        let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/grain-final.appspot.com/o/ttee11.png")
        // 바운더리를 구분하기 위한 임의의 문자열. 각 필드는 `--바운더리`의 라인으로 구분된다.
        let boundary = UUID().uuidString
        let session = URLSession.shared
        
        // URLRequest 생성하기
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        
        // Boundary랑 Content-type 지정해주기.
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let requestBody = makebody2(boundary: boundary, paramName: "11", fileName: "22", images: image)
        
//        urlRequest.httpBody = requestBody
        // Send a POST request to the URL, with the data we created earlier
        session.uploadTask(with: urlRequest, from: requestBody, completionHandler: { responseData, response, error in
            if error == nil {
                let jsonData = try? JSONSerialization.jsonObject(with: responseData!, options: .allowFragments)
                if let json = jsonData as? [String: Any] {
                    print(json)
                }
            }
        }).resume()
    }
    
    func makebody2(boundary:String,paramName: String,fileName: String,images: [UIImage]) -> Data{
        var data = Data()
        
        for image in images {
            // --(boundary)로 시작.
            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            // 헤더 정의 - 문자열로 작성 후 UTF8로 인코딩해서 Data타입으로 변환해야 함
            data.append("Content-Disposition: form-data; name=\"\(paramName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
            // 헤더 정의 2 - 문자열로 작성 후 UTF8로 인코딩해서 Data타입으로 변환해야 함, 구분은 \r\n으로 통일.
            data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
            // 내용 붙이기
            data.append(image.pngData()!)
            
            // 모든 내용 끝나는 곳에 --(boundary)--로 표시해준다.
            data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
            print("배열 몇개고 ")
        }

        return data
    }
    //    private var data: Data? {
    //        switch self {
    //        case let .post(image):
    //            return CommunityQuery.insertCommunityQuery()
    //        default:
    //            return nil
    //        }
    //    }
    //
    func makeBody(imageArray: [UIImage]){
        print("makeBody 실행\(imageArray)")
        let boundary: String = "Boundary-\(UUID().uuidString)"
        
        let imageArray1: [UIImage] = [
            UIImage(named: "TestBlackMarker") ?? UIImage()
            
        ]
        
        
        let requestBody = multipartFormDataBody(boundary, "CodeBrah",imageArray1)
        
        let request = generateRequest(httpBody: requestBody,boundary: boundary)
        print("request:\(request)")
        URLSession.shared.dataTask(with: request) { data, resp, error in
            if let error = error {
                print(error)
                return
            }
            
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
    
    //     post방식
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
            
            if let uuid = UUID().uuidString.components(separatedBy: "-").first {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"imageUploads\"; filename=\"\(uuid).png\"\(lineBreak)")
                body.append("Content-Type: image/png\(lineBreak + lineBreak)")
                body.append(lineBreak)
            }
        }
        
        body.append("--\(boundary)--\(lineBreak)") // End multipart form and return
        
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
