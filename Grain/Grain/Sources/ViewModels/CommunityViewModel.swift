//
//  CommunityViewModel.swift
//  Grain
//
//  Created by 박희경 on 2023/01/23.
//

// [TODO]
// 1. storage 사진 올리기
// 2. realtime database 

import Foundation
import Combine


final class CommunityViewModel: ObservableObject {
    
    var subscription = Set<AnyCancellable>()
    
    @Published var communities = [CommunityDocument]()
    
    var fetchCommunitySuccess = PassthroughSubject<[CommunityDTO], Never>()
    var insertCommunitySuccess = PassthroughSubject<(), Never>()
    
    func fetchCommunity() {
//        print("CommunityViewModel fetchCommunity Start")
        
        CommunityService.getCommunity()
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
//            print("CommunityViewModel fetchCommunity complete")
        } receiveValue: { (data: CommunityResponse) in
            self.communities = data.community
            self.fetchCommunitySuccess.send(data.community)
        }.store(in: &subscription)
        
        
    }
    
    // 카테고리별 데이터를 filtering 해서 리턴하는 함수
    func returnCategoryCommunity(category: String) -> [CommunityDTO] {
        var categoryData: [CommunityDTO] = []
        categoryData = communities.filter { $0.category == "\(category)"}
        
        print(categoryData)
        return categoryData
    }
    
    func insertCommunity(profileImage: String, nickName: String, category: String, image: String, userID: String, title: String, content: String) {
//        print("CommunityViewModel insertCommunity Start")
        
        CommunityService.insertCommunity(profileImage: profileImage, nickName: nickName, category: category, image: image, userID: userID, title: title, content: content)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
//            print("CommunityViewModel fetchCommunity complete")
        } receiveValue: { (data: CommunityResponse) in
            self.insertCommunitySuccess.send()
        }.store(in: &subscription)
    }
    
    func updateCommunity() {
        
    }
    
    func deleteCommunity() {
        
    }
    
}

