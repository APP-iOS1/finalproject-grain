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

    func fetchMap() {
        MapService.getMap()
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
            } receiveValue: { [self] (data: MapResponse) in
            self.mapData.append(contentsOf: data.documents) // MARK: mapData에 들어가는 방식 바꿈
            // 무한반복 들어감
            //  MARK: - 다음 페이지 토큰이 있을시
//                for _ in 0...2{
            var nextPageToken = data.nextPageToken!
                
            for _ in 0...5{
                nextPageToken = fetchNextPageMap(nextPageToken: nextPageToken)
                if nextPageToken == "end"{
                    print("end로 끝나야됨")
                    break
                }
            }
                
                
//                if !(data.nextPageToken == nil) {
//                    var nextPageToken = fetchNextPageMap(nextPageToken: data.nextPageToken!)
//                    if !(nil == nextPageToken){
//                        fetchNextPageMap(nextPageToken: nextPageToken)
//                    }
//                    if nil == nextPageToken{
//                        print("stop")
//                        self.fetchMapSuccess.send()
//                    }
//                }
////            }
//            // MARK: - 남아있는 다음 페이지 토큰이 없어 중단
//            if data.nextPageToken == nil{
//                print("다음 페이지 토큰 없음!! 중단 요청")
//                self.fetchMapSuccess.send()
//
//            }
        }.store(in: &subscription)
        print(self.mapData)
    }
    func fetchNextPageMap(nextPageToken: String) -> String{
        var nextPageToken : String = ""
        print("fetchNextPageMap 호출 @@@@")
        MapService.getNextPageMap(nextPageToken: nextPageToken)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
            } receiveValue: { (data: MapResponse) in
                self.mapData.append(contentsOf: data.documents)
                
                //  MARK: - 다음 페이지 토큰이 있을시
                if !(data.nextPageToken == nil) {
                    print("다음페이지 토큰: \(data.nextPageToken)")
                    nextPageToken = data.nextPageToken!
                    self.fetchNextPageMapSuccess.send()
                }else{
                    // MARK: 남아있는 다음 페이지 토큰이 없어 중단
                    nextPageToken = "end"
                    self.fetchNextPageMapSuccess.send()     // 토큰이 없다면 끝났다고 알리기
                }
            }.store(in: &subscription)
        return nextPageToken
    }

}

