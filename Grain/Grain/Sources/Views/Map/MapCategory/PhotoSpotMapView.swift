//
//  PhotoSpotMapView.swift
//  Grain
//
//  Created by 지정훈 on 2023/01/25.
//

import SwiftUI
import CoreLocation
import NMapsMap
import Combine
import UIKit


struct PhotoSpotMapView: View {
    @Binding var mapData: [MapDocument] // 맵 데이터 전달 받기
    @Binding var searchResponseBool: Bool
    @Binding var searchResponse: [Address]
    @Binding var isShowingPhotoSpot:  Bool
    @State var nearbyPostsArr : [String] = []
    @State var visitButton : Bool = false
    @StateObject var magazineVM = MagazineViewModel()
    @Binding var magazineData: [MagazineDocument]
    @State var clikedMagazineData : MagazineDocument?
    
    var body: some View {
        // 뒷배경 어둡게
    
        ZStack{
            if isShowingPhotoSpot{
                Rectangle()
                    .zIndex(1)
                    .opacity(0.3)
            }
            PhotoSpotUIMapView(mapData: $mapData, searchResponseBool: $searchResponseBool ,searchResponse: $searchResponse, isShowingPhotoSpot: $isShowingPhotoSpot ,nearbyPostsArr: $nearbyPostsArr , visitButton: $visitButton)
            
            
            if isShowingPhotoSpot{
                /// nearbyMagazineData -> NearbyPostsComponent뷰에서 ForEach을 위한 Magazine 데이터
                /// magazineVM.nearbyPostsFilter메서드 호출 반환 값으로 [MagazineDocument]
                /// 매개변수로는 contentView에서 전달 받은 magazineData 값 전달 / nearbyPostsArr : 포토스팟 클릭 마커
                /// 그럼 메서드에서 for in 두번 돌려 필요한 값만 전달
                /// 이 과정에서 DB 연관 없다고 생각 듬! -> 확인  필요
                NearbyPostsComponent(visitButton: $visitButton, isShowingPhotoSpot: $isShowingPhotoSpot, nearbyMagazineData: magazineVM.nearbyPostsFilter(magazineData: magazineData, nearbyPostsArr: nearbyPostsArr), clikedMagazineData: $clikedMagazineData)
                    .zIndex(1)
                    .offset(y: 250)
                    .padding(.leading, nearbyPostsArr.count > 1 ? 0 : 30)   // 포스트 갯수가 1개 이상이면 패딩값 0 아니면 30
            }
        }
        .fullScreenCover(isPresented: $visitButton, content: {
            PhotoSpotDetailView(data: clikedMagazineData!)
        })
        
    }
}


// FIXME: 네이버 지도
// 네이버 지도를 띄울 수 있게끔 만들어주는 코드들 <- 연구가 필요!! 이해 완료 후 주석 달아보기
struct PhotoSpotUIMapView: UIViewRepresentable,View {
    

    @StateObject var locationManager = LocationManager()
    
    @Binding var mapData: [MapDocument] // 맵 데이터 전달 받기
    @Binding var searchResponseBool: Bool
    @Binding var searchResponse: [Address]
    @Binding var isShowingPhotoSpot: Bool
    @Binding var nearbyPostsArr : [String]
    @Binding var visitButton : Bool
    
    
    //TODO: 지금 현재 위치를 못 받아오는거 같음
    var userLatitude: Double {
        return locationManager.lastLocation?.coordinate.latitude ?? 37.5069671
    }
    
    var userLongitude: Double {
        return locationManager.lastLocation?.coordinate.longitude ?? 127.0556671
    }
    
    // UIView 기반 컴포넌트의 인스턴스 생성하고 필요한 초기화 작업을 수행한 뒤 반환한다.
    func makeUIView(context: Context) -> NMFNaverMapView {
        // TODO: 비동기 알아보기
        
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
            if item.fields.category.stringValue == "필름스팟"{
                let marker = NMFMarker()
                marker.position = NMGLatLng(lat: item.fields.latitude.doubleValue, lng: item.fields.longitude.doubleValue)
                
                marker.iconImage = NMFOverlayImage(name: "photoSpotMarker")
                marker.width = 40
                marker.height = 40
                // MARK: 아이콘 캡션 - 포토스팟 글씨
                marker.captionText = item.fields.category.stringValue
                marker.captionColor = UIColor(red: 248.0/255.0, green: 188.0/255.0, blue: 36.0/255.0, alpha: 1)
                marker.captionTextSize = 12
                marker.captionHaloColor = UIColor(.gray)
                // MARK: URL링크 정보 받기
                marker.userInfo = ["magazine": item.fields.magazineID.arrayValue.values[0].stringValue]
                // MARK: 마커에 태그 번호 생성 -> 마커 클릭시에 사용됨
                marker.tag = 0

                // MARK: 마커 클릭시
                marker.touchHandler = { (overlay) in
                    if let marker = overlay as? NMFMarker {
                        isShowingPhotoSpot.toggle()
                        nearbyPostsArr.removeAll()
                        for pickable in view.mapView.pickAll(view.mapView.projection.point(from: NMGLatLng(lat: marker.position.lat, lng: marker.position.lng)), withTolerance: 30){
                            if let marker = pickable as? NMFMarker{
                                if marker.tag == 0 {
                                    nearbyPostsArr.append(marker.userInfo["magazine"] as! String)
                                }
                            }
                        }
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
                let marker = NMFMarker()
                marker.position = NMGLatLng(lat: Double(i.y) ?? userLatitude, lng: Double(i.x) ?? userLongitude)
                marker.iconImage = NMFOverlayImage(name: "allMarker")
                marker.width = 40
                marker.height = 40
                marker.captionText = "검색 결과 위치"
                marker.captionColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1)
                marker.captionTextSize = 12
                marker.captionHaloColor = UIColor(.gray)
                
                marker.mapView = uiView.mapView
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    marker.mapView = nil
                }
            }
            searchResponseBool.toggle()
        }
    }
    
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(viewModel: self.viewModel)
//        return Coordinator(buttonBool: <#T##Binding<Bool>#>, markerPoint: <#T##Binding<CGPoint>#>)
//    }

}
