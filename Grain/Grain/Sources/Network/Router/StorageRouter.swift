//
//  StorageRouter.swift
//  Grain
//
//  Created by 지정훈 on 2023/01/31.
//

import Foundation
import FirebaseAuth
import UIKit
import Combine


enum StorageRouter {
    
    case get
    case post
    case delete
    
    static var baseURL: String {
        
        var baseUrlString : String = "https://"
        if let infolist = Bundle.main.infoDictionary {
            if let url = infolist["FireStorage"] as? String {
                baseUrlString += url
            }
        }
        
        // MARK: 유저 고유의 폴더 경로
        let userAuthString = Auth.auth().currentUser?.uid
        
        // MARK: 업로드시 생성되는 게시글 폴더 이미지 경로
        let folderPath = UUID().uuidString
        
        let firebaseStoragePath: String =  baseUrlString + userAuthString! + "%2F" + folderPath + "%2F"
        
        return firebaseStoragePath
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
    
    // FIXME: asURLRequest 이것으로 바꾸어야 하는지??
    static func returnImageRequests(paramName: String, fileName: String, image: [UIImage]) -> [String] {
        // 리턴할 이미지 경로 URL
        var imageTokenURL: [String] = []
        var imagePathArr : [String] = []
        var imageTokenArr : [String] = []
        
        // 임시로 만들어준 껍데기 URLRequest
        let firebaseStorageURL = baseURL

        let semaphore = DispatchSemaphore(value: 0) // -> 키포인트
        
        // MARK: 들어온 이미지 수 만큼 for in 문
        for i in image {
            // MARK: 넘어온 폴더 경로에 UUID 생성하여 업로드 되는 파일 이미지 중복 되지 않게 이벤트 발생시 생성
            let url = firebaseStorageURL + UUID().uuidString
            
            // 바운더리를 구분하기 위한 임의의 문자열. 각 필드는 `--바운더리`의 라인으로 구분된다.
            let boundary = UUID().uuidString
            let session = URLSession.shared
            
            // URLRequest 생성하기
            var urlRequest = URLRequest(url: URL(string: url)!)
            urlRequest.httpMethod = "POST"
            
            // Boundary랑 Content-type 지정해주기.
            urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            var data = Data()
            
            // --(boundary)로 시작.
            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            // 헤더 정의 - 문자열로 작성 후 UTF8로 인코딩해서 Data타입으로 변환해야 함
            data.append("Content-Disposition: form-data; name=\"\(paramName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
            // 헤더 정의 2 - 문자열로 작성 후 UTF8로 인코딩해서 Data타입으로 변환해야 함, 구분은 \r\n으로 통일.
            data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            // 내용 붙이기
            // MARK: 용량적고 소중한 우리의 Storage 저장소 지키기 위해 JPEG로 변환
            data.append(i.jpegData(compressionQuality: 0.9) ?? Data())
            
            // 모든 내용 끝나는 곳에 --(boundary)--로 표시해준다.
            data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
            
            // MARK: 진짜 만들어준 urlRequest를 넘겨줄 returnURLRequest에 넣어줌
            // MARK: 실제 이미지가 들어가도록 해주는 작업 부분
            let task = session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
                if error == nil {
                    let decoder = JSONDecoder()
                    let jsonData = try? decoder.decode(StorageResponsePost.self, from: responseData!)
                    let str = jsonData?.name ?? ""
                    let changeStr = str.replacingOccurrences(of: "/", with: "%2F") // 경로값 / 를 -> %2F로 바꾸어야 함
                    imagePathArr.append(changeStr)
                    imageTokenArr.append(jsonData?.downloadTokens ?? "")
                   
                }
                semaphore.signal() // -> 키포인트
            })
            task.resume()
            semaphore.wait()    // -> 키포인트
        }
        // MARK: 배열 갯수 만큼 반복 돌림
        // FIXME: 이미지 2개 넣으면 버그가 있음 imageTokenURL이 세개 나옴 ( 1, 1, 2 ) / 1개 이미지 넣으면 쿼리문에서 터짐 ...
        for index in 0..<imagePathArr.count{
            var makeURL = "https://firebasestorage.googleapis.com/v0/b/grain-final.appspot.com/o/" + imagePathArr[index] + "?alt=media&token=" +  imageTokenArr[index]
            imageTokenURL.append(makeURL)
        }
        return imageTokenURL
    }
}

// FIXME: 이것이 무엇인지 공부하기
extension Data {
    
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}

//var imagePathURL = "https://firebasestorage.googleapis.com/v0/b/grain-final.appspo%2F" + jsonData?.name ?? "" + "?alt=media&token=" + jsonData?.downloadTokens ?? ""
