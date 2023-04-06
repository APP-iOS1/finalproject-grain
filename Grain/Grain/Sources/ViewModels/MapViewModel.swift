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
    var deleteMapSuccess = PassthroughSubject<(), Never>()
    var fetchNextPageMapSuccess = PassthroughSubject<(), Never>()       // MARK: 다음 페이지 계속 돌아갈 상태값?
    
    var insertMapSuccess = PassthroughSubject<MagazineFields, Never>()

    func fetchNextPageMap(nextPageToken: String){
        MapService.getNextPageMap(nextPageToken: nextPageToken)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
            } receiveValue: { (data: MapResponse) in
                self.mapData.append(contentsOf: data.documents)
                if !(data.nextPageToken == nil) {
                    var nextPageToken : String = ""
                    nextPageToken = data.nextPageToken!
                    self.fetchNextPageMap(nextPageToken: nextPageToken)
                }else{
                    self.fetchNextPageMapSuccess.send()     // 토큰이 없다면
                }
            }.store(in: &subscription)
        
    }
    
    // MARK: 매거진 게시물 업로드시 맵 데이터도 같이 데이터 넣기
    func insertMap(data: MagazineFields) {
        print("insertMap 불렷음 --------------")
        MapService.insertMap(data: data)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
            } receiveValue: { (receivedData: MapResponse) in
                print("insertMap 불렷음 --------------")
                self.insertMapSuccess.send(data)
            }.store(in: &subscription)
    }
    
    func deleteMap(docID: String) {
        MapService.deleteMap(docID: docID)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
            } receiveValue: { (data: MapDocument) in
                self.deleteMapSuccess.send()
            }.store(in: &subscription)
    }
    
}
