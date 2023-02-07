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
    //임시
    //    searchMap = data.region.area1.name + data.region.area2.name + data.region.area3.name
    // 네비게이션 뷰 돌아가기
    @Environment(\.dismiss) private var dismiss
    // 경도 위도 값 전달
    @Binding var updateNumber : NMGLatLng
    @Binding var updateReverseGeocodeResult1 : String
    let style = StrokeStyle(lineWidth: 2,
                            lineCap: .round)
    // 텍스트 필드 String
    @State var searchMap : String = ""
    // geocode 하기 위해
    
    @StateObject var naverVM = NaverAPIViewModel()

    // 위치 검색 결과 값
    @State var searchResponse : [Address] = [Address(roadAddress: "", jibunAddress: "", englishAddress: "", x: "", y: "", distance: 0)]
    
    @StateObject var locationManager = LocationManager()
    
    @State var updateReverseGeocodeResult :  [ReverseGeocodeResult] = [ReverseGeocodeResult(region: Region(area1: Area(name: ""), area2: Area(name: ""), area3: Area(name: ""), area4: Area(name: "")))]
    
    @Binding var inputTitle: String
    @Binding var inputContent: String
    @Binding var selectedImages: [UIImage]
    @Binding var inputCustomPlace: String
    @Binding var presented : Bool

    @State var isDragging = false
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var drag: some Gesture {
        DragGesture()
            .onChanged{ _ in self.isDragging = true}
            .onEnded{ _ in self.isDragging = false}
    }
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack(alignment: .top) {
                    
                    //MARK: 네이버맵뷰
                    AddMarkerUIMapView(updateNumber: $updateNumber, updateReverseGeocodeResult1: $updateReverseGeocodeResult1, markerAddButtonBool: $markerAddButtonBool, locationcheckBool: $locationcheckBool, searchResponseBool: $searchResponseBool, searchResponse: $searchResponse, updateReverseGeocodeResult: $updateReverseGeocodeResult)
                    //.zIndex(0)
                        .ignoresSafeArea()
                    .onTapGesture {
                        hideKeyboard()
                        //markerAddButtonBool.toggle()
                    }
//                    .onChange(of: isDragging) { newValue in
//                        markerAddButtonBool.toggle()
//                    }
                    

                    
                    VStack {
                        
                        //MARK: 맵뷰 상단 검색바
                        HStack{
                            // FIXME: onSubmit 하고 버튼 눌러야함
                            TextField("🔍 위치를 검색해주세요", text: $searchMap)
                                .padding()
                                .background(.white)
                                .cornerRadius(15)
                                .onSubmit {
                                    // MARK: Geocode API 실행
                                    naverVM.fetchGeocode(requestAddress: searchMap)
                                }
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.white)
                                .frame(width: 50, height: 51)
                                .overlay{
                                    Image(systemName: "location.magnifyingglass")
                                        .onTapGesture {
                                            searchResponse = naverVM.addresses
                                            searchResponseBool.toggle()
                                        }
                                }
                        }
                        .padding()
                        .shadow(radius: 1)
                        //.offset(y:-300)
                        

                        
                                    
                        //                    .position(CGPoint(x: 196, y: 330))  //수정 필요
                        //.zIndex(1)
                        
                        Spacer()
                        //MARK: 마커가 찍힌 주소 출력 부분
                        Text(updateReverseGeocodeResult1)
                            .foregroundColor(.red)
                        //MARK: 추가하기 버튼
//                        Button {
//                            //markerAddButtonBool.toggle()
//                            print("추가하기 클릭")
//                        } label: {
//                            RoundedRectangle(cornerRadius: 12)
//                                .foregroundColor(.white)
//                                .frame(width: Screen.maxWidth * 0.3, height: Screen.maxHeight * 0.1)
//                                .overlay {
//                                    Text("추가하기")
//                                        .foregroundColor(.red)
//                                }
//                        }
                        //.offset(y: 270)
                        //.zIndex(1)
                    }
                    
                    //.zIndex(1)
                    Image("TestBlackMarker")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 56,height: 56)
                        .offset(y: Screen.maxHeight * 0.355)
                }

            }
            .toolbar {
                ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading) {
                    Button {
                        self.mode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                            .bold()
                            .opacity(1)
                            .shadow(radius: 1)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        CameraLenseFilmModalView(inputTitle: $inputTitle, inputContent: $inputContent, updateNumber: $updateNumber, updateReverseGeocodeResult1: $updateReverseGeocodeResult1, selectedPlace: $selectedImages, inputCustomPlace: $inputCustomPlace)
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        Image(systemName: "chevron.right")
                            .foregroundColor(.black)
                            .bold()
                            .opacity(1)
                            .shadow(radius: 1)
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
    @StateObject var naverVM = NaverAPIViewModel()

    @StateObject var locationManager = LocationManager()
    // 가상 마커 CGPoint 좌표 값을 통해 지도 좌표 넘겨주기
    @Binding var updateNumber : NMGLatLng
    @Binding var updateReverseGeocodeResult1 : String
    
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
        
        // FIXME: 현재 위치 버튼 -> 로직 변경 해야함
        if locationcheckBool{
            naverVM.fetchReverseGeocode(latitude: updateNumber.lat, longitude: updateNumber.lng)
            updateReverseGeocodeResult = naverVM.reverseGeocodeResult
            locationcheckBool.toggle()
        }
        
        if markerAddButtonBool{
            let addUserMarker = NMFMarker()
            addUserMarker.position =  uiView.mapView.projection.latlng(from: CGPoint(x: 196, y: 359))
            addUserMarker.iconImage = NMF_MARKER_IMAGE_BLACK
            addUserMarker.mapView = uiView.mapView
            
            // 업로드에 위치 정보 넘겨줌
            updateNumber = addUserMarker.position
            naverVM.fetchReverseGeocode(latitude: addUserMarker.position.lat, longitude: addUserMarker.position.lng)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                updateReverseGeocodeResult1 = naverVM.reverseGeocodeResult[0].region.area1.name + " " + naverVM.reverseGeocodeResult[0].region.area2.name + " " +
                naverVM.reverseGeocodeResult[0].region.area3.name
            }
            
            markerAddButtonBool.toggle()
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
