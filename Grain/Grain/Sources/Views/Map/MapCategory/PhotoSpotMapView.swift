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
    @ObservedObject var userVM: UserViewModel
    @ObservedObject var magazineVM: MagazineViewModel
    @ObservedObject var locationManager : LocationManager
    
    @Binding var mapData: [MapDocument] // 맵 데이터 전달 받기
    @Binding var searchResponseBool: Bool
    @Binding var searchResponse: [Address]
    @Binding var ObservingChangeValueLikeNum: String
    @State var isShowingPhotoSpot :  Bool = false
    @State var nearbyPostsArr : [String] = []
    @State var visitButton : Bool = false

    @Binding var magazineData: [MagazineDocument]
    
    @State var clikedMagazineData : MagazineDocument?
    
    @Binding var showResearchButton : Bool
    var userLatitude: Double
    var userLongitude: Double
    @Binding var researchButtonBool : Bool
    @Binding var researchCGPoint : CGPoint
    
    var body: some View {
        ZStack{
            PhotoSpotUIMapView(locationManager: locationManager, mapData: $mapData, searchResponseBool: $searchResponseBool ,searchResponse: $searchResponse, isShowingPhotoSpot: $isShowingPhotoSpot , nearbyPostsArr: $nearbyPostsArr, visitButton: $visitButton, showResearchButton: $showResearchButton, userLatitude: userLatitude , userLongitude: userLongitude, researchButtonBool: $researchButtonBool, researchCGPoint: $researchCGPoint)
            
            if isShowingPhotoSpot{
                
                NearbyPostsComponent(userVM: userVM, magazineVM: magazineVM, visitButton: $visitButton, isShowingPhotoSpot: $isShowingPhotoSpot, nearbyMagazineData: magazineVM.nearbyPostsFilter(magazineData: magazineVM.magazines, nearbyPostsArr: nearbyPostsArr), clikedMagazineData: $clikedMagazineData, showResearchButton: $showResearchButton)
                    .zIndex(1)
                    .position(x: Screen.maxWidth * 0.5 , y: Screen.maxHeight * 0.75)
                    .padding(.leading, nearbyPostsArr.count > 1 ? 0 : 30)   // 포스트 갯수가 1개 이상이면 패딩값 0 아니면 30
            }
        }
        .onAppear{
            isShowingPhotoSpot = false
        }
        .fullScreenCover(isPresented: $visitButton, content: {
            MagazineDetailView(magazineVM: magazineVM, userVM: userVM, data: clikedMagazineData!, ObservingChangeValueLikeNum: $ObservingChangeValueLikeNum)
        })
    }
}


// FIXME: 네이버 지도
// 네이버 지도를 띄울 수 있게끔 만들어주는 코드들 <- 연구가 필요!! 이해 완료 후 주석 달아보기
struct PhotoSpotUIMapView: UIViewRepresentable,View {
    @ObservedObject var locationManager : LocationManager
    
    @Binding var mapData: [MapDocument] // 맵 데이터 전달 받기
    @Binding var searchResponseBool: Bool
    @Binding var searchResponse: [Address]
    @Binding var isShowingPhotoSpot: Bool
    
    @Binding var nearbyPostsArr : [String]
    @Binding var visitButton : Bool
    
    @Binding var showResearchButton : Bool
    @State var fetchMarkers: [NMFMarker] = []
    
    
    var userLatitude: Double
    var userLongitude: Double
    @Binding var researchButtonBool : Bool
    @Binding var researchCGPoint : CGPoint
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
            for item in mapData{
                if item.fields.category.stringValue == "필름스팟"{
                    var marker = NMFMarker(position: NMGLatLng(lat: item.fields.latitude.doubleValue, lng: item.fields.longitude.doubleValue))
                    marker.iconImage = NMFOverlayImage(name: "photoSpotMarker")
                    marker.width = 25
                    marker.height = 25
                    // MARK: 아이콘 캡션 - 포토스팟 글씨
                    marker.captionText = item.fields.category.stringValue
                    marker.captionColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1)
                    marker.captionTextSize = 9
                    marker.captionHaloColor = UIColor(.white)
                    // MARK: URL링크 정보 받기
                    marker.userInfo = ["magazine": item.fields.magazineID.arrayValue.values[0].stringValue]
                    // MARK: 마커에 태그 번호 생성 -> 마커 클릭시에 사용됨
                    marker.tag = 0
                    fetchMarkers.append(marker)
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
            for marker in fetchMarkers{
                marker.mapView = view.mapView
                
                marker.touchHandler = { (overlay) in
                    if let marker = overlay as? NMFMarker {
                        isShowingPhotoSpot = true
                        showResearchButton = false
                        nearbyPostsArr.removeAll()
                        for pickable in view.mapView.pickAll(view.mapView.projection.point(from: NMGLatLng(lat: marker.position.lat, lng: marker.position.lng)), withTolerance: 30){
                            if let marker = pickable as? NMFMarker{
                                if marker.tag == 0 {
                                    if nearbyPostsArr.contains(marker.userInfo["magazine"] as! String){
                                        continue
                                    }
                                    nearbyPostsArr.append(marker.userInfo["magazine"] as! String)
                                }
                                
                            }
                        }
                    }
                    return true
                }
                
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
                marker.width = 25
                marker.height = 25
                marker.captionText = "검색 결과 위치"
                marker.captionColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1)
                marker.captionTextSize = 9
                marker.captionHaloColor = UIColor(.white)
                
                marker.mapView = uiView.mapView
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    marker.mapView = nil
                }
            }
            searchResponseBool.toggle()
        }
        
        if researchButtonBool{
           
            
            var addUserMarker = NMFMarker()
            addUserMarker.position = uiView.mapView.projection.latlng(from: researchCGPoint)
            uiView.mapView.moveCamera(NMFCameraUpdate(scrollTo: NMGLatLng(lat: addUserMarker.position.lat, lng: addUserMarker.position.lng)))
        
            researchButtonBool.toggle()
            
            // 지도 데이터 마커를 전부 보여줌 처리
            for marker in fetchMarkers{
                marker.hidden = false
            }
            // 지도 데이터 마커를 전부 숨김 처리
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                for marker in fetchMarkers{
                    marker.hidden = true
                }
                
            }
            // 350 반경 마커들만 보여줌 처리
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                for pickable in uiView.mapView.pickAll(researchCGPoint, withTolerance: 350){
                    if let marker = pickable as? NMFMarker{
                        marker.hidden = false
                        
                    }
                }
            }
        }
    }
    
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(viewModel: self.viewModel)
//        return Coordinator(buttonBool: <#T##Binding<Bool>#>, markerPoint: <#T##Binding<CGPoint>#>)
//    }

}
