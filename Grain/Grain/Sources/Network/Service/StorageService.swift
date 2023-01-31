//
//  StorageService.swift
//  Grain
//
//  Created by 지정훈 on 2023/01/31.
//

import Foundation
import Combine

enum StorageService {
    
    // MARK: - 스토리지 이미지 가져오기
    static func getStorageImage() -> AnyPublisher<StorageResponse, Error> {
        
        let firebaseStorageURL = "https://firebasestorage.googleapis.com/v0/b/grain-final.appspot.com/o"
        
        var request = URLRequest(url: URL(string: firebaseStorageURL)!)
        do {
            request = try StorageRouter.get.asURLRequest()
        } catch {
            // [x] error handling
            print("http error")
        }
        return URLSession
            .shared
            .dataTaskPublisher(for: request)
            .map{ $0.data}
            .decode(type: StorageResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    // MARK: - 스토리지에 이미지 넣기
    static func insertStorageImage(){
        
    }
    
}
