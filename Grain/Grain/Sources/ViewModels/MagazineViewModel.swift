//
//  CommunityViewModel.swift
//  Grain
//
//  Created by 박희경 on 2023/01/20.
//

import Foundation
import Combine
import FirebaseFirestore

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
    
    // MARK: Update -> Firebase Store SDK 사용
    func updateMagazine(updateDocument: String, updateKey: String, updateValue: String, isArray: Bool) async {
        let db = Firestore.firestore()
        
        let documentRef = db.collection("Magazine").document("\(updateDocument)")
        
        if isArray{
            do{
                try? await documentRef.updateData(
                    [
                        "\(updateKey)": FieldValue.arrayUnion(["\(updateValue)"])
                    ]
                )
            }catch let error {
                print("Error updating document: \(error)")
            }
        }else{
            do{
                try? await documentRef.updateData(
                    [
                         "\(updateKey)" : "\(updateValue)"
                    ]
                )
            }catch let error {
                print("Error updating document: \(error)")
            }
        }
        
    }
    
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


