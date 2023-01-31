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
    
    @Published var magazines = [MagazineDocument]()
    
    var fetchMagazineSuccess = PassthroughSubject<(), Never>()
    var insertMagazineSuccess = PassthroughSubject<(), Never>()

    func fetchMagazine() {
//        print("MagazineViewModel fetchCommunity Start")
        
        MagazineService.getMagazine()
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
//            print("MagazineViewModel fetchCommunity complete")
        } receiveValue: { (data: MagazineResponse) in
            self.magazines = data.documents
            self.fetchMagazineSuccess.send()
        }.store(in: &subscription)

    }
    
    func insertMagazine(userID: String, cameraInfo: String, nickName: String, image: String, content: String, title: String,lenseInfo:String,longitude: Double,likedNum: Int,filmInfo: String, customPlaceName: String,latitude: Double,comment: String,roadAddress: String ) {
//        print("TestViewModel insertCommunity Start")
        
        MagazineService.insertMagazine(userID: userID, cameraInfo: cameraInfo, nickName: nickName, image: image, content: content, title: title, lenseInfo: lenseInfo, longitude: longitude, likedNum: likedNum, filmInfo: filmInfo, customPlaceName: customPlaceName, latitude: latitude, comment: comment, roadAddress: roadAddress)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
//            print("MagazineViewModel fetchCommunity complete")
        } receiveValue: { (data: MagazineResponse) in
            self.insertMagazineSuccess.send()
        }.store(in: &subscription)
    }
    
    func updateMagazine() {
        
    }
    
    func deleteMagazine() {
        
    }
    
}

