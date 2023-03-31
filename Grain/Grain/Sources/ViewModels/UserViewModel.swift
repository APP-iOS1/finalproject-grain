//
//  UserViewModel.swift
//  Grain
//
//  Created by 박희경 on 2023/01/23.
//


import Foundation
import Combine
import UIKit
import FirebaseAuth

final class UserViewModel: ObservableObject {
    var subscription = Set<AnyCancellable>()
    
    @Published var users = [UserDocument]()
    // 현재 유저 데이터 값
    @Published var currentUsers : CurrentUserFields?
    @Published var user: CurrentUserFields?
    
    // 유저 데이터 string 배열 타입 값
    @Published var likedMagazineID : [String] = []
    @Published var myLens : [String] = []
    @Published var myFilm : [String] = []
    @Published var myCamera : [String] = []
    @Published var postedCommunityID : [String] = []
    @Published var postedMagazineID : [String] = []
    @Published var bookmarkedMagazineID : [String] = []
    @Published var bookmarkedCommunityID : [String] = []
    @Published var follower : [String] = []
    @Published var following : [String] = []
    @Published var recentSearch: [String] = []
    
    // 내가 구독한 사람의 게시글만 담은 배열
    @Published var subscribedMagazines: [String] = []
    
    // 유저가 저장한 커뮤니티
    @Published var userBookmarkedCommunity : [String] = [] //string값만
    @Published var likedCommunityIdArr : [String] = [] // -> DB에서 만들어야됨
    
    // 유저의 팔로워, 팔로잉 리스트
    @Published var followerList = [UserDocument]()
    @Published var followingList = [UserDocument]()
    
    var fetchUsersSuccess = PassthroughSubject<[UserDocument], Never>()
    var fetchCurrentUsersSuccess = PassthroughSubject<CurrentUserFields, Never>()
    var insertUsersSuccess = PassthroughSubject<(), Never>()
    var updateUsersArraySuccess = PassthroughSubject<(), Never>()
    var updateUsersStringSuccess = PassthroughSubject<(), Never>()
    var updateUsersProfileSuccess = PassthroughSubject<(), Never>()
    var deleteUsersSuccess = PassthroughSubject<(), Never>()
    var getMagazineCommentsSuccess = PassthroughSubject<[[String]], Never>()
    var getMagazineReCommentsSuccess = PassthroughSubject<[[String]], Never>()
    
    
    func fetchUser() {
        UserService.getUser()
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
            } receiveValue: { (data: UserResponse) in
                self.users = data.documents
                self.fetchUsersSuccess.send(data.documents)
            }.store(in: &subscription)
    }
    
    func fetchCurrentUser(userID: String) {
        UserService.getCurrentUser(userID: userID)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
            } receiveValue: { (data: CurrentUserResponse) in
                self.currentUsers = data.fields
                if let currentUsers = self.currentUsers {
                    self.parsingUserDataToStringArr(currentUserData: currentUsers)
                    self.fetchCurrentUsersSuccess.send(data.fields)
                }
            }.store(in: &subscription)
    }
    
    func filterCurrentUsersFollow() {
        self.followerList = users.filter {
            follower.contains($0.fields.id.stringValue)
        }
        
        self.followingList = users.filter {
            following.contains($0.fields.id.stringValue)
        }
        
    }
    
    func filterUserFollow(user: UserDocument) -> [UserDocument] {
        var followerID: [String] = []
        
        for i in user.fields.follower.arrayValue.values {
            followerID.append(i.stringValue)
        }
        
        let follower = users.filter {
            followerID.contains($0.fields.id.stringValue)
        }
        
        return follower
    }
    
    func filterUserFollowing(user: UserDocument) -> [UserDocument] {
        var followingID: [String] = []
        
        for i in user.fields.following.arrayValue.values {
            followingID.append(i.stringValue)
        }
        
        let following = users.filter {
            followingID.contains($0.fields.id.stringValue)
        }
        
        return following
    }
    
    
    //MARK: - 구독한 사람들의 메거진만 필터링해서 리턴해주는 메서드(홈뷰 구독탭에서 가져다 쓰시면 됩니다. ^^ 갖다쓰기만해 ~ )
    /// 홈뷰에서 fetch 한 모든 게시물 데이터 MagazineVM.magazines 넘겨서 호출해주면 됩니다.
    /// 그러면 알아서 구독한 사람들의 게시물만 던져줍니다.
    /// 주의사항: 구독기능은 로그인을 해야만 가능하고, 현재 fetchCurrentUser가 호출이 되어있는 상태여야지만 가능합니다.
    func returnSubscribedMagazines(magazines: [MagazineDocument]) -> [MagazineDocument]{
        var subscribedMagazines: [MagazineDocument] = []
        /// 모든 메거진 중에서 나의 팔로잉 리스트에 있는 유저가 쓴 메거진인지 판단하고
        /// 맞다면 팔로잉한 유저의 메거진 리스트들을 subscribedMagazines 에 append 한다.
        for i in magazines {
            if following.contains( i.fields.userID.stringValue ) {
                subscribedMagazines.append(i)
            }
        }
        return subscribedMagazines
    }
    
    /// 좋아요를 누른 메거진인지 Bool 값으로 리턴해주는 메소드
    func isLikedMagazine(magazine: MagazineDocument) -> Bool {
        if likedMagazineID.contains(magazine.fields.id.stringValue) {
            return true
        } else {
            return false
        }
    }
    
    /// 저장을 누른 메거진인지 Bool 값으로 리턴해주는 메소드
    func isBookMarkedMagazine(magazine: MagazineDocument) -> Bool {
        if bookmarkedMagazineID.contains(magazine.fields.id.stringValue) {
            return true
        } else {
            return false
        }
    }
    
    // MARK: - 유저 프로필 업데이트 메소드 (nickName, introduce, profileImage 업데이트할때 ProfileEditView에서 사용)
    /// ex) profileImage :프로필 UIImage를 UIImage 타입 그대로 배열에 넣어서 넘겨줍니다, 또 nickName, introduce, docID는 그대로 String 타입으로 넘겨주면 자동으로 update 될겁니다.
    func updateCurrentUserProfile(profileImage: [UIImage], nickName: String, introduce: String, docID: String) {
        UserService.updateCurrentUserProfile(profileImage: profileImage, nickName: nickName, introduce: introduce, docID: docID)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
            } receiveValue: { (data: UserDocument) in
                self.updateUsersProfileSuccess.send()
            }.store(in: &subscription)
    }
    
    // MARK: - 유저정보 업데이트 메소드 (string 배열 타입값 업데이트할때 사용 )
    /// 좋아요누른 게시글 , 저장한 게시글, 저장한 커뮤니티글, 내 장비정보(카메라, 렌즈, 필름), 내가 올린 메거진, 커뮤니티 게시글 , 팔로워, 팔로잉 업데이트 할때 사용하면 됩니다.
    /// ex) type: likedMagazineId , string: ["1234", "45346346", "56456456"], docID: 현재로그인한유저아이디 -> 유저가 좋아요누른 메거진 아이디 리스트 배열을 ["1234", "45346346", "56456456"] 로 바꾸겠다. !!!
    func updateCurrentUserArray(type: String, arr: [String], docID: String){
        UserService.updateCurrentUserArray(type: type, arr: arr, docID: docID)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
            } receiveValue: { (data: UserDocument) in
                self.fetchCurrentUser(userID: Auth.auth().currentUser?.uid ?? "")
                self.fetchUser()
                self.updateUsersArraySuccess.send()
            }.store(in: &subscription)
    }
    
    
    // MARK: - 유저정보 업데이트 메소드 (string 타입값 업데이트할때 사용)
    /// 이 메소드는 지금 필요할지 모르겠지만 일단 만듬.
    /// ex) type: id , string: "1234", docID: 현재로그인한유저아이디 -> 유저의  id 를 1234로 바꾸겠댜!!!
    func updateCurrentUserString(type: String, string: String, docID: String) {
        UserService.updateCurrentUserString(type: type, string: string, docID: docID)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
            } receiveValue: { (data: UserDocument) in
                self.updateUsersStringSuccess.send()
            }.store(in: &subscription)
    }
    
    
    // MARK: - 유저정보 삭제 메소드 (유저 탈퇴시 사용)
    func deleteUser(docID: String) {
        UserService.deleteUser(docID: docID)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
            } receiveValue: { (data: UserDocument) in
//                self.deleteUserMagazine(magazines: self.postedMagazineID)
//                self.deleteUserCommunity(communities: self.postedCommunityID)
                self.deleteUsersSuccess.send()
            }.store(in: &subscription)
    }
    
    //     MARK: - 유저정보 삭제 메소드 (유저 탈퇴시 유저가 작성한 메거진 게시글 모두 삭제)
    func deleteUserMagazine(magazines: [String]) {
        for i in magazines {
            MagazineService.deleteMagazine(docID: i)
                .receive(on: DispatchQueue.main)
                .sink { (completion: Subscribers.Completion<Error>) in
                } receiveValue: { (data: MagazineDocument) in
                    
                }.store(in: &subscription)
        }
    }
    
    //     MARK: - 유저정보 삭제 메소드 (유저 탈퇴시 유저가 작성한 커뮤니티 게시글 모두 삭제)
    func deleteUserCommunity(communities: [String]) {
        for i in communities {
            CommunityService.deleteCommunity(docID: i)
                .receive(on: DispatchQueue.main)
                .sink { (completion: Subscribers.Completion<Error>) in
                } receiveValue: { (data: CommunityResponse) in
                    
                }.store(in: &subscription)
        }
    }
    
    // 메거진컬렉션에 있는 모든 댓글 id 저장
    //Magazine/1234/Comment/1234 - > delete
    func getMagazineComments(magazines: [String]) {
        var magazineComments = [[String]]()
        for id in magazines {
            CommentService.getComment(collectionName: "Magazine", collectionDocId: id)
                .receive(on: DispatchQueue.main)
                .sink { (completion: Subscribers.Completion<Error>) in
                } receiveValue: { (data: CommentResponse) in
                    // 메거진 하나당 달린 댓글들 id를 배열에 저장
                    var arr: [String]
                    for i in data.documents {
                        // [magzineID, commentID]
//                        arr.append([id, i.fields.id.stringValue])
                    }
                }.store(in: &subscription)
        }
        
        self.getMagazineCommentsSuccess.send(magazineComments)
    }
    
    // Magazine/123/Comment/1234/Recomment/12344 -> delete
    
    // 메거진컬렉션에 있는 모든 대댓글 id 저장
    func getMagazineRecomment(comments: [[String]]) {
        // [magzineID, commentID]
        var magzineRecomment = [[String]]()
        
        for id in comments {
            CommentService.getRecomment(collectionName: "Magazine", collectionDocId: id[0], commentCollectionName: "Comment", commentCollectionDocId: id[1])
                .receive(on: DispatchQueue.main)
                .sink { (completion: Subscribers.Completion<Error>) in
                } receiveValue: { (data: CommentResponse) in
                    // 메거진 하나당 달린 댓글들 id를 배열에 저장
                    for i in data.documents {
                        // [magzineID, commentID, recommentID]
                        magzineRecomment.append([id[0], id[1], i.fields.id.stringValue])
                    }
                }.store(in: &subscription)
        }
        
        self.getMagazineReCommentsSuccess.send(magzineRecomment)
    }
    
    
    
    func removeAll() {
        self.likedMagazineID.removeAll()
        self.myLens.removeAll()
        self.myFilm.removeAll()
        self.myCamera.removeAll()
        self.postedCommunityID.removeAll()
        self.postedMagazineID.removeAll()
        self.bookmarkedMagazineID.removeAll()
        self.bookmarkedCommunityID.removeAll()
        self.follower.removeAll()
        self.following.removeAll()
        self.recentSearch.removeAll()
    }
    
    func parsingUserDataToStringArr(currentUserData: CurrentUserFields) {
        
        removeAll()
        
        for i in currentUserData.likedMagazineID.arrayValue.values {
            self.likedMagazineID.append(i.stringValue)
        }
        for i in currentUserData.myLens.arrayValue.values {
            self.myLens.append(i.stringValue)
        }
        for i in currentUserData.myFilm.arrayValue.values {
            self.myFilm.append(i.stringValue)
        }
        for i in currentUserData.myCamera.arrayValue.values {
            self.myCamera.append(i.stringValue)
        }
        for i in currentUserData.postedCommunityID.arrayValue.values {
            self.postedCommunityID.append(i.stringValue)
        }
        for i in currentUserData.postedMagazineID.arrayValue.values {
            self.postedMagazineID.append(i.stringValue)
        }
        for i in currentUserData.bookmarkedMagazineID.arrayValue.values {
            self.bookmarkedMagazineID.append(i.stringValue)
        }
        for i in currentUserData.bookmarkedCommunityID.arrayValue.values {
            self.bookmarkedCommunityID.append(i.stringValue)
        }
        for i in currentUserData.follower.arrayValue.values {
            self.follower.append(i.stringValue)
        }
        for i in currentUserData.following.arrayValue.values {
            self.following.append(i.stringValue)
        }
        for i in currentUserData.recentSearch.arrayValue.values {
            self.recentSearch.append(i.stringValue)
        }
    }
    
    func parsingFollowerDataToStringArr(data: UserDocument) -> [String] {
        var follower = [String]()
        for i in data.fields.follower.arrayValue.values {
            follower.append(i.stringValue)
        }
        
        return follower
    }
    
    func insertUser(myFilm: String,bookmarkedMagazineID: String,email: String,myCamera: String,postedCommunityID: String,postedMagazineID: String,likedMagazineId: String,lastSearched: String,bookmarkedCommunityID: String,recentSearch: String,id: String,following: String,myLens : String,profileImage: [UIImage],name: String,follower: String,nickName: String, introduce: String, fcmToken: String) {
        UserService.insertUser(myFilm: myFilm,bookmarkedMagazineID: bookmarkedMagazineID,email: email,myCamera: myCamera,postedCommunityID: postedCommunityID,postedMagazineID: postedMagazineID,likedMagazineId: likedMagazineId,lastSearched: lastSearched,bookmarkedCommunityID: bookmarkedCommunityID,recentSearch: recentSearch,id: id,following: following,myLens :myLens,profileImage: profileImage,name: name,follower: follower,nickName: nickName, introduce: introduce, fcmToken: fcmToken)
        
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
            } receiveValue: { (data: UserDocument) in
                self.insertUsersSuccess.send()
            }.store(in: &subscription)
    }
    
    // 매거진 피드뷰 구독자 필터링
    func subscriptionFeed(magazineData : [MagazineDocument]) -> [MagazineDocument]{
        var subscriptionFeedData : [MagazineDocument] = []
        for i in self.followerList{
            for j in magazineData{
                if i.fields.id.stringValue == j.fields.userID.stringValue{  // i.fields.id.stringValue  팔로워 id 뽑기,j.fields.userID.stringValue 매거진 안에 userID 뽑아서 둘이 같으면 데이터 넣기
                    subscriptionFeedData.append(j)
                }
            }
        }
        return subscriptionFeedData
    }
    
}
