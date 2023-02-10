//
//  CommentService.swift
//  Grain
//
//  Created by 지정훈 on 2023/02/10.
//
import Foundation
import Combine
import UIKit



enum CommentService {
    
    // MARK: - 매거진 데이터 가져오기
    static func getComment(collectionName: String, collectionDocId: String) -> AnyPublisher<CommentResponse, Error> {
        print("FirebaseService getComment start")
        do {
            let request = try CommentRouter.get(collectionName: collectionName, collectionDocId: collectionDocId).asURLRequest()
            print("get request: \(request)")
            return URLSession
                .shared
                .dataTaskPublisher(for: request)
                .map{ $0.data}
                .decode(type: CommentResponse.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: HTTPError.requestError).eraseToAnyPublisher()
        }
    }
    
    // MARK: - 매거진 데이터 넣기
    static func insertComment(collectionName: String, collectionDocId: String, data: CommentFields) -> AnyPublisher<CommentDocument, Error> {
        print("FirebaseService insertComment start")
        
        /// Comment 아래 문서 ID와 필드 안에 있는 id 값이 같아 data.id를 뽑아서 docID로 만들어줌
        let docID: String = data.id.stringValue
        
        /// post 방식으로 collectionName -  컬렉션 이름 , collectionName - 문서ID , docID- Comment 하위 문서ID , commentData 넘겨줄 데이터 구조체
        let requestRouter = CommentRouter.post(collectionName: collectionName, collectionDocId: collectionDocId, docID: docID, commentData: data)
        
        do {
            let request = try requestRouter.asURLRequest()
            print(request)
            return URLSession
                .shared
                .dataTaskPublisher(for: request)
                .map{ $0.data }
                .decode(type: CommentDocument.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: HTTPError.requestError).eraseToAnyPublisher()
        }
        
    }
    
    static func updateComment(collectionName: String,collectionDocId: String, docID: String, updateComment: String, data: CommentFields ) -> AnyPublisher<CommentDocument, Error> {
        print("FirebaseService updateComment start")
        
        do {
            // FIXME: - 검증 필요
            let docID: String = docID
            let request = try CommentRouter.patch(collectionName: collectionName, collectionDocId: collectionDocId, docID: docID, updateComment: updateComment, data: data ).asURLRequest()
            
            print("update request: \(request)")
            return URLSession
                .shared
                .dataTaskPublisher(for: request)
                .map{ $0.data }
                .decode(type: CommentDocument.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: HTTPError.requestError).eraseToAnyPublisher()
        }
    }
    
    static func deleteComment(collectionName: String, collectionDocId: String, docID: String) -> AnyPublisher<CommentDocument, Error> {
        
        do {
            let request = try CommentRouter.delete(collectionName: collectionName, collectionDocId: collectionDocId, docID: docID).asURLRequest()
            return URLSession
                .shared
                .dataTaskPublisher(for: request)
                .map{ $0.data }
                .decode(type: CommentDocument.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: HTTPError.requestError).eraseToAnyPublisher()
        }
    }
    
    
}
