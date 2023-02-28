//
//  MapViewModel.swift
//  Grain
//
//  Created by 박희경 on 2023/01/23.
//
import Foundation
import Combine


final class MapViewModel: ObservableObject {
    
    var subscription = Set<AnyCancellable>()
    
    @Published var mapData = [MapDocument]()
    
    var fetchMapSuccess = PassthroughSubject<(), Never>()
    var fetchNextPageMapSuccess = PassthroughSubject<(), Never>()       // MARK: 다음 페이지 계속 돌아갈 상태값?
    var insertMapSuccess = PassthroughSubject<(), Never>()

//    func fetchMap(){
//        MapService.getMap()
//            .receive(on: DispatchQueue.main)
//            .sink { (completion: Subscribers.Completion<Error>) in
//            } receiveValue: { [self] (data: MapResponse) in
//            self.mapData.append(contentsOf: data.documents) // MARK: mapData에 들어가는 방식 바꿈
//            if !(data.nextPageToken == nil) {
//
//            }
//
//            self.fetchMapSuccess.send()
//
//        }.store(in: &subscription)
//
//    }
    
    func fetchNextPageMap(nextPageToken: String){
        print("fetchNextPageMap 호출 @@@@")
        MapService.getNextPageMap(nextPageToken: nextPageToken)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
            } receiveValue: { (data: MapResponse) in
                self.mapData.append(contentsOf: data.documents)
                print(data.documents)
                if !(data.nextPageToken == nil) {
                    var nextPageToken : String = ""
                    nextPageToken = data.nextPageToken!
                    self.fetchNextPageMap(nextPageToken: nextPageToken)
                }else{
                    self.fetchNextPageMapSuccess.send()     // 토큰이 없다면
                }
            }.store(in: &subscription)
        
    }

}

