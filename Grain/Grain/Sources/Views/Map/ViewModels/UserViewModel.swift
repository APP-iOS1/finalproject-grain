//
//  UserViewModel.swift
//  Grain
//
//  Created by 박희경 on 2023/01/23.
//

import Foundation
//
//  UserViewModel.swift
//  Grain
//
//  Created by 박희경 on 2023/01/23.
//

import Foundation
import Combine


final class UserViewModel: ObservableObject {
 
    var subscription = Set<AnyCancellable>()
    
    @Published var users = [UserDocument]()
    // 현재 유저 데이터 값
    @Published var currentUsers : CurrentUserFields?

    var fetchUsersSuccess = PassthroughSubject<(), Never>()
    var insertUsersSuccess = PassthroughSubject<(), Never>()

    func fetchUser() {
        UserService.getUser()
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
        } receiveValue: { (data: UserResponse) in
            self.users = data.documents
            self.fetchUsersSuccess.send()
        }.store(in: &subscription)

    }
    // 실패한거 같음
    
    func fetchCurrentUser(userID: String) {
        UserService.getCurrentUser(userID: userID)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
        } receiveValue: { (data: CurrentUserResponse) in
            self.currentUsers = data.fields
//            print(" 확인 \(data.createTime)") -> 시간 값 나중에 써먹을수 있을듯
            self.fetchUsersSuccess.send()
        }.store(in: &subscription)
        

    }
    
    // MARK: 메서드 사용하는 쪽이 옮겨짐!  AuthenticationStore -> 최초 가입한 사용자를 DB을 만들어야 하기 때문에 저쪽에서 사용
//    func insertUser(myFilm: String,bookmarkedMagazineID: String,email: String,myCamera: String,postedCommunityID: String,postedMagazineID: String,likedMagazineId: String,lastSearched: String,bookmarkedCommunityID: String,recentSearch: String,id: String,following: String,myLens : String,profileImage: String,name: String,follower: String,nickName: String) {
//
//        UserService.insertUser(myFilm: myFilm,bookmarkedMagazineID: bookmarkedMagazineID,email: email,myCamera: myCamera,postedCommunityID: postedCommunityID,postedMagazineID: postedMagazineID,likedMagazineId: likedMagazineId,lastSearched: lastSearched,bookmarkedCommunityID: bookmarkedCommunityID,recentSearch: recentSearch,id: id,following: following,myLens :myLens,profileImage: profileImage,name: name,follower: follower,nickName: nickName)
//            .receive(on: DispatchQueue.main)
//            .sink { (completion: Subscribers.Completion<Error>) in
//        } receiveValue: { (data: UserDocument) in
//            // MARK: 최초로 유저 데이터를 만들떄 UserDefaults 값에다가 저장
//            UserDefaults.standard.set(String(data.name.suffix(20)), forKey: "docID")
//            self.userDocId = String(data.name.suffix(20))   //혹시 모르니 Published 에다가도 저장
//            self.fetchUsersSuccess.send()
//        }.store(in: &subscription)
//    }

    
}

