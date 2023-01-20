//
//  TestViewModel.swift
//  Grain
//
//  Created by 지정훈 on 2023/01/20.
//

import Foundation
import Combine

final class TestViewModel: ObservableObject{
    
    private lazy var testService = TestService()
    private var cancellalble: AnyCancellable?
    @Published var test = [Magazine]()
    var fetchTestSuccess = PassthroughSubject<(), Never>()
    var subscription = Set<AnyCancellable>()
    
    func fetchTest(){
        print("TestViewModel fetchTest Start")
        TestService().getMagazine()
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
            print("UserVM completion: (completion)")
        } receiveValue: { (test: MagazineResponse) in
            self.test = test.magazines
            self.fetchTestSuccess.send()
        }.store(in: &subscription)

    }
}
