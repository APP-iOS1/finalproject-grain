//
//  GeocodeAPIViewModel.swift
//  Grain
//
//  Created by 지정훈 on 2023/02/01.
//

import Foundation
import Combine


final class NaverAPIViewModel: ObservableObject {
    
    var subscription = Set<AnyCancellable>()
    
    @Published var addresses = [Address]()
    @Published var reverseGeocodeResult = [ReverseGeocodeResult]()

    init(){
        addresses = []
        reverseGeocodeResult = []
    }
    var fetchGeocodeSuccess = PassthroughSubject<(), Never>()
    var insertGeocodeSuccess = PassthroughSubject<(), Never>()
    
    var fetchReverseGeocodeSuccess = PassthroughSubject<(), Never>()
    var insertReverseGeocodeSuccess = PassthroughSubject<(), Never>()
    
  
    func fetchGeocode(requestAddress: String) {
        
        GeocodeService.getGeocode(requestAddress: requestAddress)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
        } receiveValue: { (data: GeocodeDTO) in
            self.addresses = data.addresses
            self.fetchGeocodeSuccess.send()
        }.store(in: &subscription)
    }
    
    func fetchReverseGeocode(latitude: Double, longitude: Double) {
        
        ReverseGeocodeService.getReverseGeocode(latitude: latitude, longitude: longitude)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
        } receiveValue: { (data: ReverseGeocodeDTO) in
            self.reverseGeocodeResult = data.results
            self.fetchReverseGeocodeSuccess.send()
        }.store(in: &subscription)
        print("fetchReverseGeocode")
    }
}

