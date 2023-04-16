//
//  CommunityViewModel.swift
//  Grain
//
//  Created by 박희경 on 2023/01/23.
//


import Foundation
import Combine
import UIKit

// FIXME: (희경) ViewModel 코드 구조화 할 수 있을거같음. 같은 코드 중복되는부분 나중에 리펙토링해보자.
final class CommunityViewModel: ObservableObject {
    
    var subscription = Set<AnyCancellable>()
    
    @Published var communities = [CommunityDocument]()
    @Published var sortedRecentCommunityData = [CommunityDocument]()    // 커뮤니티 게시물 최신순으로
    
    @Published var closeState = [CommunityDocument]()   // 혹시 모를 모집완료 | 판매완료 모아둘 배열
    
    @Published var fetchCommunityCellCommentCount = [String : Int]()
    
    
    var fetchCommunitySuccess = PassthroughSubject<[CommunityDocument], Never>()
    var insertCommunitySuccess = PassthroughSubject<CommunityResponse, Never>()
    var updateCommunitySuccess = PassthroughSubject<(), Never>()
    var updateCommunityStateSuccess = PassthroughSubject<(), Never>()
    var deleteCommunitySuccess = PassthroughSubject<(), Never>()
    var fetchCommunityCellCommentCountSuccess = PassthroughSubject<(), Never>()
    var fetchCommentSuccess = PassthroughSubject<(), Never>()
    
    //MARK: - 커뮤니티 데이터 가져오기 메소드
    func fetchCommunity(nextPageToken : String) {
        CommunityService.getCommunity(nextPageToken: nextPageToken)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
            } receiveValue: { [self] (data: CommunityResponse) in
                // MARK: 커뮤니티 최신순으로 정렬
                self.communities.append(contentsOf: data.documents)
                
                if !(data.nextPageToken == nil) {
                    var nextPageToken : String = ""
                    nextPageToken = data.nextPageToken!
                    self.fetchCommunity(nextPageToken: nextPageToken)
                    
                }else{
                    self.sortedRecentCommunityData = communities.sorted(by: {
                        return $0.createTime.toDate() ?? Date() > $1.createTime.toDate() ?? Date()
                    })
                    // MARK: 커뮤니티 모집완료 | 판매완료 게시글 sortedRecentCommunityData에서 배열 뒤로 배치
                    for i in self.sortedRecentCommunityData.indices{
                        if self.sortedRecentCommunityData[i].fields.state.stringValue == "모집완료" || self.sortedRecentCommunityData[i].fields.state.stringValue == "판매완료"{
                            self.sortedRecentCommunityData.append(self.sortedRecentCommunityData[i])
                            self.closeState.append(self.sortedRecentCommunityData[i])
                            self.sortedRecentCommunityData.remove(at: i)
                        }
                    }
                    
                    self.communities.removeAll()
                    
                    self.fetchCommunitySuccess.send(data.documents)
                }
                
            }.store(in: &subscription)
    }
    
    // 차단한 User, 차단당한 User의 커뮤니티 게시물 데이터들을 필터링 해주는 메소드
    func filteringBlockUserCommunity(blockingUsers: [String], blockedUsers: [String]) {
        for id in blockingUsers {
            self.sortedRecentCommunityData.removeAll { $0.fields.userID.stringValue == id }
        }
        
        for id in blockedUsers {
            self.sortedRecentCommunityData.removeAll { $0.fields.userID.stringValue == id}
        }
        
    }
    
    //MARK: - 커뮤니티 데이터 올리기 메소드(CommunityAddView에서 사용)
    /// 해당 커뮤니티 게시물 Data를 CommunityFields 구조체 형식으로 넣어주고, 게시글의 이미지배열은 따로 UIImage배열로 넣어줍니다.
    /// 이렇게 호출해주면 새로운 커뮤니티 게시글이 업로드 됩니다.
    func insertCommunity(data: CommunityFields, images: [UIImage]) {
        CommunityService.insertCommunity(data: data, images: images)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
            } receiveValue: { (data: CommunityResponse) in
                self.insertCommunitySuccess.send(data)
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
                self.fetchCommunity(nextPageToken: "")
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
    func returnCategoryCommunity(category: String, blockingUsers: [String], blockedUsers: [String]) -> [CommunityDocument] {
        var categoryData: [CommunityDocument] = []
        categoryData = sortedRecentCommunityData.filter { $0.fields.category.stringValue == "\(category)"}
        
        if blockingUsers.count > 0 {
            // 차단한 유저 필터링
            for id in blockingUsers {
                categoryData.removeAll { $0.fields.userID.stringValue == id }
            }
        }
        
        if blockedUsers.count > 0 {
            // 차단된 유저 필터링
            for id in blockedUsers {
                categoryData.removeAll { $0.fields.userID.stringValue == id}
            }
        }
        return categoryData
    }
    
    // 유저가 포스팅한 커뮤니티 필터링
    func userPostsFilter(communityData: [CommunityDocument], userPostedArr: [String]) -> [CommunityDocument] {
        // 데이터를 담아서 반환해줌! -> nearbyPostArr을 ForEach를 돌려서 뷰를 그려줄 생각
        var userPostFilterArr: [CommunityDocument] = []
        /// 배열 값부터 for in문 반복한 이유로는 magazines보다 무조건 데이터가 적을 것이고 찾는 데이터가 magazines 앞쪽에 있다면 좋은 효율을 낼수 있을거 같아 이렇게 배치!
        for arrData in userPostedArr{
            for communityIdValue in communityData{
                if arrData == communityIdValue.fields.id.stringValue{
                    userPostFilterArr.append(communityIdValue)
                    continue
                }
            }
        }
        return userPostFilterArr
    }
    
    // 유저가 저장한 커뮤니티 필터링
    func userBookmarkedCommunityFilter(communityData: [CommunityDocument], userBookmarkedCommunityArr: [String]) -> [CommunityDocument] {
        // 데이터를 담아서 반환해줌! -> nearbyPostArr을 ForEach를 돌려서 뷰를 그려줄 생각
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
    
    func fetchCommunityCellComment() {
        var communityString : String = ""
        if let infolist = Bundle.main.infoDictionary {
            if let str = infolist["UuidCommmunity"] as? String {
                communityString = str
            }
        }
        CommunityService.getCommunity(nextPageToken: "")
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
            } receiveValue: { [self] (data: CommunityResponse) in
                
                for i in data.documents{
                    CommentService.getComment(collectionName: communityString, collectionDocId: i.fields.id.stringValue, nextPageToken: "")
                        .receive(on: DispatchQueue.main)
                        .sink { (completion: Subscribers.Completion<Error>) in
                        } receiveValue: { (data: CommentResponse) in
                            self.fetchCommunityCellCommentCount.updateValue(data.documents.count, forKey: "\(i.fields.id.stringValue)")
                            self.fetchCommentSuccess.send()
                        }.store(in: &subscription)                   
                }
                
                
                self.fetchCommunityCellCommentCountSuccess.send()
                
            }.store(in: &subscription)

    }
}
