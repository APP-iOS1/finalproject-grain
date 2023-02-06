//
//  TestNaverAPIViewModel.swift
//  Grain
//
//  Created by 지정훈 on 2023/02/02.
//

import Foundation
import Combine


final class TestNaverAPIViewModel: ObservableObject {
    
    var subscription = Set<AnyCancellable>()
    
    @Published var reverseGeocodeResult = [ReverseGeocodeResult]()

    init(){
        reverseGeocodeResult = []
    }
   
    
    var fetchReverseGeocodeSuccess = PassthroughSubject<(), Never>()
    var insertReverseGeocodeSuccess = PassthroughSubject<(), Never>()
    
    func fetchReverseGeocode(latitude: Double, longitude: Double) {
        
        ReverseGeocodeService.getReverseGeocode(latitude: latitude, longitude: longitude)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
        } receiveValue: { (data: ReverseGeocodeDTO) in
            self.reverseGeocodeResult = data.results
            self.fetchReverseGeocodeSuccess.send()
        }.store(in: &subscription)

    }
}

