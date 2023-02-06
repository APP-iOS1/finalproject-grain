//
//  MapViewModel.swift
//  Grain
//
//  Created by 박희경 on 2023/01/23.
//
import Foundation
import Combine


final class MapViewModel: ObservableObject {
    
    var subscription = Set<AnyCancellable>()
    
    @Published var mapData = [MapDocument]()
    
    var fetchMapSuccess = PassthroughSubject<(), Never>()
    var insertMapSuccess = PassthroughSubject<(), Never>()

    func fetchMap() {
        MapService.getMap()
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
        } receiveValue: { (data: MapResponse) in
            self.mapData = data.documents
            self.fetchMapSuccess.send()
        }.store(in: &subscription)
    }
    
//    func insertMagazine(latitude: Double,url: String,id: String,category: Int,magazineId: String,longitude: Double ) {
////        print("TestViewModel insertCommunity Start")
//
//        MapService.insertMap(latitude: latitude,url: url,id: id,category: category,magazineId: magazineId,longitude: longitude)
//            .receive(on: DispatchQueue.main)
//            .sink { (completion: Subscribers.Completion<Error>) in
////            print("MagazineViewModel fetchCommunity complete")
//        } receiveValue: { (data: MapResponse) in
//            self.insertMapSuccess.send()
//        }.store(in: &subscription)
//    }
    
    
}

