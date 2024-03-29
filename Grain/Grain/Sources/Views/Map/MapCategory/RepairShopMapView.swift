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
    @ObservedObject var locationManager : LocationManager
    
    @Binding var mapData: [MapDocument] // 맵 데이터 전달 받기
    @State var bindingWebURL : String = ""      // UIMapView 에서 마커에서 나오는 정보 가져오기 위해
    @Binding var isShowingWebView: Bool
    @Binding var searchResponseBool: Bool
    @Binding var searchResponse: [Address]

    var userLatitude: Double
    var userLongitude: Double
    
    @Binding var researchButtonBool : Bool
    @Binding var researchCGPoint : CGPoint
    
    var body: some View {
        ZStack{
            RepairShopUIMapView(locationManager : locationManager, mapData: $mapData, isShowingWebView: $isShowingWebView, bindingWebURL: $bindingWebURL, searchResponseBool: $searchResponseBool ,searchResponse: $searchResponse, userLatitude: userLatitude , userLongitude: userLongitude, researchButtonBool: $researchButtonBool, researchCGPoint: $researchCGPoint)
        }
        .sheet(isPresented: $isShowingWebView) {    // webkit 모달뷰
            WebkitView(bindingWebURL: $bindingWebURL).presentationDetents( [.medium])
        }
        
    }
}


// FIXME: 네이버 지도
// 네이버 지도를 띄울 수 있게끔 만들어주는 코드들 <- 연구가 필요!! 이해 완료 후 주석 달아보기
struct RepairShopUIMapView: UIViewRepresentable,View {
    
    @ObservedObject var locationManager : LocationManager
    
    @Binding var mapData: [MapDocument] // 맵 데이터 전달 받기
    @Binding var isShowingWebView: Bool
    @Binding var bindingWebURL : String
    @Binding var searchResponseBool: Bool
    @Binding var searchResponse: [Address]
    @State var fetchMarkers: [NMFMarker] = []
    
    var userLatitude: Double
    var userLongitude: Double
    
    @Binding var researchButtonBool : Bool
    @Binding var researchCGPoint : CGPoint
    
    // UIView 기반 컴포넌트의 인스턴스 생성하고 필요한 초기화 작업을 수행한 뒤 반환한다.
    func makeUIView(context: Context) -> NMFNaverMapView {
       
       
        // MARK: 네이버 맵 지도 생성
        let view = NMFNaverMapView()
        view.showZoomControls = false
        view.mapView.positionMode = .direction
        // 처음에 맵이 생성될떄 줌 레벨
        view.mapView.zoomLevel = 12
        view.mapView.minZoomLevel = 10
        view.mapView.maxZoomLevel = 20
        view.mapView.isRotateGestureEnabled = false
        
        // MARK: 네이버 지도 나침판, 현재 유저 위치 GPS 버튼
        // TODO: 네이버 지도 공식 문서 읽어보기
        view.showCompass = false
        view.showLocationButton = true
        
        // MARK: 지도가 그려질때 현재 유저 GPS 위치로 카메라 움직임
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: userLatitude, lng: userLongitude))
        view.mapView.moveCamera(cameraUpdate)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
            for item in mapData{
                if item.fields.category.stringValue == "수리점"{
                    var marker = NMFMarker(position: NMGLatLng(lat: item.fields.latitude.doubleValue, lng: item.fields.longitude.doubleValue))
                    marker.iconImage = NMFOverlayImage(name: "repairShopMarker")
                    marker.width = 25
                    marker.height = 25
                    // MARK: 아이콘 캡션 - 수리점 글씨
                    marker.captionText = item.fields.category.stringValue
                    marker.captionColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1)
                    marker.captionTextSize = 9
                    marker.captionHaloColor = UIColor(.white)
                    marker.userInfo = ["url" :  item.fields.url.stringValue]
                    marker.tag = 2
                    fetchMarkers.append(marker)
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
            for marker in fetchMarkers{
                marker.mapView = view.mapView
                
                marker.touchHandler = { (overlay) in
                    if let marker = overlay as? NMFMarker {
                        isShowingWebView.toggle()
                        bindingWebURL = marker.userInfo["url"] as! String
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
//
//    }

}
