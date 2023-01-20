//
//  MapView.swift
//  Grain
//
//  Created by 조형구 on 2023/01/18.
//

import SwiftUI
import CoreLocation
import MapKit
import NMapsMap
import Combine
import UIKit


struct MapView: View {
    
    @State private var searchText = ""
    @ObservedObject var mapStore = MapStore()
    
    var body: some View {
        NavigationStack{
            // MARK: 지도 탭의 상단
            VStack{
                
                // MARK: 지도 카테고리 버튼
                // TODO: 포토스팟, 현상소, 수리점 셀뷰로 만들기
                HStack{
                    MapCategoryCellView()
                }
                
                
            }
            // MARK: 지도 뷰에서 검색 란
            /// https://ios-development.tistory.com/1124 참고 자료 <- 리팩토링 할때 다시 읽어보기
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "검색 placholder..."
            )
            // searchable에서 완료 버튼을 누를시 액션
            .onSubmit(of: .search) {
                print("검색 완료: \(searchText)")
            }
            
            ZStack{
                // MARK: 지도 뷰
                // 네이버 지도를 띄워주는 역할
                UIMapView()
                
                
            }
            .onAppear{
                Task{
//                    await mapStore.fetchMapData()
                }
            }
            // MARK: 상단 클릭 가능 버튼
            .toolbar {  //MARK: 홈으로 돌아가기?? <- 회의 필요
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        FirebaseService.insertMagazine(userID: "1", cameraInfo: "1", nickName: "1", image: "1", content: "1", title: "1")
//                        FirebaseService.insertCommunity(profileImage: "1", nickName: "1", category: "1", image: "1", userID: "1", title: "1", content: "1")
                    } label: {
                        Text("Grain")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }
                }
            }
            .toolbar {  //MARK: 제보하기 <- 회의 필요
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        Task{
                            try await print(FirebaseService.getMagazine())
                        }
                        
//                        print("플러스 Button Clicked")
//                        Task{
//                            await mapStore.fetchMapData()
//                        }
                        
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(.black)
                    }
                }
            }
            
        }
        
    }
}


// FIXME: 네이버 지도
// 네이버 지도를 띄울 수 있게끔 만들어주는 코드들 <- 연구가 필요!! 이해 완료 후 주석 달아보기
struct UIMapView: UIViewRepresentable {
    
    
    @ObservedObject var viewModel = MapSceneViewModel()
    @StateObject var locationManager = LocationManager()
    
    // 지울예정
    @ObservedObject var mapStore = MapStore()
    
    
    //TODO: 지금 현재 위치를 못 받아오는거 같음
    var userLatitude: Double {
        return locationManager.lastLocation?.coordinate.latitude ?? 37.21230200
    }
    
    var userLongitude: Double {
        return locationManager.lastLocation?.coordinate.longitude ?? 127.07766400
    }
    
    func makeUIView(context: Context) -> NMFNaverMapView {
        
        // TODO: 비동기 알아보기
        mapStore.fetchMapData()
        // NMFNaverMapView 인터페이스
        let view = NMFNaverMapView()
        view.showZoomControls = false
        view.mapView.positionMode = .direction
        view.mapView.zoomLevel = 17
        //        view.mapView.mapType = .hybrid
        view.mapView.touchDelegate = context.coordinator
        
        // MARK: 네이버 지도 나침판, 현재 유저 위치 GPS 버튼
        // TODO: 네이버 지도 공식 문서 읽어보기
        view.showCompass = false
        view.showLocationButton = true
        
        
        // MARK: 지도가 그려질때 현재 유저 GPS 위치로 카메라 움직임
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: userLatitude, lng: userLongitude))
        view.mapView.moveCamera(cameraUpdate)
        //
       
        // TODO: 비동기적으로 코드 수정 필요함! , 마커 대신 이미지 사진, 글씨로 대체해야함
        // MARK: Map 컬렉션 DB에서 위치 정보를 받아와 마커로 표시
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            for item in mapStore.mapData{
                let marker = NMFMarker()
                marker.position = NMGLatLng(lat: item.latitude, lng:item.longitude )
                marker.mapView = view.mapView
            }
        }
        
        
        
        return view
    }
    
    
    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {
        
            
    }
    
    
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(viewModel: self.viewModel)
    }
    
    
}

class Coordinator: NSObject, NMFMapViewTouchDelegate, NMFMapViewCameraDelegate, NMFMapViewOptionDelegate {
    @ObservedObject var viewModel: MapSceneViewModel
    var cancellable = Set<AnyCancellable>()
    
    @Published var latitude : Double
    @Published var longitude : Double
    
    
    init(viewModel: MapSceneViewModel) {
        self.viewModel = viewModel
        self.latitude = 0.0
        self.longitude = 0.0
    }
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        print("지도 탭")
        print("\(latlng.lat), \(latlng.lng)")
        self.latitude = latlng.lat
        self.longitude = latlng.lng
    }
}

class MapSceneViewModel: ObservableObject {
    
}
