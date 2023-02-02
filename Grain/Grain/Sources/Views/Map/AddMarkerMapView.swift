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
    
    @State var markerAddButtonBool : Bool = false
    @State var locationcheckBool : Bool = false
    @State var searchResponseBool : Bool = false
    
    // 네비게이션 뷰 돌아가기
    @Environment(\.dismiss) private var dismiss
    // 경도 위도 값 전달
    @Binding var updateNumber : NMGLatLng
    let style = StrokeStyle(lineWidth: 2,
                            lineCap: .round)
    // 텍스트 필드 String
    @State var searchMap : String = ""
    // geocode 하기 위해

    @StateObject var naverVM = NaverAPIViewModel()
    @StateObject var TestnaverVM = TestNaverAPIViewModel()
    // 위치 검색 결과 값
    @State var searchResponse : [Address] = [Address(roadAddress: "", jibunAddress: "", englishAddress: "", x: "", y: "", distance: 0)]
    
    @StateObject var locationManager = LocationManager()
    
    @State var updateReverseGeocodeResult :  [ReverseGeocodeResult] = [ReverseGeocodeResult(region: Region(area1: Area(name: ""), area2: Area(name: ""), area3: Area(name: ""), area4: Area(name: "")))]
    
    
    var body: some View {
        NavigationStack{
            ZStack{
                HStack{
                    // FIXME: onSubmit 하고 버튼 눌러야함
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.black),lineWidth: 2)
                        .frame(width: Screen.maxWidth * 0.85, height: 50)
                        .overlay{
                            TextField("위치를 검색해주세요", text: $searchMap)
                                .padding()
                                .onSubmit {
                                    // MARK: Geocode API 실행
                                    naverVM.fetchGeocode(requestAddress: searchMap)
                                }
                            //                                .background(Color.white)
                        }
                    Button{
                        // api 결과 값 @State에 넘겨 -> Binding
                        searchResponse = naverVM.addresses
                        searchResponseBool.toggle()
                    } label: {
                        Image(systemName: "cursorarrow.click.2")
                            .foregroundColor(.black)
                            .font(.title2)
                    }
                }
                .zIndex(1)
                .offset(y:-300)
               
                
                AddMarkerUIMapView(updateNumber: $updateNumber, markerAddButtonBool: $markerAddButtonBool, locationcheckBool: $locationcheckBool, searchResponseBool: $searchResponseBool, searchResponse: $searchResponse, updateReverseGeocodeResult: $updateReverseGeocodeResult)
                    .zIndex(0)
                
                Image("TestBlackMarker")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 56,height: 56)
                    .position(CGPoint(x: 196, y: 330))  //수정 필요
                    .zIndex(1)
                HStack{
                    Button {
                        markerAddButtonBool.toggle()
                        print("updateNumber\(updateNumber)")
                        
                        /// 추가하기 버튼 클릭시 게시글 업로드로 돌아가기
                        dismiss()
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
                    Button {
                        locationcheckBool.toggle()
                    } label: {
                        Text("위치 확인")
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }.buttonStyle(.borderedProminent)

                }
                .offset(y: 300)
                .zIndex(1)
                HStack{
                    ForEach(TestnaverVM.reverseGeocodeResult, id:\.self){ data in
                            Text(data.region.area1.name ?? "도")
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                            Text(data.region.area2.name ?? "시")
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                            Text(data.region.area3.name ?? "동")
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                    }
                }.onAppear{
                    TestnaverVM.fetchReverseGeocode(latitude:locationManager.lastLocation?.coordinate.latitude ?? 37.21230200 , longitude:locationManager.lastLocation?.coordinate.longitude ?? 127.07766400 )
                    updateReverseGeocodeResult = TestnaverVM.reverseGeocodeResult
                    print("여기 실행")
                }
                .offset(y: 250)
                .zIndex(1)
                
            }
        }
        
    }
}


// FIXME: 네이버 지도
// 네이버 지도를 띄울 수 있게끔 만들어주는 코드들 <- 연구가 필요!! 이해 완료 후 주석 달아보기
struct AddMarkerUIMapView: UIViewRepresentable,View {
    
    
    //임시
    @StateObject var naverVM = NaverAPIViewModel()
    @StateObject var TestnaverVM = TestNaverAPIViewModel()
    
    @StateObject var locationManager = LocationManager()
    // 가상 마커 CGPoint 좌표 값을 통해 지도 좌표 넘겨주기
    @Binding var updateNumber : NMGLatLng
    
    @Binding var markerAddButtonBool : Bool
    @Binding var locationcheckBool : Bool
    @Binding var searchResponseBool : Bool
    
    @State var changeMap : CGPoint = CGPoint(x: 0, y: 0)    //여기서는 안쓰임
    // 위에서 값 받아오기
    @Binding var searchResponse : [Address]
    
    @Binding var updateReverseGeocodeResult :  [ReverseGeocodeResult]
    
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
        //  추가하기 버튼 누를시 화면 중앙에 마커 생성
        
        
//        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { timer in
//            self.value += 1
//            print("타이머")
//            print(value)
//            naverVM.fetchReverseGeocode(latitude: updateNumber.lat, longitude: updateNumber.lng)
//            if markerAddButtonBool{
//                timer.invalidate()
//            }
//        }
        
        if locationcheckBool{
            TestnaverVM.fetchReverseGeocode(latitude: updateNumber.lat, longitude: updateNumber.lng)
            print("버튼 눌림")
            updateReverseGeocodeResult = TestnaverVM.reverseGeocodeResult
            locationcheckBool.toggle()
        }
        
        if markerAddButtonBool{
            let addUserMarker = NMFMarker()
            addUserMarker.position =  uiView.mapView.projection.latlng(from: CGPoint(x: 196, y: 359))
            addUserMarker.iconImage = NMF_MARKER_IMAGE_BLACK
            addUserMarker.mapView = uiView.mapView
            updateNumber = addUserMarker.position
            markerAddButtonBool.toggle()
            // FIXME: 추가하기 지도 뷰로 들어와 추가하기 버튼 누를시 뷰가 업데이트 되지 않아 <NMGLatLng: 0,0> 으로 나옴
            /// 버그 고쳐보기
        }
        
        if searchResponseBool{
            // MARK: 위치를 검색해주세요 버튼 누를시 장소로 이동
            /// x -> latitude / y -> longitude
            for i in searchResponse{
                uiView.mapView.moveCamera(NMFCameraUpdate(scrollTo:NMGLatLng(lat: Double(i.y) ?? userLatitude, lng: Double(i.x) ?? userLongitude) ))
            }
            searchResponseBool.toggle()
        }
       
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(viewModel: MapSceneViewModel(), markerAddButtonBool: $markerAddButtonBool, changeMap: $changeMap)
    }
    
    
}

//struct AddMarkerMapView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddMarkerMapView()
//    }
//}
