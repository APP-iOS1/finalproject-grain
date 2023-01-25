//
//  MapView.swift
//  Grain
//
//  Created by 조형구 on 2023/01/18.
//

import SwiftUI
import CoreLocation
import NMapsMap
import Combine
import UIKit

struct MapView: View {
    
    @State private var searchText = ""
    @ObservedObject var mapStore = MapStore()
    
    @State var categoryString : String = "전체"  /// 초기값 설정
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    @State var isShowingPhotoSpot: Bool = false
    @State var isShowingWebView: Bool = false
    @State var bindingWebURL : String = ""
    
    var body: some View {
        NavigationStack{
            Button {
                isShowingWebView.toggle()
            } label: {
                Text("테스트")
            }.sheet(isPresented: $isShowingWebView) {
                WebkitView(bindingWebURL: $bindingWebURL)
            }

            // MARK: 지도 탭의 상단
            VStack{
                // MARK: 지도 카테고리 버튼
                // TODO: 포토스팟, 현상소, 수리점 셀뷰로 만들기
                HStack{
                    /// 카테고리 버튼 셀 뷰 -> 카테고리 클릭 정보 받아옴
                    MapCategoryCellView(categoryString: $categoryString)
                    
                }
            }
            // MARK: 지도 뷰에서 검색 란
            /// https://ios-development.tistory.com/1124 참고 자료 <- 리팩토링 할때 다시 읽어보기
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "검색 placholder..."
            )
            // searchable에서 완료 버튼을 누를시 액션
            .onSubmit(of: .search) {
                print("검색 완료: \(searchText)")
            }
            
            ZStack{
                // MARK: 지도 뷰
                /// 카테고리 버튼 별로 해당하는 지도 뷰가 보여줌
                switch categoryString{
                case "전체":
                    UIMapView(isShowingPhotoSpot: $isShowingPhotoSpot,isShowingWebView: $isShowingWebView,bindingWebURL:$bindingWebURL)
                case "포토스팟":
                    PhotoSpotMapView()
                case "현상소":
                    StationMapView()
                case "수리점":
                    RepairShopMapView()
                default:
                    UIMapView(isShowingPhotoSpot: $isShowingPhotoSpot,isShowingWebView: $isShowingWebView,bindingWebURL:$bindingWebURL)
                    
                }
            }
//            .sheet(isPresented: $isShowingPhotoSpot) {
//                PhotoSpotDetailView()
//            }
//            .sheet(isPresented: $isShowingWebView) {
//                WebkitView(urlToLoad: bindingWebURL)
//            }
            // MARK: 상단 클릭 가능 버튼
            .toolbar {  //MARK: 홈으로 돌아가기?? <- 회의 필요
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        
                    } label: {
                        Text("Grain")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }
                }
            }
            .toolbar {  //MARK: 제보하기 <- 회의 필요
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
struct UIMapView: UIViewRepresentable,View {
    
    @ObservedObject var viewModel = MapSceneViewModel()
    @StateObject var locationManager = LocationManager()
    
    @ObservedObject var mapStore = MapStore()
    @EnvironmentObject var viewRouter: ViewRouter
    
    //모달뷰
    @Binding var isShowingPhotoSpot: Bool
    @Binding var isShowingWebView: Bool
    @Binding var bindingWebURL : String
    
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
        // TODO: 최대 최소 줌 레벨 알아보기
        view.mapView.minZoomLevel = 10
        view.mapView.maxZoomLevel = 16
        // MARK: 지도 회전 잠금
        view.mapView.isRotateGestureEnabled = false
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
        
        /// 굳이 따로 markers를 만들어서 넣어줄 필요가 없어 보임
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            for i in mapStore.mapData{
                let object : MarkerCustomInfo = MarkerCustomInfo(marker: NMGLatLng(lat: i.latitude, lng: i.longitude), category: i.category ?? 4, url: i.url)
                print(object)
                markers.append(object)
            }
        }
        
        // TODO: 비동기적으로 코드 수정 필요함! , 마커 대신 이미지 사진, 글씨로 대체해야함
        // MARK: Map 컬렉션 DB에서 위치 정보를 받아와 마커로 표시
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            for item in markers{
                let marker = NMFMarker()
                marker.position = item.marker
                switch item.category{
                case 0:
                    marker.iconImage = NMF_MARKER_IMAGE_PINK
                    // MARK: 아이콘 캡션 - 포토스팟 글씨
                    marker.captionText = "포토스팟"
                    // FIXME: 카테고리 필터링 기능에 쓸 예정이지만 실패 다른 기능에 사용해보기
                    marker.userInfo = ["url" : item.url]
                    // MARK: 마커에 태그 번호 생성 -> 마커 클릭시에 사용됨
                    marker.tag = 0
                    
                case 1:
                    marker.iconImage = NMF_MARKER_IMAGE_RED
                    // MARK: 아이콘 캡션 - 현상소 글씨
                    marker.captionText = "현상소"
                    // FIXME: 카테고리 필터링 기능에 쓸 예정이지만 실패 다른 기능에 사용해보기
                    marker.userInfo = ["url" : item.url]
                    marker.tag = 1
                case 2:
                    marker.iconImage = NMF_MARKER_IMAGE_YELLOW
                    // MARK: 아이콘 캡션 - 수리점 글씨
                    marker.captionText = "수리점"
                    // FIXME: 카테고리 필터링 기능에 쓸 예정이지만 실패 다른 기능에 사용해보기
                    marker.userInfo = ["url" : item.url]
                    marker.tag = 2
                    // MARK: 캡션 글씨 색상 컬러
                    // TODO: 디자인 고려해보기
                    //                    marker.captionColor = UIColor.blue
                    //                    marker.captionHaloColor = UIColor(red: 200.0/255.0, green: 1, blue: 200.0/255.0, alpha: 1)
                default:
                    marker.iconImage = NMF_MARKER_IMAGE_BLACK
                }
                
                
                // MARK: 마커 클릭시
                marker.touchHandler = { (overlay) in
                    if let marker = overlay as? NMFMarker {
                        switch marker.tag{
                        case 0:
                            print("포토스팟 클릭")
                            // MARK: 포토스팟 모달 띄워주기
                            isShowingPhotoSpot.toggle()
                        case 1:
                            print("현상소 클릭")
                            isShowingWebView.toggle()
                            // TODO: 고치기
                            bindingWebURL = marker.userInfo["url"] as! String
                        case 2:
                            print("수리점 클릭")
                           
                            // TODO: 고치기
                            bindingWebURL = marker.userInfo["url"] as! String
                            isShowingWebView.toggle()
                        default:
                            print("없음")
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
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(viewModel: self.viewModel)
    }
    
}
// 이벤트에 반응해야 하는 뷰들은 코디네이터 구현 해야함
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
    
    // MARK:  지도 좌표 알아내기
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        print("\(latlng.lat), \(latlng.lng)")
        self.latitude = latlng.lat
        self.longitude = latlng.lng
    }
}


class MapSceneViewModel: ObservableObject {}
