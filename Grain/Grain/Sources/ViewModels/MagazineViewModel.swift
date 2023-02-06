//
//  CommunityViewModel.swift
//  Grain
//
//  Created by 박희경 on 2023/01/20.
//

import Foundation
import Combine


final class MagazineViewModel: ObservableObject {
    
    var subscription = Set<AnyCancellable>()
    
    @Published var magazines = [MagazineDocument]()
    @Published var updateMagazineData : MagazineDocument?
    
    var fetchMagazineSuccess = PassthroughSubject<(), Never>()
    var insertMagazineSuccess = PassthroughSubject<(), Never>()
    var patchMagazineSuccess = PassthroughSubject<(), Never>()

    func fetchMagazine() {

        
        MagazineService.getMagazine()
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in

        } receiveValue: { (data: MagazineResponse) in
            self.magazines = data.documents
            self.fetchMagazineSuccess.send()
        }.store(in: &subscription)

    }
    
    func insertMagazine(userID: String, cameraInfo: String, nickName: String, image: String, content: String, title: String,lenseInfo:String,longitude: Double,likedNum: Int,filmInfo: String, customPlaceName: String,latitude: Double,comment: String,roadAddress: String ) {

        
        MagazineService.insertMagazine(userID: userID, cameraInfo: cameraInfo, nickName: nickName, image: image, content: content, title: title, lenseInfo: lenseInfo, longitude: longitude, likedNum: likedNum, filmInfo: filmInfo, customPlaceName: customPlaceName, latitude: latitude, comment: comment, roadAddress: roadAddress)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in

        } receiveValue: { (data: MagazineResponse) in
            self.insertMagazineSuccess.send()
        }.store(in: &subscription)
    }
    
//    func updateMagazine() {
//        MagazineService.patchUserMagazine(token: "bkT8aWSxt3PSJhQppATD")
//            .receive(on: DispatchQueue.main)
//            .sink { (completion: Subscribers.Completion<Error>) in
//        } receiveValue: { (data: MagazineDocument) in
//            self.updateMagazineData = data
//            self.patchMagazineSuccess.send()
//        }.store(in: &subscription)
//        
//        // 실제 업데이트 되는 부분
//        MagazineService.patchMagazine1(token: "bkT8aWSxt3PSJhQppATD", updateMagazineData: updateMagazineData!)
//            .receive(on: DispatchQueue.main)
//            .sink { (completion: Subscribers.Completion<Error>) in
//            } receiveValue: { (data: MagazineDocument) in
//                self.updateMagazineData = data
//                self.patchMagazineSuccess.send()
//            }.store(in: &subscription)
//    }
    
    func deleteMagazine() {
        
    }
    
    func nearbyPostsFilter(magazineData: [MagazineDocument],nearbyPostsArr: [String]) -> [MagazineDocument] {
        // 데이터를 담아서 반환해줌! -> nearbyPostArr을 ForEach를 돌려서 뷰를 그려줄 생각
        var nearbyPostFilterArr: [MagazineDocument] = []
        /// 배열 값부터 for in문 반복한 이유로는 magazines보다 무조건 데이터가 적을 것이고 찾는 데이터가 magazines 앞쪽에 있다면 좋은 효율을 낼수 있을거 같아 이렇게 배치!
//        이거 넣었더니 터짐
        for arrData in nearbyPostsArr{
            for magazineIdValue in magazineData{
                if arrData == magazineIdValue.fields.id.stringValue{
                    nearbyPostFilterArr.append(magazineIdValue)
                    continue
                }
            }
        }
        return nearbyPostFilterArr
    }
    
}


