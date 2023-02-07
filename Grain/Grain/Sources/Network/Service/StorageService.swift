//
//  StorageService.swift
//  Grain
//
//  Created by 지정훈 on 2023/01/31.
//

import Foundation
import Combine
import FirebaseAuth

enum StorageService {
    
    // MARK: - 스토리지 이미지 가져오기
//    static func getStorageImage() -> AnyPublisher<StorageResponse, Error> {
//
//        let firebaseStorageURL = "https://firebasestorage.googleapis.com/v0/b/grain-final.appspot.com/o"
//
//        var request = URLRequest(url: URL(string: firebaseStorageURL)!)
//        do {
//            request = try StorageRouter.get.asURLRequest()
//        } catch {
//            // [x] error handling
//            print("http error")
//        }
//        return URLSession
//            .shared
//            .dataTaskPublisher(for: request)
//            .map{ $0.data}
//            .decode(type: StorageResponse.self, decoder: JSONDecoder())
//            .eraseToAnyPublisher()
//    }

//    // MARK: - 스토리지에 이미지 넣기
//    static func insertStorageImage(image: [UIImage]) -> AnyPublisher<StorageResponsePost, Error>{
//
//        var request = URLRequest(url: URL(string: firebaseStorageURL)!)
//
//        var returnURLRequestArr : [String] = []
//
//        do {
//            // FIXME: paramName fileName 의미 알아보기
//            returnURLRequestArr = try StorageRouter.post.uploadImage(paramName: "1", fileName: "2", image: image, url: firebaseStoragePath)
//        } catch {
//            print("http error")
//        }
//        print("request: \(returnURLRequestArr)")
//
//        return URLSession
//            .shared
//            .dataTaskPublisher(for: request)
//            .map{ $0.data}
//            .decode(type: StorageResponsePost.self, decoder: JSONDecoder())
//            .eraseToAnyPublisher()
//
//    }
//
    // MARK: - 스토리지에 이미지 넣기
//    static func testinsertStorageImage(image: [UIImage]) -> AnyPublisher<StorageResponse, Error>{
//        let firebaseStorageURL = "https://firebasestorage.googleapis.com/v0/b/grain-final.appspot.com/o/"
//
//        // MARK: 유저 고유의 폴더 경로
//        let userAuthString = Auth.auth().currentUser?.uid
//        // MARK: 업로드시 생성되는 게시글 폴더 이미지 경로
//        let folderPath = UUID().uuidString
//
////         FIXME: %2F -> /
//        let firebaseStoragePath =  firebaseStorageURL + userAuthString! + "%2F" + folderPath + "%2F"
//
//        // FIXME: 여기서 request이거는 왜 만드는지??
//        var request = URLRequest(url: URL(string: firebaseStorageURL)!)
//        do {
//            // FIXME: paramName fileName 의미 알아보기
//            var request = try StorageRouter.post.returnImageRequests(paramName: "1", fileName: "2", image: image)
//        } catch {
//            print("request error")
//        }
//
//        return URLSession
//            .shared
//            .dataTaskPublisher(for: request)
//            .map{ $0.data}
//            .decode(type: StorageResponse.self, decoder: JSONDecoder())
//            .eraseToAnyPublisher()
//    }

}

//Future
//
//let image = UIImage(named: "yourImageName")!
//let cancellable = uploadImage(image)
//    .sink(receiveCompletion: { completion in
//        switch completion {
//        case .finished:
//            break
//        case .failure(let error):
//            print("Upload failed with error: \(error)")
//        }
//    }, receiveValue: { url in
//        print("Upload successful with URL: \(url)")
//    })
