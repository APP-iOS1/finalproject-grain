//
//  MagazineService.swift
//  Grain
//
//  Created by 박희경 on 2023/01/20.
//

import Foundation
import Combine
import UIKit


// TODO: 매거진 데이터 넣을때 magazineID생성해서 넣어주는 부분 코드 수정
enum MagazineService {
    
    // MARK: - 매거진 데이터 가져오기
    static func getMagazine() -> AnyPublisher<MagazineResponse, Error> {
        print("FirebaseService getMagazine start")
        
        do {
            let request = try MagazineRouter.get.asURLRequest()
            return URLSession
                .shared
                .dataTaskPublisher(for: request)
                .map{ $0.data}
                .decode(type: MagazineResponse.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: HTTPError.requestError).eraseToAnyPublisher()
        }
    }
    
    // MARK: - 매거진 데이터 넣기
    static func insertMagazine(data: MagazineFields, images: [UIImage]) -> AnyPublisher<MagazineDocument, Error> {
       
        
        let docID: String = data.id.stringValue
        var imageUrlArr: [String] = StorageRouter.returnImageRequests(paramName: "param", fileName: "file", image: images)
        
        let requestRouter = MagazineRouter.post(magazineData: data, images: imageUrlArr, docID: docID)
        
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
    
    // MARK: - 매거진 데이터 전체 업데이트
    static func updateMagazine(data: MagazineDocument, docID: String) -> AnyPublisher<MagazineDocument, Error> {
        print("FirebaseService updateMagazine start")
        
        do {
            let request = try MagazineRouter.patch(putData: data, docID: docID).asURLRequest()
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
    
    // MARK: - 매거진 좋아요 수 업데이트
    static func updateMagazineLikedNum(num: String, docID: String) -> AnyPublisher<MagazineDocument, Error> {
        do {
            let request = try MagazineRouter.patchLikedNum(likedNum: num, docID: docID).asURLRequest()
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
    
    static func deleteMagazine(docID: String) -> AnyPublisher<MagazineDocument, Error> {
        print("FirebaseService deleteMagazine start")
        
        do {
            let request = try MagazineRouter.delete(docID: docID).asURLRequest()
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
    
}
