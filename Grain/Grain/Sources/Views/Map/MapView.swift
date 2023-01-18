//
//  MapView.swift
//  Grain
//
//  Created by 지정훈 on 2023/01/18.
//

import SwiftUI
import CoreLocation
import MapKit
import NMapsMap
import Combine
import UIKit


struct MapView: View {
    var body: some View {
        NavigationStack{
            VStack{
                
                // MARK: 지도 뷰
                // 네이버 지도를 띄워주는 역할
                UIMapView().ignoresSafeArea(.all, edges: .top)
                // MARK: 지도 뷰에서 검색 란
                //
                // MARK: 지도 카테고리 버튼
                //
                
            }
        }
        
        
    }
}


// FIXME: 네이버 지도
// 네이버 지도를 띄울 수 있게끔 만들어주는 코드들 <- 연구가 필요!! 이해 완료 후 주석 달아보기
struct UIMapView: UIViewRepresentable {
    
    
    @ObservedObject var viewModel = MapSceneViewModel()
    @StateObject var locationManager = LocationManager()
    
    
    
    var userLatitude: Double {
        return locationManager.lastLocation?.coordinate.latitude ?? 37.21230200
    }
    
    var userLongitude: Double {
        return locationManager.lastLocation?.coordinate.longitude ?? 127.07766400
    }
    
    func makeUIView(context: Context) -> NMFNaverMapView {
        
        // NMFNaverMapView 인터페이스
        let view = NMFNaverMapView()
        view.showZoomControls = false
        view.mapView.positionMode = .direction
        view.mapView.zoomLevel = 17
//        view.mapView.mapType = .hybrid
        view.mapView.touchDelegate = context.coordinator
        
        
        //
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: userLatitude, lng: userLongitude))
        view.mapView.moveCamera(cameraUpdate)
        //
        view.showCompass = true
        view.showLocationButton = true
        
        
       
        let image = UIImage(named: "testImage")
        let newSize = CGSize(width: 100, height: 100)

        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image?.draw(in: CGRect(origin: .zero, size: newSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        
        return view
    }
    
    
    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {}
    
   
    
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
