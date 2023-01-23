//
//  CommunityViewModel.swift
//  Grain
//
//  Created by 박희경 on 2023/01/20.
//

import Foundation
import Combine


final class CommunityViewModel: ObservableObject {
    
    var subscription = Set<AnyCancellable>()
    
    @Published var communities = [Community]()
    
    var fetchCommunitySuccess = PassthroughSubject<(), Never>()
    var insertCommunitySuccess = PassthroughSubject<(), Never>()
    
  
    func fetchCommunity() {
        print("CommunityViewModel fetchCommunity Start")
        
        CommunityService.getCommunity()
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
            print("MagazineViewModel fetchCommunity complete")
        } receiveValue: { (data: CommunityResponse) in
            self.communities = data.communities
            self.fetchCommunitySuccess.send()
        }.store(in: &subscription)
    }
    
    func insertCommunity() {
        print("CommunityViewModel insertCommunity Start")
        
        CommunityService.insertCommunity()
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
            print("MagazineViewModel fetchCommunity complete")
        } receiveValue: { (data: CommunityResponse) in
            self.insertCommunitySuccess.send()
        }.store(in: &subscription)
    }
    
    func updateCommunity() {
        
    }
    
    func deleteCommunity() {
        
    }
    
}

