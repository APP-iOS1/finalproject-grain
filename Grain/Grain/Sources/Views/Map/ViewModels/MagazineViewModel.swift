//
//  CommunityViewModel.swift
//  Grain
//
//  Created by 박희경 on 2023/01/20.
//

import Foundation
import Combine
import FirebaseFirestore
import UIKit


final class MagazineViewModel: ObservableObject {
    
    var subscription = Set<AnyCancellable>()
    
    @Published var magazines = [MagazineDocument]()
    @Published var updateMagazineData : MagazineDocument?
    
    var fetchMagazineSuccess = PassthroughSubject<(), Never>()
    var insertMagazineSuccess = PassthroughSubject<(), Never>()
    var updateMagazineSuccess = PassthroughSubject<(), Never>()
    
    func fetchMagazine() {
        MagazineService.getMagazine()
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
                
            } receiveValue: { (data: MagazineResponse) in
                self.magazines = data.documents
                self.fetchMagazineSuccess.send()
            }.store(in: &subscription)
        
    }
    
    // MARK: upload
    func insertMagazine(data: MagazineFields, images: [UIImage]) {
        MagazineService.insertMagazine(data: data, images: images)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
                
            } receiveValue: { (data: MagazineDocument) in
                print(" gmadfsdfs: \(data)")
                self.insertMagazineSuccess.send()
                print("id: \(data.name)")
            }.store(in: &subscription)
    }
    
    // MARK: update
    func updateMagazine(data: MagazineDocument, docID: String){
        MagazineService.updateMagazine(data: data, docID: docID)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
                
            } receiveValue: { (data: MagazineDocument) in
                self.fetchMagazineSuccess.send()
            }.store(in: &subscription)
    }
    
    // MARK: delete
    func deleteMagazine(docID: String) {
        MagazineService.deleteMagazine(docID: docID)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
            } receiveValue: { (data: MagazineDocument) in
                self.fetchMagazineSuccess.send()
            }.store(in: &subscription)
    }
    
    // MARK: update -> Firebase Store SDK 사용
    func updateMagazineSDK(updateDocument: String, updateKey: String, updateValue: String, isArray: Bool) async {
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


