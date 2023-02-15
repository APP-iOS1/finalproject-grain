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
    var updateCommunityStateSuccess = PassthroughSubject<(), Never>()
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
    
    //MARK: - 커뮤니티 데이터 올리기 메소드(CommunityAddView에서 사용)
    /// 해당 커뮤니티 게시물 Data를 CommunityFields 구조체 형식으로 넣어주고, 게시글의 이미지배열은 따로 UIImage배열로 넣어줍니다.
    /// 이렇게 호출해주면 새로운 커뮤니티 게시글이 업로드 됩니다.
    func insertCommunity(data: CommunityFields, images: [UIImage]) {
        CommunityService.insertCommunity(data: data, images: images)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
            } receiveValue: { (data: CommunityResponse) in
                self.insertCommunitySuccess.send()
            }.store(in: &subscription)
    }
    
    // MARK: 커뮤니티 데이터 전체 업데이트 메소드(CommunityEditView에서 사용)
    /// 사용방법:  원래 데이터 수정해서  CommunityDocument형식으로 data 에 넣고, docID에는 커뮤니티 id 넣어서 updateMagazine 호출.
    /// ex) 커뮤니티 게시글 수정하기 - title, content 수정해서 update
    func updateCommunity(data: CommunityDocument, docID: String) {
        CommunityService.updateCommunity(data: data, docID: docID)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
            } receiveValue: { (data: CommunityResponse) in
                self.updateCommunitySuccess.send()
            }.store(in: &subscription)
    }
    
    // MARK: 커뮤니티 데이터 모집상태 업데이트 메소드(CommunityDetailView에서 사용)
    /// 사용방법:  모집중 -> 모집마감 이라면 state : "모집 마감" 이렇게 넣어주면 됩니다.
    /// ex) updateCommunityState(state: "모집마감", docID: 커뮤니티ID )
    func updateCommunityState(state: String, docID: String) {
        CommunityService.updateCommunityState(state: state, docID: docID)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
            } receiveValue: { (data: CommunityResponse) in
                self.updateCommunityStateSuccess.send()
            }.store(in: &subscription)
    }
    
    // MARK: 커뮤니티 삭제 메소드(CommunityDetailView에서 게시물 삭제시 사용)
    /// 해당 커뮤니티 게시물의 docID를 넣어주고 호출하면 그 게시물이 삭제됩니다.
    func deleteCommunity(docID: String) {
        CommunityService.deleteCommunity(docID: docID)
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
    
    @Published var sortedCommunityData = [CommunityDocument]()
    // MARK: - 최신순? 오래된 순? 확인해야함
    func sortByCommunity(){
        for _ in self.communities{
            var sortData = self.communities.sorted{ $0.createTime.toDate() ?? Date() > $1.createTime.toDate() ?? Date()}
            sortedCommunityData = sortData
        }
        
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
    
    // 유저가 저장한 커뮤니티 필터링
    func userBookmarkedCommunityFilter(communityData: [CommunityDocument], userBookmarkedCommunityArr: [String]) -> [CommunityDocument] {
        // 데이터를 담아서 반환해줌! -> nearbyPostArr을 ForEach를 돌려서 뷰를 그려줄 생각
        print("communityData: \(communityData)")
        var userBookmarkedCommunityFilterArr: [CommunityDocument] = []
        /// 배열 값부터 for in문 반복한 이유로는 magazines보다 무조건 데이터가 적을 것이고 찾는 데이터가 magazines 앞쪽에 있다면 좋은 효율을 낼수 있을거 같아 이렇게 배치!
    //        이거 넣었더니 터짐
        for arrData in userBookmarkedCommunityArr{
            for magazineIdValue in communityData{
                if arrData == magazineIdValue.fields.id.stringValue{
                    userBookmarkedCommunityFilterArr.append(magazineIdValue)
                    continue
                }
            }
        }
        return userBookmarkedCommunityFilterArr
    }
}
