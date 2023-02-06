//
//  StorageViewModel.swift
//  Grain
//
//  Created by 지정훈 on 2023/01/31.
//

import Foundation
import Combine
import UIKit


final class StorageViewModel: ObservableObject {

    var subscription = Set<AnyCancellable>()

    @Published var storages = [StoragePath]()

    var fetchStorageSuccess = PassthroughSubject<(), Never>()
    var insertStorageSuccess = PassthroughSubject<(), Never>()

    func fetchStorageImage() {

    }
    
    func insertStorageImage(image: [UIImage]) {
        StorageService.insertStorageImage(image: image)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
            } receiveValue: { (data: StorageResponsePost) in
                self.insertStorageSuccess.send()
                print("data.downloadTokens: \(data.downloadTokens)")    //아마 지금은 안될듯 
            }.store(in: &subscription)      //메모리상에서 연결을 날려줌
    }

}
