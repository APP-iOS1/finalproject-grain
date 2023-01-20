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
    
    init(){
        cancellalble =
        testService
            .getMagazine()
            .receive(on: RunLoop.main)
            .catch{_ in Just(self.test)}
            .assign(to: \.test, on: self)
    }
    
    func fetchTest(){
        print("TestViewModel fetchTest Start")
        TestService().getMagazine().sink { (completion: Subscribers.Completion<Error>) in
            print("UserVM completion: (completion)")
        } receiveValue: { (test :[Magazine]) in
            self.test = test
            self.fetchTestSuccess.send()
        }.store(in: &subscription)

    }
}
