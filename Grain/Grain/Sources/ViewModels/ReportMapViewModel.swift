//
//  ReportMapViewModel.swift
//  Grain
//
//  Created by 지정훈 on 2023/03/07.
//

import Foundation
import Combine


final class ReportMapViewModel: ObservableObject {
    
    var subscription = Set<AnyCancellable>()
    
    var insertReportMapSuccess = PassthroughSubject<(), Never>()

    func insertReportMap(data: ReportMapFields) {
        ReportMapService.insertReportMap(data: data)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
            } receiveValue: { (data: ReportMapDocument) in

                self.insertReportMapSuccess.send()
                
            }.store(in: &subscription)
    }
    
}
