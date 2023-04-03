//
//  CommentViewModel.swift
//  Grain
//
//  Created by 지정훈 on 2023/02/10.
//
import Foundation
import Combine
//import FirebaseFirestore  /// PodFile - Firebase SDK 제거 -> 필요시 사용하기  ( 2022.02.22 / 정훈 )
import UIKit


final class CommentViewModel: ObservableObject {
    
    var subscription = Set<AnyCancellable>()
    
    @Published var comment = [CommentDocument]()
    @Published var sortedRecentComment = [CommentDocument]()
    @Published var sortedRecentRecomment = [CommentDocument]()  // 대댓글 최신순으로 정렬
    
    @Published var sortedRecentRecommentArray = [String : [CommentDocument]]()
    @Published var sortedRecentRecommentCount = [String : Int]()

//    @Published var hksortedRecentRecomment = [[String : CommentDocument]]()  // 희경작업
//    @Published var hksortedRecentCommentID: [String] = []  // 희경작업

    
    var fetchCommentSuccess = PassthroughSubject<(), Never>()
    var insertCommentSuccess = PassthroughSubject<(), Never>()
    var updateCommentSuccess = PassthroughSubject<(), Never>()
    var deleteCommentSuccess = PassthroughSubject<(), Never>()
    
    // 대댓글
    var insertRecommentSuccess = PassthroughSubject<(), Never>()
    var fetchRecommentSuccess = PassthroughSubject<(), Never>()
    var updateRecommentSuccess = PassthroughSubject<(), Never>()
    var deleteRecommentSuccess = PassthroughSubject<(), Never>()

    ///  REST API 방식 CRUD
    // MARK: Read
    func fetchComment(collectionName: String, collectionDocId: String) {
        CommentService.getComment(collectionName: collectionName, collectionDocId: collectionDocId)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
            } receiveValue: { (data: CommentResponse) in
                self.sortedRecentComment = data.documents.sorted(by: {
                    return $0.createTime.toDate() ?? Date() < $1.createTime.toDate() ?? Date()
                })
                for i in self.sortedRecentComment{
                    CommentService.getRecomment(collectionName: collectionName, collectionDocId: collectionDocId, commentCollectionName: "Comment", commentCollectionDocId: i.fields.id.stringValue)
                        .receive(on: DispatchQueue.main)
                        .sink { (completion: Subscribers.Completion<Error>) in
                        } receiveValue: { (data: CommentResponse) in
                            self.sortedRecentRecomment = data.documents.sorted(by: {
                                return $0.createTime.toDate() ?? Date() < $1.createTime.toDate() ?? Date()
                            })

                            self.sortedRecentRecommentArray.updateValue(self.sortedRecentRecomment, forKey: "\(i.fields.id.stringValue)")
                            self.sortedRecentRecommentCount.updateValue(self.sortedRecentRecomment.count, forKey: "\(i.fields.id.stringValue)")
                            self.fetchRecommentSuccess.send()

                        }.store(in: &self.subscription)
                }
                self.fetchCommentSuccess.send()
            }.store(in: &subscription)
    }    
    
    // MARK: 대댓글 Read    // 희경작업
//    func fetchRecommentTest(collectionName: String, collectionDocId: String, commentCollectionDocId: [String]) {
//
//        self.sortedRecentRecomment.removeAll()
//
//        for id in commentCollectionDocId {
//            CommentService.getRecomment(collectionName: collectionName, collectionDocId: collectionDocId, commentCollectionName: "Comment", commentCollectionDocId: id)
//                .receive(on: DispatchQueue.main)
//                .sink { (completion: Subscribers.Completion<Error>) in
//                } receiveValue: { (data: CommentResponse) in
//                    // 대댓글 데이터 정렬
//                    var recomments = data.documents.sorted(by: {
//                        return $0.createTime.toDate() ?? Date() < $1.createTime.toDate() ?? Date()
//                    })
//
//                    // comment id 값과 대댓글데이터를 딕셔너리로 묶어서 sortedRecentRecomment에 append
//                    // 이경우에 sortedRecentRecomment도 정렬됨.
//                    for i in recomments {
//                        self.hksortedRecentRecomment.append([id : i])
//                    }
//
//                }.store(in: &subscription)
//        }
//
//        self.fetchRecommentSuccess.send()
//    }
        
//    func filterRecomment(commentID: String) -> [CommentDocument] {     // 희경작업
//        var recomments: [CommentDocument] = []
//        for recomment in self.hksortedRecentRecomment {
//            for i in recomment {
//                if commentID == i.key {
//                    recomments.append(i.value)
//                }
//            }
//        }
//        return recomments
//    }
    
    // MARK: Create
    func insertComment(collectionName: String, collectionDocId: String, data: CommentFields) {
        CommentService.insertComment(collectionName: collectionName, collectionDocId: collectionDocId, data: data)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
            } receiveValue: { (data: CommentDocument) in
                self.fetchComment(collectionName: collectionName, collectionDocId: collectionDocId)
                self.insertCommentSuccess.send()
            }.store(in: &subscription)
        
    }
    
    // MARK: Update
    func updateComment(collectionName: String, collectionDocId: String, docID: String, updateComment: String, data: CommentFields ){
        CommentService.updateComment(collectionName: collectionName, collectionDocId: collectionDocId, docID: docID, updateComment: updateComment, data: data)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
            } receiveValue: { (data: CommentDocument) in
                self.fetchComment(collectionName: collectionName, collectionDocId: collectionDocId)
                self.updateCommentSuccess.send()
            }.store(in: &subscription)
    }
    
    // MARK: Delete
    func deleteComment(collectionName: String, collectionDocId: String, docID: String) {
        CommentService.deleteComment(collectionName: collectionName, collectionDocId: collectionDocId, docID: docID)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
            } receiveValue: { (data: CommentDocument) in
                self.fetchComment(collectionName: collectionName, collectionDocId: collectionDocId)
                self.deleteCommentSuccess.send()
            }.store(in: &subscription)
    }
    
    // MARK: 대댓글 Create
    func insertRecomment(collectionName: String, collectionDocId: String, commentCollectionName: String, commentCollectionDocId: String, data: CommentFields) {
        CommentService.insertRecomment(collectionName: collectionName, collectionDocId: collectionDocId, commentCollectionName: commentCollectionName, commentCollectionDocId: commentCollectionDocId, data: data)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
            } receiveValue: { (data: CommentDocument) in
                self.insertRecommentSuccess.send()
            }.store(in: &subscription)
    }

//    // MARK: 대댓글 Read
    func fetchRecomment(collectionName: String, collectionDocId: String, commentCollectionName: String, commentCollectionDocId: String) {
        CommentService.getRecomment(collectionName: collectionName, collectionDocId: collectionDocId, commentCollectionName: commentCollectionName, commentCollectionDocId: commentCollectionDocId)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
            } receiveValue: { (data: CommentResponse) in
                self.sortedRecentRecomment = data.documents.sorted(by: {
                    return $0.createTime.toDate() ?? Date() < $1.createTime.toDate() ?? Date()
                })
                self.fetchRecommentSuccess.send()
            }.store(in: &subscription)

    }
    
    
    /// 매거진 하나당 코맨트 여러개 -> 코멘트 여러개에서 여러개
    ///
    // MARK: 대댓글 Update
    func updateRecomment(collectionName: String, collectionDocId: String, commentCollectionName: String, commentCollectionDocId: String, docID: String, updateComment: String, data: CommentFields ){
        CommentService.updateRecomment(collectionName: collectionName, collectionDocId: collectionDocId, commentCollectionName: commentCollectionName, commentCollectionDocId: commentCollectionDocId, docID: docID, updateComment: updateComment, data: data)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
            } receiveValue: { (data: CommentDocument) in
                self.updateRecommentSuccess.send()
                
            }.store(in: &subscription)
    }
    
    // MARK: 대댓글 Delete
    func deleteRecomment(collectionName: String, collectionDocId: String, commentCollectionName: String, commentCollectionDocId: String, docID: String) {
        CommentService.deleteRecomment(collectionName: collectionName, collectionDocId: collectionDocId, commentCollectionName: commentCollectionName, commentCollectionDocId: commentCollectionDocId, docID: docID)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
            } receiveValue: { (data: CommentDocument) in
                self.deleteRecommentSuccess.send()
                
            }.store(in: &subscription)
    }
}
