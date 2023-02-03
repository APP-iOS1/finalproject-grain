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
    
    // 실패한거 같음
//    @Published var currentUsers = CurrentUserFields
    
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
//    func fetchCurrentUser(userID: String) {
//        UserService.getCurrentUser(userID: userID)
//            .receive(on: DispatchQueue.main)
//            .sink { (completion: Subscribers.Completion<Error>) in
//        } receiveValue: { (data: CurrentUserResponse) in
//            self.currentUsers = data.fields
//            self.fetchUsersSuccess.send()
//        }.store(in: &subscription)
//
//    }
    
    func insertUser(myFilm: String,bookmarkedMagazineID: String,email: String,myCamera: String,postedCommunityID: String,postedMagazineID: String,likedMagazineId: String,lastSearched: String,bookmarkedCommunityID: String,recentSearch: String,id: String,following: String,myLens : String,profileImage: String,name: String,follower: String,nickName: String) {

        UserService.insertUser(myFilm: myFilm,bookmarkedMagazineID: bookmarkedMagazineID,email: email,myCamera: myCamera,postedCommunityID: postedCommunityID,postedMagazineID: postedMagazineID,likedMagazineId: likedMagazineId,lastSearched: lastSearched,bookmarkedCommunityID: bookmarkedCommunityID,recentSearch: recentSearch,id: id,following: following,myLens :myLens,profileImage: profileImage,name: name,follower: follower,nickName: nickName)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
//            print("MagazineViewModel fetchCommunity complete")
        } receiveValue: { (data: UserResponse) in
            self.fetchUsersSuccess.send()
        }.store(in: &subscription)
    }

    
}

