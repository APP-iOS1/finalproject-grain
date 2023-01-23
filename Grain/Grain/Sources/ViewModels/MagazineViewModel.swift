//
//  CommunityViewModel.swift
//  Grain
//
//  Created by 박희경 on 2023/01/20.
//

import Foundation
import Combine


final class MagazineViewModel: ObservableObject {
    
    var subscription = Set<AnyCancellable>()
    
    @Published var magazines = [Magazine]()
    
    var fetchMagazineSuccess = PassthroughSubject<(), Never>()
    var insertMagazineSuccess = PassthroughSubject<(), Never>()

    
    func fetchMagazine() {
        print("MagazineViewModel fetchCommunity Start")
        
        MagazineService.getMagazine()
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
            print("MagazineViewModel fetchCommunity complete")
        } receiveValue: { (data: MagazineResponse) in
            self.magazines = data.magazines
            self.fetchMagazineSuccess.send()
        }.store(in: &subscription)
    }
    
    func insertMagazine() {
        print("TestViewModel insertCommunity Start")
        
        MagazineService.getMagazine()
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
            print("MagazineViewModel fetchCommunity complete")
        } receiveValue: { (data: MagazineResponse) in
            self.insertMagazineSuccess.send()
        }.store(in: &subscription)
    }
    
    func updateMagazine() {
        
    }
    
    func deleteMagazine() {
        
    }
    
}

