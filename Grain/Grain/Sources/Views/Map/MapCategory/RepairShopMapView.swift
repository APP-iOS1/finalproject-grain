//
//  RepairShopMapView.swift
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


struct RepairShopMapView: View {
    @Binding var mapData: [MapDocument] // 맵 데이터 전달 받기
    var body: some View {
        ZStack{

            RepairShopUIMapView(mapData: $mapData)
        }
        
    }
}


// FIXME: 네이버 지도
// 네이버 지도를 띄울 수 있게끔 만들어주는 코드들 <- 연구가 필요!! 이해 완료 후 주석 달아보기
struct RepairShopUIMapView: UIViewRepresentable,View {
    
    @StateObject var locationManager = LocationManager()
    @Binding var mapData: [MapDocument] // 맵 데이터 전달 받기
   
    
    //TODO: 지금 현재 위치를 못 받아오는거 같음
    var userLatitude: Double {
        return locationManager.lastLocation?.coordinate.latitude ?? 37.21230200
    }
    
    var userLongitude: Double {
        return locationManager.lastLocation?.coordinate.longitude ?? 127.07766400
    }
    
    // UIView 기반 컴포넌트의 인스턴스 생성하고 필요한 초기화 작업을 수행한 뒤 반환한다.
    func makeUIView(context: Context) -> NMFNaverMapView {
       
       
        // MARK: 네이버 맵 지도 생성
        let view = NMFNaverMapView()
        view.showZoomControls = false
        view.mapView.positionMode = .direction
        // 처음에 맵이 생성될떄 줌 레벨
        view.mapView.zoomLevel = 12
        view.mapView.minZoomLevel = 10
        view.mapView.maxZoomLevel = 16
        view.mapView.isRotateGestureEnabled = false

//        view.mapView.touchDelegate = context.coordinator
        
        // MARK: 네이버 지도 나침판, 현재 유저 위치 GPS 버튼
        // TODO: 네이버 지도 공식 문서 읽어보기
        view.showCompass = false
        view.showLocationButton = true
        
        // MARK: 지도가 그려질때 현재 유저 GPS 위치로 카메라 움직임
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: userLatitude, lng: userLongitude))
        view.mapView.moveCamera(cameraUpdate)
        
        
        for item in mapData{
            if item.fields.category.stringValue == "수리점"{
                let marker = NMFMarker()
                marker.position = NMGLatLng(lat: item.fields.latitude.doubleValue, lng: item.fields.longitude.doubleValue)
                marker.iconImage = NMFOverlayImage(name: "repairShopMarker")
                marker.width = 40
                marker.height = 40
                // MARK: 아이콘 캡션 - 수리점 글씨
                marker.captionText = item.fields.category.stringValue
                marker.captionColor = UIColor(red: 38.0/255.0, green: 104.0/255.0, blue: 103.0/255.0, alpha: 1)
                marker.captionTextSize = 12
                marker.captionHaloColor = UIColor(.gray)
                marker.userInfo = ["url" :  item.fields.url.stringValue]
                marker.tag = 2
                // MARK: 마커 클릭시
                marker.touchHandler = { (overlay) in
                    if let marker = overlay as? NMFMarker {
                        print("수리점 클릭")
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
    
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(viewModel: self.viewModel)
//
//    }

}
