//
//  MapService.swift
//  Grain
//
//  Created by 지정훈 on 2023/01/31.
//

import Foundation
import Combine

enum MapService {
    
    // MARK: - 스토리지 이미지 가져오기
    static func getMap() -> AnyPublisher<MapResponse, Error> {
        
        let firestoreURL = "https://firestore.googleapis.com/v1/projects/grain-final/databases/(default)/documents/Map"
        
        var request = URLRequest(url: URL(string: firestoreURL)!)
        do {
            request = try MapRouter.get.asURLRequest()
        } catch {
            // [x] error handling
            print("http error")
        }
        return URLSession
            .shared
            .dataTaskPublisher(for: request)
            .map{ $0.data}
            .decode(type: MapResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    // MARK: - 맵 데이터 넣기
    static func insertMap(latitude: Double,url: String,id: String,category: Int,magazineId: String,longitude: Double) -> AnyPublisher<MapResponse, Error> {
        print("FirebaseServic insertMagazine start")
        
        let requestRouter = MapRouter.post(latitude: latitude,url: url,id: id,category: category,magazineId: magazineId,longitude: longitude)
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
            .decode(type: MapResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
}
