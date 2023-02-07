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

}

