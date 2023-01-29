//
//  AddMarkerMapView.swift
//  Grain
//
//  Created by 지정훈 on 2023/01/27.
//

import SwiftUI
import CoreLocation
import NMapsMap
import Combine
import UIKit

struct AddMarkerMapView: View {
    @EnvironmentObject var viewRouter: ViewRouter

//    @State var imagePoint : CGPoint = CGPoint(x: 196, y: 335 )
    
    @State var markerAddButtonBool : Bool = false
    // 가상 마커 CGPoint 좌표 값을 통해 지도 좌표 받아오기
    @State var updateNumber : NMGLatLng
    
    let style = StrokeStyle(lineWidth: 2,
                            lineCap: .round)
    
    var body: some View {
        NavigationStack{
            ZStack{
                
                AddMarkerUIMapView(updateNumber: $updateNumber, markerAddButtonBool: $markerAddButtonBool)
//                AddMarkerUIMapView(testBool: $testBool)
                Image("TestBlackMarker")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 56,height: 56)
                    .position(CGPoint(x: 196, y: 335))  //수정 필요
                    .onTapGesture {
                        // 가상 마커 클릭시 액션
                    }
                //                    .zIndex(0)
                Button {
//                    print("updateNumber\(updateNumber)")
                    markerAddButtonBool.toggle()
                } label: {
                    Text("추가하기")
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                }
                // ButtonStyle 스타일 사용할껀지?
                .buttonStyle(.borderedProminent)
                /// 커스텀 할껀지
//                .padding(5)    // 글자와 주변 선의 간격을 떨어트림
//                .overlay {
//                    // MARK: 텍스트에 주변에 선 만들기
//                    RoundedRectangle(cornerRadius: 5)
//                        .stroke(style: style)
//                }
                .offset(y: 300)
            }
            // 네비게이션 스택에 툴바
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        viewRouter.currentPage = .mapView
                    } label: {
                        Text("돌아가기")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                       
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
struct AddMarkerUIMapView: UIViewRepresentable,View {
    
    
    //임시
//    @ObservedObject var viewModel = MapSceneViewModel()
    @StateObject var locationManager = LocationManager()
    
    // 가상 마커 CGPoint 좌표 값을 통해 지도 좌표 넘겨주기
    @Binding var updateNumber : NMGLatLng
    
    @Binding var markerAddButtonBool : Bool
    
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
        view.mapView.zoomLevel = 13
        
        
        // MARK: 네이버 지도 나침판, 현재 유저 위치 GPS 버튼
        view.showCompass = false
        view.showLocationButton = true

        view.mapView.touchDelegate = context.coordinator
        
        // MARK: 지도가 그려질때 현재 유저 GPS 위치로 카메라 움직임
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: userLatitude, lng: userLongitude))
        view.mapView.moveCamera(cameraUpdate)
        
                
        let currentUserMarker = NMFMarker()
        currentUserMarker.position = NMGLatLng(lat: userLatitude, lng: userLongitude)
        currentUserMarker.iconImage = NMF_MARKER_IMAGE_BLACK
        currentUserMarker.zIndex = 1    /// 마커 zindex
        currentUserMarker.captionText = "현재위치"
        currentUserMarker.captionColor = UIColor.black
        currentUserMarker.captionHaloColor = UIColor(red: 200.0/255.0, green: 1, blue: 200.0/255.0, alpha: 1)
        
        /// 화면상의 currentUserMarker 마커 CGPoint값
//        let point = view.mapView.projection.point(from: currentUserMarker.position)
        
        currentUserMarker.mapView = view.mapView
        return view
    }
    // UIView 자체를 업데이트 해야 하는 변경이 swiftui 뷰에서 생길떄 마다 호출된다.
    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {
        print("testBool 시작 전 : \(markerAddButtonBool)")
        
        //  추가하기 버튼 누를시 화면 중앙에 마커 생성
        if markerAddButtonBool{
            let currentUserMarker = NMFMarker()
            currentUserMarker.position =  uiView.mapView.projection.latlng(from: CGPoint(x: 196, y: 335)) // CGPoint값 수정 필요
            currentUserMarker.iconImage = NMF_MARKER_IMAGE_RED
            currentUserMarker.mapView = uiView.mapView
            print(currentUserMarker.position)
            markerAddButtonBool.toggle()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(markerAddButtonBool: $markerAddButtonBool)
    }
    
}

//struct AddMarkerMapView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddMarkerMapView()
//    }
//}


