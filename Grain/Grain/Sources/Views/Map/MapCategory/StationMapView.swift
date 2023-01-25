//
//  StationMapView.swift
//  Grain
//
//  Created by 지정훈 on 2023/01/25.
//

import SwiftUI
import CoreLocation
import MapKit
import NMapsMap
import Combine
import UIKit


struct StationMapView: View {
    var body: some View {
        ZStack{
            StationUIMapView()
        }
    }
}


// FIXME: 네이버 지도
// 네이버 지도를 띄울 수 있게끔 만들어주는 코드들 <- 연구가 필요!! 이해 완료 후 주석 달아보기
struct StationUIMapView: UIViewRepresentable,View {
    
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
    
    // UIView 기반 컴포넌트의 인스턴스 생성하고 필요한 초기화 작업을 수행한 뒤 반환한다.
    func makeUIView(context: Context) -> NMFNaverMapView {
        // TODO: 비동기 알아보기
        mapStore.fetchMapData()
        // MARK: 네이버 맵 지도 생성
        let view = NMFNaverMapView()
        view.showZoomControls = false
        view.mapView.positionMode = .direction
        view.mapView.zoomLevel = 13
        //        view.mapView.mapType = .hybrid
        view.mapView.touchDelegate = context.coordinator
        
        // MARK: 네이버 지도 나침판, 현재 유저 위치 GPS 버튼
        // TODO: 네이버 지도 공식 문서 읽어보기
        view.showCompass = false
        view.showLocationButton = true
        
        // MARK: 지도가 그려질때 현재 유저 GPS 위치로 카메라 움직임
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: userLatitude, lng: userLongitude))
        view.mapView.moveCamera(cameraUpdate)
        
        
        // MARK: MAP DB에 들어간 정보
        var markers: [MarkerCustomInfo] = []
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            for i in mapStore.mapData{
                // 2 -> 수리점일 경우에 markers에 넣기
                if i.category == 1{
                    var object : MarkerCustomInfo = MarkerCustomInfo(marker: NMGLatLng(lat: i.latitude, lng: i.longitude), category: i.category ?? 4, url: i.url)
                    markers.append(object)
                }
            }
        }
        // TODO: 비동기적으로 코드 수정 필요함! , 마커 대신 이미지 사진, 글씨로 대체해야함
        // MARK: Map 컬렉션 DB에서 위치 정보를 받아와 마커로 표시
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            for item in markers{
                let marker = NMFMarker()
                marker.position = item.marker
                marker.iconImage = NMF_MARKER_IMAGE_PINK

                // MARK: 아이콘 캡션 - 수리점 글씨
                marker.captionText = "현상소"
                marker.userInfo = ["tag" : 1]
                marker.tag = 1
                
                // MARK: 마커 클릭시
                marker.touchHandler = { (overlay) in
                    if let marker = overlay as? NMFMarker {
                        print("현상소 클릭")
                    }
                    return true
                }
                marker.mapView = view.mapView

            }
        }
        return view
    }
    // UIView 자체를 업데이트 해야 하는 변경이 swiftui 뷰에서 생길떄 마다 호출된다.
    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(viewModel: self.viewModel)
    }

}

