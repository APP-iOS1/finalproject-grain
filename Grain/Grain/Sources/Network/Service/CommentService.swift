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
    
    // MARK: - 댓글 데이터 가져오기
    static func getComment(collectionName: String, collectionDocId: String) -> AnyPublisher<CommentResponse, Error> {
        
        do {
            let request = try CommentRouter.get(collectionName: collectionName, collectionDocId: collectionDocId).asURLRequest()
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
    
    // MARK: - 댓글 데이터 넣기
    static func insertComment(collectionName: String, collectionDocId: String, data: CommentFields) -> AnyPublisher<CommentDocument, Error> {
       
        
        /// Comment 아래 문서 ID와 필드 안에 있는 id 값이 같아 data.id를 뽑아서 docID로 만들어줌
        let docID: String = data.id.stringValue
        
        /// post 방식으로 collectionName -  컬렉션 이름 , collectionName - 문서ID , docID- Comment 하위 문서ID , commentData 넘겨줄 데이터 구조체
        let requestRouter = CommentRouter.post(collectionName: collectionName, collectionDocId: collectionDocId, docID: docID, commentData: data)
        
        do {
            let request = try requestRouter.asURLRequest()
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
    // MARK: - 댓글 데이터 업데이트
    static func updateComment(collectionName: String,collectionDocId: String, docID: String, updateComment: String, data: CommentFields ) -> AnyPublisher<CommentDocument, Error> {
        
        
        do {
            // FIXME: - 검증 필요
            let docID: String = docID
            let request = try CommentRouter.patch(collectionName: collectionName, collectionDocId: collectionDocId, docID: docID, updateComment: updateComment, data: data ).asURLRequest()
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
    // MARK: - 댓글 데이터 삭제
    static func deleteComment(collectionName: String, collectionDocId: String, docID: String) -> AnyPublisher<CommentDocument, Error> {
        print(docID)
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
    
    
    // MARK: - 대댓글 메서드
    // MARK: 대댓글 데이터 넣기
    static func insertRecomment(collectionName: String, collectionDocId: String, commentCollectionName: String, commentCollectionDocId: String, data: CommentFields) -> AnyPublisher<CommentDocument, Error> {

        /// Comment 아래 문서 ID와 필드 안에 있는 id 값이 같아 data.id를 뽑아서 docID로 만들어줌
        let docID: String = data.id.stringValue
        
        /// post 방식으로 collectionName -  컬렉션 이름 , collectionName - 문서ID , docID- Comment 하위 문서ID , commentData 넘겨줄 데이터 구조체
        let requestRouter = CommentRouter.reCommentPost(collectionName: collectionName, collectionDocId: collectionDocId, commentCollectionName: commentCollectionName, commentCollectionDocId: commentCollectionDocId, docID: docID, commentData: data)
        
        do {
            let request = try requestRouter.asURLRequest()
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
    
    // MARK: 대댓글 데이터 가져오기
    static func getRecomment(collectionName: String, collectionDocId: String, commentCollectionName: String, commentCollectionDocId: String) -> AnyPublisher<CommentResponse, Error> {
        
        do {
            let request = try CommentRouter.reCommentGet(collectionName: collectionName, collectionDocId: collectionDocId, commentCollectionName: commentCollectionName, commentCollectionDocId: commentCollectionDocId).asURLRequest()
            print(request)
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
    // MARK: - 대댓글 데이터 업데이트
    static func updateRecomment(collectionName: String, collectionDocId: String, commentCollectionName: String, commentCollectionDocId: String, docID: String, updateComment: String, data: CommentFields ) -> AnyPublisher<CommentDocument, Error> {
        do {
            // FIXME: - 검증 필요
            let docID: String = docID
            let request = try CommentRouter.reCommentPatch(collectionName: collectionName, collectionDocId: collectionDocId, commentCollectionName: commentCollectionName, commentCollectionDocId: commentCollectionDocId, docID: docID, updateComment: updateComment, data: data).asURLRequest()
            
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
    // MARK: - 대댓글 데이터 삭제
    static func deleteRecomment(collectionName: String, collectionDocId: String, commentCollectionName: String, commentCollectionDocId: String, docID: String) -> AnyPublisher<CommentDocument, Error> {
    
        do {
            let request = try CommentRouter.reCommentDelete(collectionName: collectionName, collectionDocId: collectionDocId, commentCollectionName: commentCollectionName, commentCollectionDocId: commentCollectionDocId, docID: docID).asURLRequest()
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
