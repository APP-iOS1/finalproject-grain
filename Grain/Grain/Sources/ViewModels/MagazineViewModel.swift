//
//  CommunityViewModel.swift
//  Grain
//
//  Created by 박희경 on 2023/01/20.
//

import Foundation
import Combine
import UIKit

final class MagazineViewModel: ObservableObject {
    
    var subscription = Set<AnyCancellable>()
    
    @Published var magazines = [MagazineDocument]()
    @Published var updateMagazineData : MagazineDocument?
    
    @Published var sortedRecentMagazineData = [MagazineDocument]()     // 매거진 게시물 최신순으로
    @Published var sortedTopLikedMagazineData = [MagazineDocument]()    // 매거진 게시물 좋아오 높은순
    
    @Published var recentTemp = [MagazineDocument]()
    @Published var likedTemp = [MagazineDocument]()
    
    @Published var currentTime: Date = Date()

    var fetchMagazineSuccess = PassthroughSubject<[MagazineDocument], Never>()
    var insertMagazineSuccess = PassthroughSubject<MagazineFields, Never>()
    var updateMagazineSuccess = PassthroughSubject<(), Never>()
    var deleteMagazineSuccess = PassthroughSubject<(), Never>()
    
    // MARK: 메거진 데이터 가져오기 메소드
    func fetchMagazine(nextPageToken: String) {
        
        self.currentTime = Date()
        
        MagazineService.getMagazine(nextPageToken: nextPageToken)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
                
            } receiveValue: { (data: MagazineResponse) in
                
                self.magazines.append(contentsOf: data.documents)
                
                if !(data.nextPageToken == nil) {
                    var nextPageToken : String = ""
                    nextPageToken = data.nextPageToken!
                    self.fetchMagazine(nextPageToken: nextPageToken)
                } else {
                    // MARK: 매거진 데이터 최신순 정렬 메서드 호출
                    self.sortedRecentMagazineData = self.magazines.sorted(by: {
                        return $0.createTime.toDate() ?? Date() > $1.createTime.toDate() ?? Date()
                    })
                    
                    self.sortedTopLikedMagazineData = self.magazines.sorted(by: {
                        // MARK: String -> Int로 바꾸기
                        return  Int($0.fields.likedNum.integerValue)! > Int($1.fields.likedNum.integerValue)!
                    })
                    
                    self.magazines.removeAll()
                    
                    self.fetchMagazineSuccess.send(data.documents)
                }
                
            }.store(in: &subscription)
        
    }
    
    // 차단한 User, 차단당한 User의 커뮤니티 게시물 데이터들을 필터링 해주는 메소드
    func filteringBlockUserCommunity(blockingUsers: [String], blockedUsers: [String]) {
        if blockingUsers.count > 0 {
            for id in blockingUsers {
                self.sortedRecentMagazineData.removeAll { $0.fields.userID.stringValue == id }
                self.sortedTopLikedMagazineData.removeAll { $0.fields.userID.stringValue == id }
            }
        }
        
        if blockedUsers.count > 0 {
            for id in blockedUsers {
                self.sortedRecentMagazineData.removeAll { $0.fields.userID.stringValue == id}
                self.sortedTopLikedMagazineData.removeAll { $0.fields.userID.stringValue == id}
            }
        }
        
    }
    
    // MARK: 메거진 데이터 업로드 메소드 (MagazineAddView에서 사용)
    /// 해당 메거진 게시물 Data를 MagazineFields 구조체 형식으로 넣어주고, 게시글의 이미지배열은 따로 UIImage배열로 넣어줍니다.
    /// 이렇게 호출해주면 새로운 메거진 게시물이 업로드 됩니다.
    func insertMagazine(data: MagazineFields, images: [UIImage]) {
        MagazineService.insertMagazine(data: data, images: images)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
            } receiveValue: { (receivedData: MagazineDocument) in
                self.insertMagazineSuccess.send(data)
            }.store(in: &subscription)
    }
    
    // MARK: 메거진 데이터 전체 업데이트 메소드(MagazineEditView에서 사용)
    /// 사용방법:  원래 데이터 수정해서  MagazineDocument형식으로 data 에 넣고, docID에는 메거진 id 넣어서 updateMagazine 호출.
    /// ex) 메거진 게시물 수정하기 - title, content 수정해서 update
    func updateMagazine(data: MagazineDocument, docID: String){
        MagazineService.updateMagazine(data: data, docID: docID)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
            } receiveValue: { (data: MagazineDocument) in
                self.fetchMagazine(nextPageToken: "")
                self.updateMagazineSuccess.send()
            }.store(in: &subscription)
    }
    
    // MARK: 매거진 좋아요 수 업데이트 메소드(사용자가 해당 매거진 게시글에 좋아요 눌렀을때 유저정보 수정과 동시에 이 메거진의 좋아요수도 같이 업데이트할때 사용)
    /// 사용방법:  원래 데이터 수정해서  MagazineDocument형식으로 data 에 넣고, docID에는 메거진 id 넣어서 updateMagazine 호출.
    /// ex)  원래 좋아요 수 + 1해서 num에 string 타입으로 넣어주고 , docID에는 AuthID 넣어줌.
    func updateMagazine(num: Int, docID: String){
        MagazineService.updateMagazineLikedNum(num: num, docID: docID)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
            } receiveValue: { (data: MagazineDocument) in
                
                self.updateMagazineSuccess.send()
            }.store(in: &subscription)
    }
    
    
    // MARK: 매거진 삭제 메소드(MagazineDetailView에서 게시물 삭제시 사용)
    /// 해당 메거진 게시물의 docID를 넣어주고 호출하면 그 게시물이 삭제됩니다.
    func deleteMagazine(docID: String) {
        MagazineService.deleteMagazine(docID: docID)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
            } receiveValue: { (data: MagazineDocument) in
                self.deleteMagazineSuccess.send()
            }.store(in: &subscription)
    }
    
    func filterUserMagazine(userID: String) -> [MagazineDocument] {
        let magazines = self.sortedRecentMagazineData.filter { $0.fields.userID.stringValue == userID }
        return magazines
    }
    
    func nearbyPostsFilter(magazineData: [MagazineDocument],nearbyPostsArr: [String] , blockingUsers: [String], blockedUsers: [String] ) -> [MagazineDocument] {
        // 데이터를 담아서 반환해줌! -> nearbyPostArr을 ForEach를 돌려서 뷰를 그려줄 생각
        var nearbyPostFilterArr: [MagazineDocument] = []
        var tempMagazineData = magazineData
        
        nearbyPostFilterArr.removeAll()
        
        let blockArr = (blockingUsers + blockedUsers)
        if !(blockArr.isEmpty){
            for id in blockArr {
                tempMagazineData.removeAll { $0.fields.userID.stringValue == id}
            }
        }
        /// 배열 값부터 for in문 반복한 이유로는 magazines보다 무조건 데이터가 적을 것이고 찾는 데이터가 magazines 앞쪽에 있다면 좋은 효율을 낼수 있을거 같아 이렇게 배치!
        for arrData in nearbyPostsArr{
            for magazineIdValue in tempMagazineData{
                if arrData == magazineIdValue.fields.id.stringValue{
                    nearbyPostFilterArr.append(magazineIdValue)
                    continue
                }
            }
        }
        return nearbyPostFilterArr
        
        
        
        
    }
    
    // 유저가 포스팅한 매거진 필터링
    func userPostsFilter(magazineData: [MagazineDocument], userPostedArr: [String]) -> [MagazineDocument] {
        // 데이터를 담아서 반환해줌! -> nearbyPostArr을 ForEach를 돌려서 뷰를 그려줄 생각
        var userPostFilterArr: [MagazineDocument] = []
        /// 배열 값부터 for in문 반복한 이유로는 magazines보다 무조건 데이터가 적을 것이고 찾는 데이터가 magazines 앞쪽에 있다면 좋은 효율을 낼수 있을거 같아 이렇게 배치!
        for arrData in userPostedArr{
            for magazineIdValue in magazineData{
                if arrData == magazineIdValue.fields.id.stringValue{
                    userPostFilterArr.append(magazineIdValue)
                    continue
                }
            }
        }
        return userPostFilterArr
    }
    
    func otherUserPostsFilter(magazineData: [MagazineDocument], userPostedArr: [UserStringValue]) -> [MagazineDocument] {
        // 데이터를 담아서 반환해줌! -> nearbyPostArr을 ForEach를 돌려서 뷰를 그려줄 생각
        var otherUserPostFilterArr: [MagazineDocument] = []
        /// 배열 값부터 for in문 반복한 이유로는 magazines보다 무조건 데이터가 적을 것이고 찾는 데이터가 magazines 앞쪽에 있다면 좋은 효율을 낼수 있을거 같아 이렇게 배치!
        for arrData in userPostedArr{
            for magazineIdValue in magazineData{
                if arrData.stringValue == magazineIdValue.fields.id.stringValue{
                    otherUserPostFilterArr.append(magazineIdValue)
                    continue
                }
            }
        }
       
        return otherUserPostFilterArr
    }
    
    // 유저가 저장한 매거진 필터링
    func userBookmarkedPostsFilter(magazineData: [MagazineDocument], userBookmarkedPostedArr: [String]) -> [MagazineDocument] {
        // 데이터를 담아서 반환해줌! -> nearbyPostArr을 ForEach를 돌려서 뷰를 그려줄 생각
        var userBookmarkedPostFilterArr: [MagazineDocument] = []
        /// 배열 값부터 for in문 반복한 이유로는 magazines보다 무조건 데이터가 적을 것이고 찾는 데이터가 magazines 앞쪽에 있다면 좋은 효율을 낼수 있을거 같아 이렇게 배치!
        for arrData in userBookmarkedPostedArr{
           
            for magazineIdValue in magazineData{
                if arrData == magazineIdValue.fields.id.stringValue{
                    userBookmarkedPostFilterArr.append(magazineIdValue)
                    continue
                }
            }
        }
        return userBookmarkedPostFilterArr
    }
    
}
