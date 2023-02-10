//
//  CommunityService.swift
//  Grain
//
//  Created by 박희경 on 2023/01/20.
//

import Foundation
import Combine
import UIKit

enum CommunityService {
    
    // MARK: - 커뮤니티 데이터 가져오기
    static func getCommunity() -> AnyPublisher<CommunityResponse, Error> {
        print("FirebaseService getCommunity start")
        
        do {
            let request = try CommunityRouter.get.asURLRequest()
            return URLSession
                .shared
                .dataTaskPublisher(for: request)
                .map{ $0.data }
                .decode(type: CommunityResponse.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: HTTPError.requestError).eraseToAnyPublisher()
        }
    }
    
    //MARK: - 커뮤니티 데이터 넣기
    static func insertCommunity(data: CommunityFields, images: [UIImage]) -> AnyPublisher<CommunityResponse, Error> {
        
        let docID: String = data.id.stringValue
        var imageUrlArr: [String] = StorageRouter.returnImageRequests(paramName: "param", fileName: "file", image: images)
        
        do {
            let requestRouter = CommunityRouter.post(communityData: data, images: imageUrlArr, docID: docID)
            let request = try requestRouter.asURLRequest()
            return URLSession
                .shared
                .dataTaskPublisher(for: request)
                .map{ $0.data }
                .decode(type: CommunityResponse.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: HTTPError.requestError).eraseToAnyPublisher()
        }
    }
    
    //MARK: - 커뮤니티 데이터 수정
    static func updateCommunity(data: CommunityDocument, docID: String) -> AnyPublisher<CommunityResponse, Error> {
        do {
            let request = try CommunityRouter.patch(putData: data, docID: docID).asURLRequest()
            print(request)
            return URLSession
                .shared
                .dataTaskPublisher(for: request)
                .map{ $0.data }
                .decode(type: CommunityResponse.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: HTTPError.requestError).eraseToAnyPublisher()
        }
    }
    
    //MARK: - 커뮤니티 데이터 삭제
    static func deleteMagazine(docID: String) -> AnyPublisher<CommunityResponse, Error> {
        do {
            let request = try MagazineRouter.delete(docID: docID).asURLRequest()
            return URLSession
                .shared
                .dataTaskPublisher(for: request)
                .map{ $0.data }
                .decode(type: CommunityResponse.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: HTTPError.requestError).eraseToAnyPublisher()
        }
    }
    
}
