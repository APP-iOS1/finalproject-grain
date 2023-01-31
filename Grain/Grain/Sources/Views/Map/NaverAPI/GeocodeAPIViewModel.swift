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
    
    var fetchGeocodeSuccess = PassthroughSubject<(), Never>()
    var insertGeocodeSuccess = PassthroughSubject<(), Never>()
    
  
    func fetchGeocode() {
        
        GeocodeService.getGeocode()
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
//            print("CommunityViewModel fetchCommunity complete")
        } receiveValue: { (data: GeocodeType) in
            self.addresses = data.addresses
            self.fetchGeocodeSuccess.send()
        }.store(in: &subscription)
    }
}

