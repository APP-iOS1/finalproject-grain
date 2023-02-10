//
//  CommunityViewModel.swift
//  Grain
//
//  Created by 박희경 on 2023/01/23.
//


import Foundation
import Combine
import FirebaseFirestore

// FIXME: (희경) ViewModel 코드 구조화 할 수 있을거같음. 같은 코드 중복되는부분 나중에 리펙토링해보자.
final class CommunityViewModel: ObservableObject {
    
    var subscription = Set<AnyCancellable>()
    
    @Published var communities = [CommunityDocument]()
    
    var fetchCommunitySuccess = PassthroughSubject<[CommunityDocument], Never>()
    var insertCommunitySuccess = PassthroughSubject<(), Never>()
    var updateCommunitySuccess = PassthroughSubject<(), Never>()
    var deleteCommunitySuccess = PassthroughSubject<(), Never>()
    
    //MARK: - 커뮤니티 데이터 가져오기 메소드
    func fetchCommunity() {
        CommunityService.getCommunity()
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
            } receiveValue: { (data: CommunityResponse) in
                self.communities = data.documents
                self.fetchCommunitySuccess.send(data.documents)
            }.store(in: &subscription)
    }
    
    //MARK: - 커뮤니티 데이터 올리기 메소드
    func insertCommunity(data: CommunityFields, images: [UIImage]) {
        CommunityService.insertCommunity(data: data, images: images)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
            } receiveValue: { (data: CommunityResponse) in
                self.insertCommunitySuccess.send()
            }.store(in: &subscription)
    }
    
    //MARK: - 커뮤니티 데이터 수정 메소드
    func updateCommunity(data: CommunityDocument, docID: String) {
        CommunityService.updateCommunity(data: data, docID: docID)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
            } receiveValue: { (data: CommunityResponse) in
                self.updateCommunitySuccess.send()
            }.store(in: &subscription)
    }
    
    //MARK: - 커뮤니티 데이터 삭제 메소드
    func deleteCommunity(docID: String) {
        CommunityService.deleteMagazine(docID: docID)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
            } receiveValue: { (data: CommunityResponse) in
                self.deleteCommunitySuccess.send()
            }.store(in: &subscription)
    }
    
    // 카테고리별 데이터를 filtering 해서 리턴하는 함수
    func returnCategoryCommunity(category: String) -> [CommunityDocument] {
        var categoryData: [CommunityDocument] = []
        categoryData = communities.filter { $0.fields.category.stringValue == "\(category)"}
        
        return categoryData
    }
    
    
    // MARK: Update -> Firebase Store SDK 사용
    func updateCommunitySDK(updateDocument: String, updateKey: String, updateValue: String, isArray: Bool) async {
        
        let db = Firestore.firestore()
        let documentRef = db.collection("Community").document("\(updateDocument)")
        if isArray{
            do{
                try? await documentRef.updateData(
                    [
                        "\(updateKey)": FieldValue.arrayUnion(["\(updateValue)"])
                    ]
                )
            }catch let error {
                print("Error updating document: \(error)")
            }
        }else{
            do{
                try? await documentRef.updateData(
                    [
                        "\(updateKey)" : "\(updateValue)"
                    ]
                )
            }catch let error {
                print("Error updating document: \(error)")
            }
        }
    }
    
    // MARK: Delete -> Firebase Store SDK 사용
    func deleteCommunitySDK(updateDocument: String, deleteKey: String, deleteIndex: String, isArray: Bool) async {
        let db = Firestore.firestore()
        let documentRef = db.collection("Community").document("\(updateDocument)")
        
        if isArray{
            do{
                try? await documentRef.updateData(
                    [
                        "\(deleteKey)": FieldValue.arrayRemove([
                            "\(deleteIndex)"
                        ])
                    ]
                )
            }catch let error {
                print("Error updating document: \(error)")
            }
        }else{
            do{
                try? await documentRef.updateData(
                    [
                        "\(deleteKey)" : FieldValue.delete()
                    ]
                )
            }catch let error {
                print("Error updating document: \(error)")
            }
        }
    }
}
