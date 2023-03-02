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
    var fetchCommentSuccess = PassthroughSubject<(), Never>()
    var insertCommentSuccess = PassthroughSubject<(), Never>()
    var updateCommentSuccess = PassthroughSubject<(), Never>()
    var deleteCommentSuccess = PassthroughSubject<(), Never>()
    var insertRecommentSuccess = PassthroughSubject<(), Never>()    // 대댓글
    var fetchRecommentSuccess = PassthroughSubject<(), Never>()
    ///  REST API 방식 CRUD
    // MARK: Read
    func fetchComment(collectionName: String, collectionDocId: String) {
        CommentService.getComment(collectionName: collectionName, collectionDocId: collectionDocId)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
                
            } receiveValue: { (data: CommentResponse) in
                self.comment = data.documents
                self.sortedRecentComment = data.documents.sorted(by: {
                    return $0.createTime.toDate() ?? Date() > $1.createTime.toDate() ?? Date()
                })
                
                self.fetchCommentSuccess.send()
            }.store(in: &subscription)
    }
    
    // MARK: Create
    func insertComment(collectionName: String, collectionDocId: String, data: CommentFields) {
        CommentService.insertComment(collectionName: collectionName, collectionDocId: collectionDocId, data: data)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
                
            } receiveValue: { (data: CommentDocument) in
                self.insertCommentSuccess.send()
                self.fetchComment(collectionName: collectionName, collectionDocId: collectionDocId)
            }.store(in: &subscription)
    }
    
    // MARK: Update
    func updateComment(collectionName: String, collectionDocId: String, docID: String, updateComment: String, data: CommentFields ){
        CommentService.updateComment(collectionName: collectionName, collectionDocId: collectionDocId, docID: docID, updateComment: updateComment, data: data)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
            } receiveValue: { (data: CommentDocument) in
                self.updateCommentSuccess.send()
                
            }.store(in: &subscription)
    }
    
    // MARK: Delete
    func deleteComment(collectionName: String, collectionDocId: String, docID: String) {
        CommentService.deleteComment(collectionName: collectionName, collectionDocId: collectionDocId, docID: docID)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
            } receiveValue: { (data: CommentDocument) in
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
    
    // MARK: Read
    func fetchRecomment(collectionName: String, collectionDocId: String, commentCollectionName: String, commentCollectionDocId: String) {
        CommentService.getRecomment(collectionName: collectionName, collectionDocId: collectionDocId, commentCollectionName: commentCollectionName, commentCollectionDocId: commentCollectionDocId)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
            } receiveValue: { (data: CommentResponse) in
                self.sortedRecentRecomment = data.documents.sorted(by: {
                    return $0.createTime.toDate() ?? Date() > $1.createTime.toDate() ?? Date()
                })
                print("대댓글")
                print(self.sortedRecentRecomment)
                self.fetchRecommentSuccess.send()
            }.store(in: &subscription)

    }
    
    /// PodFile - Firebase SDK 제거 -> 필요시 사용하기  ( 2022.02.22 / 정훈 )
    // MARK: Update -> Firebase Store SDK 사용
//    func updateUserUsingSDK(updateDocument: String, updateKey: String, updateValue: String, isArray: Bool) async {
//        let db = Firestore.firestore()
//        let documentRef = db.collection("User").document("\(updateDocument)")
//        if isArray{
//            do{
//                try? await documentRef.updateData(
//                    [
//                        "\(updateKey)": FieldValue.arrayUnion(["\(updateValue)"])
//                    ]
//                )
//            }catch let error {
//                print("Error updating document: \(error)")
//            }
//        }else{
//            do{
//                try? await documentRef.updateData(
//                    [
//                         "\(updateKey)" : "\(updateValue)"
//                    ]
//                )
//            }catch let error {
//                print("Error updating document: \(error)")
//            }
//        }
//    }
    
    // MARK: Delete -> Firebase Store SDK 사용
//    func deleteUserUsingSDK(updateDocument: String, deleteKey: String, deleteIndex: String, isArray: Bool) async {
//        let db = Firestore.firestore()
//        let documentRef = db.collection("User").document("\(updateDocument)")
//        if isArray{
//            do{
//                try? await documentRef.updateData(
//                    [
//                        "\(deleteKey)": FieldValue.arrayRemove([
//                            "\(deleteIndex)"
//                        ])
//                    ]
//                )
//            }catch let error {
//                print("Error updating document: \(error)")
//            }
//        }else{
//            do{
//                try? await documentRef.updateData(
//                    [
//                        "\(deleteKey)" : FieldValue.delete()
//                    ]
//                )
//            }catch let error {
//                print("Error updating document: \(error)")
//            }
//        }
//    }
    
}


