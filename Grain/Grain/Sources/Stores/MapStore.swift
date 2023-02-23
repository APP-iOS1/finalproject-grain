//
//  MapStore.swift
//  Grain
//
//  Created by 조형구 on 2023/01/18.
//

import Foundation
import Firebase

class MapStore : ObservableObject{
    @Published var mapData : [Map] = []
    
    init(){
        mapData = []
    }
//    let firebase = Firestore.firestore()
    
    // MARK: Map 콜렉션이 있는 데이터를 전부 fetch하여 우선 Marker찍기
//    @MainActor
//    func fetchMapData() async{
//        do{
//            let documents = try await firebase.collection("Map").getDocuments()
//            self.mapData.removeAll()
//            for document in documents.documents{
//                let docData = document.data()
//                let category = docData["category"] as? Int ?? 0
//                let latitude = docData["latitude"] as? Double ?? 0.0
//                let longitude = docData["longitude"] as? Double ?? 0.0
//
//                let data = Map(latitude: latitude, longitude: longitude)
//                self.mapData.append(data)
//            }
//        }catch{
//            print(error)
//        }
//        print(self.mapData)
//    }
    /// PodFile - Firebase SDK 제거 -> 필요시 사용하기  ( 2022.02.22 / 정훈 )
//    func fetchMapData() {
//        self.mapData.removeAll()
//        firebase.collection("Map").getDocuments { snapshot, error in
//            if let snapshot{
//                for document in snapshot.documents{
//                    
//                    let docData = document.data()
//                    
//                    //TODO: 전체적으로 수정 필요
//                    var category = docData["category"] as? Int ?? 0
////                    let id    //보류
//                    var latitude = docData["latitude"] as? Double ?? 0.0
//                    var longitude = docData["longitude"] as? Double ?? 0.0
////                    var magazineId = docData["magazineId"] as? Array ?? []
//                    var url = docData["url"] as? String ?? ""
//
//                    let data = Map(category: category, latitude: latitude, longitude: longitude,url: url)
//                    self.mapData.append(data)
//
//                }
//            }
//        }
////        print(self.mapData)
//    }
    
    
}
