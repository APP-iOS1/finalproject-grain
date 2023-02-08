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
        
        do {
            let request = try MapRouter.get.asURLRequest()
            return URLSession
                .shared
                .dataTaskPublisher(for: request)
                .map{ $0.data}
                .decode(type: MapResponse.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: HTTPError.requestError).eraseToAnyPublisher()
        }
    }
    
    // MARK: - 맵 데이터 넣기
    static func insertMap(latitude: Double,url: String,id: String,category: Int,magazineId: String,longitude: Double) -> AnyPublisher<MapResponse, Error> {
        
        let requestRouter = MapRouter.post(latitude: latitude,url: url,id: id,category: category,magazineId: magazineId,longitude: longitude)
        
        do {
            let request = try requestRouter.asURLRequest()
            return URLSession
                .shared
                .dataTaskPublisher(for: request)
                .map{ $0.data }
                .decode(type: MapResponse.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: HTTPError.requestError).eraseToAnyPublisher()
        }
    }
}
