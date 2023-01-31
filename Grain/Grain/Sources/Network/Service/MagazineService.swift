//
//  MagazineService.swift
//  Grain
//
//  Created by 박희경 on 2023/01/20.
//

import Foundation
import Combine

enum MagazineService {
    
    // MARK: - 매거진 데이터 가져오기
    static func getMagazine() -> AnyPublisher<MagazineResponse, Error> {
//        print("FirebaseServic getMagazine start")
        let firestoreURL = "https://firestore.googleapis.com/v1/projects/grain-final/databases/(default)/documents/Magazine"
        
        var request = URLRequest(url: URL(string: firestoreURL)!)
    

        do {
            request = try MagazineRouter.get.asURLRequest()
        } catch {
            // [x] error handling
            print("http error")
        }
        return URLSession
            .shared
            .dataTaskPublisher(for: request)
            .map{ $0.data}
            .decode(type: MagazineResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    // MARK: - 매거진 데이터 넣기
    static func insertMagazine(userID: String, cameraInfo: String, nickName: String, image: String, content: String, title: String,lenseInfo:String,longitude: Double,likedNum: Int,filmInfo: String, customPlaceName: String,latitude: Double,comment: String,roadAddress: String ) -> AnyPublisher<MagazineResponse, Error> {
        print("FirebaseServic insertMagazine start")
        
        let requestRouter = MagazineRouter.post(userID: userID, cameraInfo: cameraInfo, nickName: nickName, image: image, content: content, title: title, lenseInfo: lenseInfo, longitude: longitude, likedNum: likedNum, filmInfo: filmInfo, customPlaceName: customPlaceName, latitude: latitude, comment: comment, roadAddress: roadAddress)
        var request: URLRequest =  URLRequest(url: URL(string: "dfsfsdfd")!)
        
        do {
            request = try requestRouter.asURLRequest()
        } catch {
            print("http error!")
        }
        

        return URLSession
            .shared
            .dataTaskPublisher(for: request)
            .map{ $0.data }
            .decode(type: MagazineResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
}
