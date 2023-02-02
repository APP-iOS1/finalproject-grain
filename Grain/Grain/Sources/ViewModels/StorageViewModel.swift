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

//        StorageService.getStorageImage()
//            .receive(on: DispatchQueue.main)
//            .sink { (completion: Subscribers.Completion<Error>) in
//        } receiveValue: { (data: StorageResponse) in
//            self.storages = data.items
//            self.fetchStorageSuccess.send()
//        }.store(in: &subscription)
    }

    func insertStorageImage(image: [UIImage]) {
        StorageService.insertStorageImage(image: image)
            .sink { (completion: Subscribers.Completion<Error>) in
        } receiveValue: { (data: StorageResponse) in
            self.insertStorageSuccess.send()
        }.store(in: &subscription)      //메모리상에서 연결을 날려줌
    }

}

//extension DefaultFirestoreRepository {
//    func save(profileImageData: Data, of userNickname: String) -> Observable<String> {
//        let endPoint = FirebaseStorageConfiguration.baseURL
//        + FirebaseStorageConfiguration.projectNamePath + "/\(userNickname)%2F"
//        + FirebaseStorageConfiguration.profileImageName
//        let header = FirebaseStorageConfiguration.mediaContentType
//        let tokenKey = FirebaseStorageConfiguration.downloadTokens
//
//        return self.urlSession.post(profileImageData, url: endPoint, headers: header)
//            .map({ result -> String in
//                switch result {
//                case .success(let data):
//                    guard let json = self.decode(data: data, to: [String: String].self),
//                          let token = json[tokenKey] else { throw Error.decodingError }
//                    return endPoint + "?"
//                    + [FirebaseStorageConfiguration.altMediaParameter,
//                       FirebaseStorageConfiguration.tokenParameter + token].joined(separator: "&")
//                case .failure(let error):
//                    throw error
//                }
//            })
//    }
//}
