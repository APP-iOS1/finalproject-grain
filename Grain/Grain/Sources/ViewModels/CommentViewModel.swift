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
    
    @Published var commentTemp = [CommentDocument]()  // 대댓글 최신순으로 정렬
    @Published var recommentTemp = [CommentDocument]()  // 대댓글 최신순으로 정렬
    
    @Published var sortedRecentRecommentArray = [String : [CommentDocument]]()
    @Published var sortedRecentRecommentCount = [String : Int]()

    @Published var isDeleteReComment: Bool = false
    @Published var isDeleteReCommentAlertshown: Bool = false
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
    func fetchComment(collectionName: String, collectionDocId: String, nextPageToken: String , blockingUsers: [String], blockedUsers: [String]) {
    
        var commentString : String = ""
        if let infolist = Bundle.main.infoDictionary {
            if let str = infolist["UuidComment"] as? String {
                commentString = str
            }
        }
        
        CommentService.getComment(collectionName: collectionName, collectionDocId: collectionDocId, nextPageToken: nextPageToken)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
            } receiveValue: { (data: CommentResponse) in
                self.commentTemp.append(contentsOf: data.documents)
                
                if !(data.nextPageToken == nil) {
                    var nextPageToken : String = ""
                    nextPageToken = data.nextPageToken!
                    self.fetchComment(collectionName: collectionName, collectionDocId: collectionDocId, nextPageToken: nextPageToken, blockingUsers: blockingUsers, blockedUsers: blockedUsers )
                }else{
                    self.sortedRecentComment = self.commentTemp.sorted(by: {
                        return $0.createTime.toDate() ?? Date() < $1.createTime.toDate() ?? Date()
                    })
                    
                    let blockArr = (blockingUsers + blockedUsers)
                    if !(blockArr.isEmpty){
                        for id in blockArr {
                            self.sortedRecentComment.removeAll { $0.fields.userID.stringValue == id}
                        }
                    }
                    
                    
                    for i in self.sortedRecentComment{
                        self.fetchRecomment(collectionName: collectionName, collectionDocId: collectionDocId, commentCollectionName: commentString, commentCollectionDocId: i.fields.id.stringValue , nextPageToken: "", blockingUsers: blockingUsers, blockedUsers: blockedUsers)
                    }
                    self.commentTemp.removeAll()
                    self.fetchCommentSuccess.send()
                }
                
            }.store(in: &subscription)
    }
    
    func fetchRecomment(collectionName: String , collectionDocId: String, commentCollectionName: String, commentCollectionDocId: String , nextPageToken: String , blockingUsers: [String], blockedUsers: [String]){
        
        CommentService.getRecomment(collectionName: collectionName, collectionDocId: collectionDocId, commentCollectionName: commentCollectionName, commentCollectionDocId: commentCollectionDocId, nextPageToken: nextPageToken)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
            } receiveValue: { (data: CommentResponse) in
                
                self.recommentTemp.append(contentsOf: data.documents)
                
                if !(data.nextPageToken == nil) {
                    var nextPageToken : String = ""
                    nextPageToken = data.nextPageToken!
                    self.fetchRecomment(collectionName: collectionName, collectionDocId: collectionDocId, commentCollectionName: commentCollectionName, commentCollectionDocId: commentCollectionDocId, nextPageToken: nextPageToken, blockingUsers: blockingUsers, blockedUsers: blockedUsers)
                }else{
                    self.sortedRecentRecomment = self.recommentTemp.sorted(by: {
                        return $0.createTime.toDate() ?? Date() < $1.createTime.toDate() ?? Date()
                    })
                    
                    let blockArr = (blockingUsers + blockedUsers)
                    
                    if !(blockArr.isEmpty){
                        for id in blockArr {
                            self.sortedRecentRecomment.removeAll { $0.fields.userID.stringValue == id}
                        }
                    }

                    self.sortedRecentRecommentArray.updateValue(self.sortedRecentRecomment, forKey: "\(commentCollectionDocId)")
                    self.sortedRecentRecommentCount.updateValue(self.sortedRecentRecomment.count, forKey: "\(commentCollectionDocId)")
                    self.recommentTemp.removeAll()
                    self.fetchRecommentSuccess.send()
                }
            }.store(in: &self.subscription)
    }
    
    // MARK: Create
    func insertComment(collectionName: String, collectionDocId: String, data: CommentFields, blockingUsers: [String], blockedUsers: [String]) {
        CommentService.insertComment(collectionName: collectionName, collectionDocId: collectionDocId, data: data)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
            } receiveValue: { (data: CommentDocument) in
                self.fetchComment(collectionName: collectionName, collectionDocId: collectionDocId, nextPageToken: "" , blockingUsers: blockingUsers, blockedUsers: blockedUsers)
                self.insertCommentSuccess.send()
            }.store(in: &subscription)
        
    }
    
    // MARK: Update
    func updateComment(collectionName: String, collectionDocId: String, docID: String, updateComment: String, data: CommentFields , blockingUsers: [String], blockedUsers: [String] ){
        CommentService.updateComment(collectionName: collectionName, collectionDocId: collectionDocId, docID: docID, updateComment: updateComment, data: data)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
            } receiveValue: { (data: CommentDocument) in
                self.fetchComment(collectionName: collectionName, collectionDocId: collectionDocId, nextPageToken: "" , blockingUsers: blockingUsers, blockedUsers: blockedUsers)
                self.updateCommentSuccess.send()
            }.store(in: &subscription)
    }
    
    // MARK: Delete
    func deleteComment(collectionName: String, collectionDocId: String, docID: String , blockingUsers: [String], blockedUsers: [String]) {
        CommentService.deleteComment(collectionName: collectionName, collectionDocId: collectionDocId, docID: docID)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
            } receiveValue: { (data: CommentDocument) in
                self.fetchComment(collectionName: collectionName, collectionDocId: collectionDocId, nextPageToken: "" , blockingUsers: blockingUsers, blockedUsers: blockedUsers)
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
//    func fetchRecomment(collectionName: String, collectionDocId: String, commentCollectionName: String, commentCollectionDocId: String) {
//        CommentService.getRecomment(collectionName: collectionName, collectionDocId: collectionDocId, commentCollectionName: commentCollectionName, commentCollectionDocId: commentCollectionDocId)
//            .receive(on: DispatchQueue.main)
//            .sink { (completion: Subscribers.Completion<Error>) in
//            } receiveValue: { (data: CommentResponse) in
//                self.sortedRecentRecomment = data.documents.sorted(by: {
//                    return $0.createTime.toDate() ?? Date() < $1.createTime.toDate() ?? Date()
//                })
//                self.fetchRecommentSuccess.send()
//            }.store(in: &subscription)
//
//    }
    
    
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
    

    func filteringBlockUserComment(blockingUsers: [String], blockedUsers: [String]) {
        if blockingUsers.count > 0 {
            for id in blockingUsers {
                self.sortedRecentComment.removeAll { $0.fields.userID.stringValue == id }
            }
        }
        
        if blockedUsers.count > 0 {
            for id in blockedUsers {
                self.sortedRecentComment.removeAll { $0.fields.userID.stringValue == id}
            }
        }
        
    }
    
    
//    func filteringBlockUserRecomment( blockingUsers: [String], blockedUsers: [String]) {
//        var arr = [String: [CommentDocument]]()
//
//        if !blockingUsers.isEmpty {
//            arr = self.sortedRecentRecommentArray.filter { key, value in
//                !value.contains(where: { blockingUsers.contains($0.fields.userID.stringValue) })
//            }
//        }
//
//        if !blockedUsers.isEmpty {
//            arr = arr.filter { key, value in
//                !value.contains(where: { blockedUsers.contains($0.fields.userID.stringValue) })
//            }
//        }
//
//        self.sortedRecentRecommentArray = arr
//
//    }
}
