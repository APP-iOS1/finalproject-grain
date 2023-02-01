//
//  GeocodeAPIViewModel.swift
//  Grain
//
//  Created by 지정훈 on 2023/02/01.
//

import Foundation
import Combine


final class GeocodeAPIViewModel: ObservableObject {
    
    var subscription = Set<AnyCancellable>()
    
    @Published var addresses = [Address]()
//    @Published var insideAddresses = Address.self
    init(){
        addresses = []
    }
    var fetchGeocodeSuccess = PassthroughSubject<(), Never>()
    var insertGeocodeSuccess = PassthroughSubject<(), Never>()
    
  
    func fetchGeocode(requestAddress: String) {
        
        GeocodeService.getGeocode(requestAddress: requestAddress)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
        } receiveValue: { (data: GeocodeDTO) in
            self.addresses = data.addresses
//            for i in self.addresses{
//                let arr = Address(roadAddress: i.roadAddress, jibunAddress: i.jibunAddress, englishAddress: i.englishAddress x: i.x, y: i.y, distance: i.distance)
//                insideAddresses = arr
//            }
            self.fetchGeocodeSuccess.send()
        }.store(in: &subscription)
    }
}

