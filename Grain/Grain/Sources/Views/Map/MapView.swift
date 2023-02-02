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
    @State var markerAddButtonBool: Bool = false
    @State var changeMap: CGPoint = CGPoint(x: 0, y: 0)

    var body: some View {
        NavigationStack{
            // MARK: 지도 탭의 상단
            ZStack{
                VStack{
                    HStack{
                        // FIXME: onSubmit 하고 버튼 눌러야함
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(.black),lineWidth: 2)
                            .frame(width: Screen.maxWidth * 0.8, height: 40)
                            .overlay{
                                TextField("🔍 위치를 검색해주세요", text: $searchText)
                                    .padding()
                                    .onSubmit {
         
                                    }
                            }
                        Button{
 
                        } label: {
                            Image(systemName: "chevron.right.circle.fill")
                                .foregroundColor(.black)
                                .font(.title2)
                        }
                        Button{
 
                        } label: {
                            Image(systemName: "arrow.clockwise")
                                .foregroundColor(.black)
                                .font(.title2)
                        }
                        
                    }.padding()
                    HStack{
                        /// 카테고리 버튼 셀 뷰 -> 카테고리 클릭 정보 받아옴
                        MapCategoryCellView(categoryString: $categoryString)
                    }
                }
                .zIndex(1)
                .offset(y:-250)
                
                // MARK: 지도 뷰
                /// 카테고리 버튼 별로 해당하는 지도 뷰가 보여줌
                switch categoryString{
                case "전체":
                    UIMapView(isShowingPhotoSpot: $isShowingPhotoSpot,isShowingWebView: $isShowingWebView,bindingWebURL:$bindingWebURL, markerAddButtonBool: $markerAddButtonBool,changeMap: $changeMap)
                        .zIndex(0)

                case "포토스팟":
                    PhotoSpotMapView().zIndex(0)
                case "현상소":
                    StationMapView().zIndex(0)
                case "수리점":
                    RepairShopMapView().zIndex(0)
                default:
                    UIMapView(isShowingPhotoSpot: $isShowingPhotoSpot,isShowingWebView: $isShowingWebView,bindingWebURL:$bindingWebURL, markerAddButtonBool: $markerAddButtonBool,changeMap: $changeMap).zIndex(0)
                }
            }
            .sheet(isPresented: $isShowingPhotoSpot, content: {
                PhotoSpotDetailView() .presentationDetents( [.medium])  /// 모달 뷰 medium으로 보여주기
            })
            .sheet(isPresented: $isShowingWebView) {
                WebkitView(bindingWebURL: $bindingWebURL)
            }
        }
    }
}


// FIXME: 네이버 지도
// 네이버 지도를 띄울 수 있게끔 만들어주는 코드들 <- 연구가 필요!! 이해 완료 후 주석 달아보기
struct UIMapView: UIViewRepresentable,View {
    //임시
    @ObservedObject var viewModel = MapSceneViewModel()
    @StateObject var locationManager = LocationManager()
    
    @ObservedObject var mapStore = MapStore()
    @EnvironmentObject var viewRouter: ViewRouter
    //모달뷰
    @Binding var isShowingPhotoSpot: Bool
    @Binding var isShowingWebView: Bool
    @Binding var bindingWebURL : String
    
    @Binding var markerAddButtonBool: Bool
    @Binding var changeMap: CGPoint
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
        // 처음에 맵이 생성될떄 줌 레벨
        // 숫자가 작을수록 축소
        // 숫자가 클수록 확대
        view.mapView.zoomLevel = 12
        // TODO: 최대 최소 줌 레벨 알아보기
        view.mapView.minZoomLevel = 10
        view.mapView.maxZoomLevel = 16
        // MARK: 지도 회전 잠금
        view.mapView.isRotateGestureEnabled = false
        //        view.mapView.mapType = .hybrid
        // MARK: 델리게이트 패턴 채택
        /// 임시 주석
        view.mapView.touchDelegate = context.coordinator
        
        // MARK: 네이버 지도 나침판, 현재 유저 위치 GPS 버튼
        view.showCompass = false
        view.showLocationButton = true
        // MARK: 위치 정보 받아오기
        view.showLocationButton = true
        view.mapView.positionMode = .direction
        
        // MARK: 지도가 그려질때 현재 유저 GPS 위치로 카메라 움직임
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: userLatitude, lng: userLongitude))
        view.mapView.moveCamera(cameraUpdate)
        
        // MARK: MAP DB에 들어간 정보
        var markers: [MarkerCustomInfo] = []
        
        /// 굳이 따로 markers를 만들어서 넣어줄 필요가 없어 보임
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            for i in mapStore.mapData{
                let object : MarkerCustomInfo = MarkerCustomInfo(marker: NMGLatLng(lat: i.latitude, lng: i.longitude), category: i.category ?? 4, url: i.url)
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
                    // MARK: URL링크 정보 받기
                    marker.userInfo = ["url" : item.url]
                    // MARK: 마커에 태그 번호 생성 -> 마커 클릭시에 사용됨
                    marker.tag = 0
                    
                case 1:
                    marker.iconImage = NMF_MARKER_IMAGE_RED
                    // MARK: 아이콘 캡션 - 현상소 글씨
                    marker.captionText = "현상소"
                    marker.userInfo = ["url" : item.url]
                    marker.tag = 1
                case 2:
                    marker.iconImage = NMF_MARKER_IMAGE_YELLOW
                    // MARK: 아이콘 캡션 - 수리점 글씨
                    marker.captionText = "수리점"
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
                            bindingWebURL = marker.userInfo["url"] as! String
                        case 2:
                            print("수리점 클릭")
                            isShowingWebView.toggle()
                            bindingWebURL = marker.userInfo["url"] as! String
                        default:
                            print("없음")
                        }
                    }
                    return true
                }
                marker.mapView = view.mapView
                
            }
        }
        
        // TODO: 클러스팅 비슷한 동작 해보기
        var sectionArray : [CGPoint] = [
            CGPoint(x: 65, y: 90),  //1
            CGPoint(x: 195, y: 90),  //2
            CGPoint(x: 325, y: 90),  //3
            
            CGPoint(x: 65, y: 270),  //4
            CGPoint(x: 195, y: 270),  //5
            CGPoint(x: 325, y: 270),  //6
            
            CGPoint(x: 65, y: 450),  //7
            CGPoint(x: 195, y: 450),  //8
            CGPoint(x: 325, y: 450)  //9
        ]
        var sectionRepresentMarker : [SectionMarkerInfo] = []
        
        // 생성될떄 받아옴
        changeMap = view.mapView.projection.point(from: NMGLatLng(lat: userLatitude, lng: userLongitude))
        
        func zoning(){
            // 9개 구역 나누기
            // index는 구역 번호
            var index : Int = 1
            for i in sectionArray{
                countingMarker(i,index)
                index += 1
            }
            func countingMarker(_ point: CGPoint, _ index: Int){
                var sectionMarkerCount : Int = 0
                // withTolerance 거리가 pt단위인데 원인지 사각형인지 모르겠음
                /// 거리 조정 해야 할듯
                for pickable in view.mapView.pickAll(point, withTolerance: 45){
                    if let marker = pickable as? NMFMarker{
                        sectionMarkerCount += 1
                        //  마커 잠시 불투명하게 만들기
                        marker.alpha = 0
                    }
                }
                // 구역 별로 마커 갯구 배열에 넣기
                let sectionMarkerInfo = SectionMarkerInfo(point: point, count: sectionMarkerCount, index: index)
                sectionRepresentMarker.append(sectionMarkerInfo)
            }
            
            for i in sectionRepresentMarker{
                let sectionCountMarker = NMFMarker()
                if i.count < 1 {
                    continue
                }else{
                    sectionCountMarker.position = view.mapView.projection.latlng(from: i.point)
                    sectionCountMarker.iconImage = NMF_MARKER_IMAGE_BLACK
                    sectionCountMarker.captionText =  String(i.count)
                    sectionCountMarker.captionAligns =  [NMFAlignType.top]
                    
                    sectionCountMarker.touchHandler = { (overlay) in
                        if view.mapView.zoomLevel > 12{
                            for pickable in view.mapView.pickAll(i.point, withTolerance: 45){
                                if let marker = pickable as? NMFMarker{
                                    marker.alpha = 1
                                    sectionCountMarker.mapView = nil
                                }
                            }
                        }

                        return true
                    }
                    sectionCountMarker.mapView = view.mapView
                }
                
            }
        }
        // 시간 조정 해야됨
        /// 마커들이 많아지면 ;;
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
            if view.mapView.zoomLevel <= 12{
                zoning()
            }
            else{
                print("else")
            }
            
            //
        }
        
        
        return view
    }
    
    // UIView 자체를 업데이트 해야 하는 변경이 swiftui 뷰에서 생길떄 마다 호출된다.
    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {
        // 연구 중
        print(changeMap)
    }

    func makeCoordinator() -> Coordinator {
        //임시
        return Coordinator(viewModel: self.viewModel, markerAddButtonBool: $markerAddButtonBool,changeMap: $changeMap)
        //        return Coordinator(markerAddButtonBool: $markerAddButtonBool, markerPoint: $markerPoint)
    }
    
    // MARK: 주변 게시글 적용
    // TODO: 나중에 적용해보기
    //    print(context.coordinator.point)
    //    func findAroundPost(_ mapView: NMFMapView,_ point: CGPoint){
    //        var testStr = ""
    //        for pickable in mapView.pickAll(point, withTolerance: 30){
    //            if let marker = pickable as? NMFMarker{
    //                testStr = testStr + "Marker(\(marker.captionText ?? ""))\n"
    //            }
    //            print(testStr)
    //        }
    //    }
    
    
}
// 이벤트에 반응해야 하는 뷰들은 코디네이터 구현 해야함
class Coordinator: NSObject, NMFMapViewTouchDelegate, NMFMapViewCameraDelegate, NMFMapViewOptionDelegate {
    // 임시
    @ObservedObject var viewModel: MapSceneViewModel
    @Published var latitude : Double
    @Published var longitude : Double
    @Published var point : CGPoint
    init(viewModel: MapSceneViewModel,markerAddButtonBool: Binding<Bool>,changeMap: Binding<CGPoint>) {
        self.viewModel = viewModel
        self.latitude = 0.0
        self.longitude = 0.0
        self.point = CGPoint(x: 0, y: 0)
        self._markerAddButtonBool = markerAddButtonBool
        self._changeMap = changeMap
    }
    //     잠시
    var cancellable = Set<AnyCancellable>()
    
    
    //바인딩 할 값 넣기
    @Binding var markerAddButtonBool : Bool  // 추가하기 true false
    @Binding var changeMap : CGPoint
    //    init(markerAddButtonBool: Binding<Bool>){
    //        self._markerAddButtonBool = markerAddButtonBool
    //    }
    
    // MARK: 터치 했을때 실행
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        // 임시
        self.latitude = latlng.lat
        self.longitude = latlng.lng
        self.point = point
        print("\(latlng.lat), \(latlng.lng)")
        print(point)
        
        ///맵 누르면 버튼 생김
        //        let currentUserMarker = NMFMarker()
        //        currentUserMarker.position = NMGLatLng(lat: latitude, lng: longitude)
        //        currentUserMarker.iconImage = NMF_MARKER_IMAGE_BLACK
        //        currentUserMarker.mapView = mapView
        // 해당 좌표로 이동하기 카메라
        //        mapView.moveCamera(NMFCameraUpdate(scrollTo: NMGLatLng(lat: latitude, lng: longitude)))
        //        marker.position = NMGLatLng(lat: latitude, lng: longitude)
        //        print("marker.overlayID\(marker.overlayID)")
        //        marker.position = NMGLatLng(lat: latitude, lng: longitude)
        //        marker.mapView = mapView
        //        print(marker.position)
        
        // 화면 클릭시 CGRect 생성
        //        let customView = UIView(frame: CGRect(origin:point, size: CGSize(width: 50, height: 50)))
        //        customView.backgroundColor = .clear
        //
        //        mapView.addSubview(customView)
        
        // 폴리곤
        //        let polygonOverlay = NMFPolygonOverlay([
        //            view.mapView.projection.latlng(from: CGPoint(x: 70, y: 600)),
        //            view.mapView.projection.latlng(from: CGPoint(x: 310, y: 600)),
        //            view.mapView.projection.latlng(from: CGPoint(x: 310, y: 650)),
        //            view.mapView.projection.latlng(from: CGPoint(x: 70, y: 650)),
        //            ])
        //
        //        polygonOverlay?.mapView = view.mapView
        
    }
    
    
    
    
}

class MapSceneViewModel: ObservableObject {
    
}

struct SectionMarkerInfo {
    var point : CGPoint
    var count : Int
    var index : Int
}
