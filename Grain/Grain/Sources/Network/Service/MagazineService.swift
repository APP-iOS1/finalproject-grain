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
        print("FirebaseServic getMagazine start")
        
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
    static func insertMagazine(data: MagazineDocument) -> AnyPublisher<MagazineDocument, Error> {
        print("FirebaseServic insertMagazine start")
        
        let docID: String = data.fields.id.stringValue
        let requestRouter = MagazineRouter.post(magazineData: data, docID: docID)
        
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
    
    static func updateMagazine(data: MagazineDocument, docID: String) -> AnyPublisher<MagazineDocument, Error> {
    
        print("id: \(docID), MagazineService update method")
        
        do {
            let suffixedId: String = String(docID.suffix(20))
            let request = try MagazineRouter.patch(putData: data, docID: suffixedId).asURLRequest()
            print(request)
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
        
        do {
            let suffixedId: String = String(docID.suffix(20))
            let request = try MagazineRouter.delete(docID: suffixedId).asURLRequest()
            print(request)
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
