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
    @Binding var mapData: [MapDocument] // 맵 데이터 전달 받기
//    @State var isShowingWebView: Bool = false   // 현상소, 수리점 모달 띄워주는 Bool
    @State var bindingWebURL : String = ""      // UIMapView 에서 마커에서 나오는 정보 가져오기 위해
    @Binding var isShowingWebView: Bool
    
    @Binding var searchResponseBool: Bool
    @Binding var searchResponse: [Address]

    var body: some View {
        ZStack{
            
            // 뒷배경 어둡게
            if isShowingWebView{
                Rectangle()
                    .zIndex(1)
                    .opacity(0.3)
            }
            StationUIMapView(isShowingWebView: $isShowingWebView, bindingWebURL: $bindingWebURL,mapData: $mapData, searchResponseBool: $searchResponseBool ,searchResponse: $searchResponse)
        }
        .sheet(isPresented: $isShowingWebView) {    // webkit 모달뷰
            WebkitView(bindingWebURL: $bindingWebURL).presentationDetents( [.medium])
        }
    }
}


// FIXME: 네이버 지도
// 네이버 지도를 띄울 수 있게끔 만들어주는 코드들 <- 연구가 필요!! 이해 완료 후 주석 달아보기
struct StationUIMapView: UIViewRepresentable,View {
    @Binding var isShowingWebView: Bool
    @Binding var bindingWebURL : String
    
    
//    @ObservedObject var viewModel = MapSceneViewModel()
    @StateObject var locationManager = LocationManager()
    
    @Binding var mapData: [MapDocument] // 맵 데이터 전달 받기
    
    @Binding var searchResponseBool: Bool
    @Binding var searchResponse: [Address]
    
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
            if item.fields.category.stringValue == "현상소"{
                let marker = NMFMarker()
                marker.position = NMGLatLng(lat: item.fields.latitude.doubleValue, lng: item.fields.longitude.doubleValue)
                marker.iconImage = NMFOverlayImage(name: "stationMarker")
                marker.width = 40
                marker.height = 40
                // MARK: 아이콘 캡션 - 현상소 글씨
                marker.captionText = item.fields.category.stringValue
                marker.captionColor = UIColor(red: 245.0/255.0, green: 136.0/255.0, blue: 0.0/255.0, alpha: 1)
                marker.captionTextSize = 12
                marker.captionHaloColor = UIColor(.gray)
                marker.userInfo = ["url" :  item.fields.url.stringValue]
                marker.tag = 1
                // MARK: 마커 클릭시
                marker.touchHandler = { (overlay) in
                    if let marker = overlay as? NMFMarker {
                        isShowingWebView.toggle()
                        bindingWebURL = marker.userInfo["url"] as! String
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
        if searchResponseBool{
            // MARK: 위치를 검색해주세요 버튼 누를시 장소로 이동
            /// x -> latitude / y -> longitude
            for i in searchResponse{
                uiView.mapView.moveCamera(NMFCameraUpdate(scrollTo:NMGLatLng(lat: Double(i.y) ?? userLatitude, lng: Double(i.x) ?? userLongitude) ))
            }
            searchResponseBool.toggle()
        }
    }
    
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(viewModel: self.viewModel)
//    }

}

