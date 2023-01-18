//
//  ContentViewModel.swift
//  Grain
//
//  Created by 윤소희 on 2023/01/18.
//

import Foundation
import Combine

final class ContentViewModel: ObservableObject {

    // MARK: - Properties

    @Published private(set) var stateModel: UIStateModel = UIStateModel()
    @Published private(set) var activeCard: Int = 0
    private var cancellables: [AnyCancellable] = []

    // MARK: - Lifecycle

    init() {
            self.stateModel.$activeCard.sink { completion in
                switch completion {
                case let .failure(error):
                    print("finished with error: ", error.localizedDescription)
                case .finished:
                    print("finished")
                }
            } receiveValue: { [weak self] activeCard in
                self?.someCoolMethodHere(for: activeCard)
            }.store(in: &cancellables)
        }

    // MARK: - Helpers

    private func someCoolMethodHere(for activeCard: Int) {
        print("someCoolMethodHere: index received: ", activeCard)
        self.activeCard = activeCard
    }
}
