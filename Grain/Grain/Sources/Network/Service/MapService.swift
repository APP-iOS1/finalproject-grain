//
//  MapService.swift
//  Grain
//
//  Created by 지정훈 on 2023/01/31.
//

import Foundation
import Combine

enum MapService {
    
    
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
    
    static func getNextPageMap(nextPageToken: String) -> AnyPublisher<MapResponse, Error> {
        
        do {
            let request = try MapRouter.getNext(nextPageToken: nextPageToken).asURLRequest()
            
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
    static func insertMap(data: MagazineFields) -> AnyPublisher<MagazineDocument, Error> {
        
        // 문서 생성 Uid
        let requestRouter = MapRouter.post(magazineData: data, docID: data.id.stringValue)
        
        
        do {
            let request = try requestRouter.asURLRequest()
            return URLSession
                .shared
                .dataTaskPublisher(for: request)
                .map{ $0.data }
                .decode(type: MagazineDocument.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: HTTPError.requestError).eraseToAnyPublisher()
        }
    }
    
    
    static func deleteMap(docID: String) -> AnyPublisher<MapDocument, Error> {
        
        do {
            let request = try MapRouter.delete(docID: docID).asURLRequest()
            return URLSession
                .shared
                .dataTaskPublisher(for: request)
                .map{ $0.data }
                .decode(type: MapDocument.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: HTTPError.requestError).eraseToAnyPublisher()
        }
    }
}
