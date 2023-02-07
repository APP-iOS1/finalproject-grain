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
    
    
    @StateObject var magazineVM = MagazineViewModel()
    @Binding var magazineData: [MagazineDocument]   //매거진 데이터 전달 받기
    
    @Binding var mapData: [MapDocument]         // 맵 데이터 전달 받기
    
    
    @State var categoryString : String = "전체"   // 카테고리 버튼 default : 전체
    
    //중단
    @EnvironmentObject var viewRouter: ViewRouter
    
    
    @StateObject var naverVM = NaverAPIViewModel()  // 네이버 API 관련
    @State var searchResponse : [Address] = [Address(roadAddress: "", jibunAddress: "", englishAddress: "", x: "", y: "", distance: 0)]
    
    @State private var searchText = ""          // 위치를 검색해주세요 텍스트 필드
    
    @State var clikedMagazineData : MagazineDocument?   //까먹음
    
    @State var visitButton : Bool = false   // 포토스팟 방문 했는지 판단으로 생각 됨 ???!!
    
    @State var nearbyPostsArr : [String] = [] //주변 게시물 저장
    @State var isShowingPhotoSpot: Bool = false // 주변 게시물 보여주는 Bool
    
    @State var isShowingWebView: Bool = false   // 현상소, 수리점 모달 띄워주는 Bool
    @State var bindingWebURL : String = ""      // UIMapView 에서 마커에서 나오는 정보 가져오기 위해
    
    @State var searchResponseBool : Bool = false    // 검색하기 버튼 Bool
    
    @State var markerAddButtonBool: Bool = false     //???
    @State var changeMap: CGPoint = CGPoint(x: 0, y: 0) // 클러스팅 할때 쓰일 예정
    
    
    
    var body: some View {
        NavigationStack{
            // MARK: 지도 탭의 상단
            ZStack(alignment: .center){
                VStack{
                    HStack{
                        // FIXME: onSubmit 하고 버튼 눌러야함
                        TextField("🔍 위치를 검색해주세요", text: $searchText)
                            .padding()
                            .background(.white)
                            .cornerRadius(15)
                            .onSubmit {
                                // MARK: Geocode API 실행
                                naverVM.fetchGeocode(requestAddress: searchText)
                                
                            }
                        
                        RoundedRectangle(cornerRadius: 10)
//                            .stroke(Color(.black),lineWidth: 2)
                            .foregroundColor(.white)
                            .frame(width: 50, height: 51)
                            .overlay{
                                Image(systemName: "location.magnifyingglass")
                                    .onTapGesture {
                                        searchResponse = naverVM.addresses
                                        searchResponseBool.toggle()
                                    }
                            }
                    }.padding()
                    
                    HStack{
                        /// 카테고리 버튼 셀 뷰 -> 카테고리 클릭 정보 받아옴
                        MapCategoryCellView(categoryString: $categoryString)
                    }.padding(.leading , 7) // -> 검증 필요
                }
                .zIndex(1)
                .offset(y:-250)
                
                // MARK: 지도 뷰
                /// 카테고리 버튼 별로 해당하는 지도 뷰가 보여줌
                switch categoryString{
                case "전체":
                    UIMapView(mapData: $mapData, nearbyPostsArr: $nearbyPostsArr, isShowingPhotoSpot: $isShowingPhotoSpot, isShowingWebView: $isShowingWebView,bindingWebURL:$bindingWebURL, markerAddButtonBool: $markerAddButtonBool,changeMap: $changeMap)
                        .zIndex(0)

                case "포토스팟":
                    PhotoSpotMapView(mapData: $mapData)
                        .zIndex(0)
                case "현상소":
                    StationMapView(mapData: $mapData)
                        .zIndex(0)
                case "수리점":
                    RepairShopMapView(mapData: $mapData)
                        .zIndex(0)
                default:
                    UIMapView(mapData: $mapData, nearbyPostsArr: $nearbyPostsArr, isShowingPhotoSpot: $isShowingPhotoSpot, isShowingWebView: $isShowingWebView,bindingWebURL:$bindingWebURL, markerAddButtonBool: $markerAddButtonBool,changeMap: $changeMap)
                        .zIndex(0)
                }
                
                // 이지역 재 검색 버튼
                RoundedRectangle(cornerRadius: 17)
                    .frame(width: Screen.maxWidth * 0.4, height: 40)
//                            .stroke(Color(.black),lineWidth: 2)
                    .foregroundColor(.white)
                    .overlay{
                        HStack{
                            Image(systemName: "arrow.clockwise")
                            Text("이 지역 재검색")
                                .fontWeight(.bold)
                        }.onTapGesture {
                            // 액션
                        }
                       
                    }
                .offset(y:280)
                
             
                if isShowingPhotoSpot{
                    /// nearbyMagazineData -> NearbyPostsComponent뷰에서 ForEach을 위한 Magazine 데이터
                    /// magazineVM.nearbyPostsFilter메서드 호출 반환 값으로 [MagazineDocument]
                    /// 매개변수로는 contentView에서 전달 받은 magazineData 값 전달 / nearbyPostsArr : 포토스팟 클릭 마커
                    /// 그럼 메서드에서 for in 두번 돌려 필요한 값만 전달
                    /// 이 과정에서 DB 연관 없다고 생각 듬! -> 확인  필요
                    NearbyPostsComponent(visitButton: $visitButton, isShowingPhotoSpot: $isShowingPhotoSpot, nearbyMagazineData: magazineVM.nearbyPostsFilter(magazineData: magazineData, nearbyPostsArr: nearbyPostsArr), clikedMagazineData: $clikedMagazineData)
                        .offset(x:40,y: 250)
                    //  FIXME: offset x:40 없애기 화면상에서 가운데 정렬 시켜야함
                }

                
            }
            .fullScreenCover(isPresented: $visitButton, content: {
                PhotoSpotDetailView(data: clikedMagazineData!)
            })
            .sheet(isPresented: $isShowingWebView) {    // webkit 모달뷰
                WebkitView(bindingWebURL: $bindingWebURL).presentationDetents( [.medium])
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

    @Binding var mapData: [MapDocument] // 맵 데이터 전달 받기
    
    //FIXME: Set으로 만들어보기
//    var nearbyPostsArr = Set<String>()
    @Binding var nearbyPostsArr : [String]  //주변 게시물 저장
    
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
//        view.showCompass = false
        // MARK: 위치 정보 받아오기
//        view.showLocationButton = true
        
        view.mapView.positionMode = .direction
        
        // MARK: 지도가 그려질때 현재 유저 GPS 위치로 카메라 움직임
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: userLatitude, lng: userLongitude))
        view.mapView.moveCamera(cameraUpdate)
        
        
        // TODO: 마커를 MarkerCustomInfo형식 배열로 만들꺼면 효율 좋은 사용법 찾아내기
//        var markers: [MarkerCustomInfo] = []
//        for i in mapData{
//            let object : MarkerCustomInfo = MarkerCustomInfo(marker: NMGLatLng(lat: i.fields.latitude.doubleValue, lng: i.fields.longitude.doubleValue), category: 1, url: i.fields.url.stringValue)
//            markers.append(object)
//        }
        // MARK: 사용 중단 코드 mapStore 방식
        /// 굳이 따로 markers를 만들어서 넣어줄 필요가 없어 보임
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
//            for i in mapStore.mapData{
//                let object : MarkerCustomInfo = MarkerCustomInfo(marker: NMGLatLng(lat: i.latitude, lng: i.longitude), category: i.category ?? 4, url: i.url)
//                markers.append(object)
//            }
//        }
        
        
        // MARK: Combine 이용 Content뷰에서 처음에 불러온 데이터 고정
        // MARK: Map 컬렉션 DB에서 위치 정보를 받아와 마커로 표시
        for item in mapData{
            let marker = NMFMarker()
            marker.position = NMGLatLng(lat: item.fields.latitude.doubleValue, lng: item.fields.longitude.doubleValue)
            switch item.fields.category.stringValue{
            case "포토스팟":
                marker.iconImage = NMF_MARKER_IMAGE_PINK
                marker.width = 25
                marker.height = 35
                // MARK: 아이콘 캡션 - 포토스팟 글씨
                marker.captionText = item.fields.category.stringValue
                // MARK: URL링크 정보 받기
                marker.userInfo = ["magazine": item.fields.magazineID.arrayValue.values[0].stringValue]
                // MARK: 마커에 태그 번호 생성 -> 마커 클릭시에 사용됨
                marker.tag = 0
            case "현상소":
                marker.iconImage = NMF_MARKER_IMAGE_RED
                marker.width = 25
                marker.height = 35
                // MARK: 아이콘 캡션 - 현상소 글씨
                marker.captionText = item.fields.category.stringValue
                marker.userInfo = ["url" :  item.fields.url.stringValue]
                marker.tag = 1
            case "수리점":
                marker.iconImage = NMF_MARKER_IMAGE_YELLOW
                marker.width = 25
                marker.height = 35
                // MARK: 아이콘 캡션 - 수리점 글씨
                marker.captionText = item.fields.category.stringValue
                marker.userInfo = ["url" :  item.fields.url.stringValue]
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
                    case 0: //포토스팟
                        // MARK: 포토스팟 컴포넌트 띄워주기
                        isShowingPhotoSpot.toggle()
                        nearbyPostsArr.removeAll()
                        for pickable in view.mapView.pickAll(view.mapView.projection.point(from: NMGLatLng(lat: marker.position.lat, lng: marker.position.lng)), withTolerance: 30){
                            if let marker = pickable as? NMFMarker{
                                if marker.tag == 0 {
                                    nearbyPostsArr.append(marker.userInfo["magazine"] as! String)
                                }
                            }
                        }
                    case 1: //현상소
                        isShowingWebView.toggle()
                        bindingWebURL = marker.userInfo["url"] as! String
                    case 2: //수리점
                        isShowingWebView.toggle()
                        bindingWebURL = marker.userInfo["url"] as! String
                    default:    //없음
                        print("없음")
                    }
                }
                return true
            }
            marker.mapView = view.mapView
        }
        

        // MARK: 포토스팟 마커 클릭시 주변 게시글
       
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
        
        
        // TODO: 클러스팅 비슷한 동작 해보기
//        var sectionArray : [CGPoint] = [
//            CGPoint(x: 65, y: 90),  //1
//            CGPoint(x: 195, y: 90),  //2
//            CGPoint(x: 325, y: 90),  //3
//
//            CGPoint(x: 65, y: 270),  //4
//            CGPoint(x: 195, y: 270),  //5
//            CGPoint(x: 325, y: 270),  //6
//
//            CGPoint(x: 65, y: 450),  //7
//            CGPoint(x: 195, y: 450),  //8
//            CGPoint(x: 325, y: 450)  //9
//        ]
//        var sectionRepresentMarker : [SectionMarkerInfo] = []
//
//        // 생성될떄 받아옴
//        changeMap = view.mapView.projection.point(from: NMGLatLng(lat: userLatitude, lng: userLongitude))
//
//        func zoning(){
//            // 9개 구역 나누기
//            // index는 구역 번호
//            var index : Int = 1
//            for i in sectionArray{
//                countingMarker(i,index)
//                index += 1
//            }
//            func countingMarker(_ point: CGPoint, _ index: Int){
//                var sectionMarkerCount : Int = 0
//                // withTolerance 거리가 pt단위인데 원인지 사각형인지 모르겠음
//                /// 거리 조정 해야 할듯
//                for pickable in view.mapView.pickAll(point, withTolerance: 45){
//                    if let marker = pickable as? NMFMarker{
//                        sectionMarkerCount += 1
//                        //  마커 잠시 불투명하게 만들기
//                        marker.alpha = 0
//                    }
//                }
//                // 구역 별로 마커 갯구 배열에 넣기
//                let sectionMarkerInfo = SectionMarkerInfo(point: point, count: sectionMarkerCount, index: index)
//                sectionRepresentMarker.append(sectionMarkerInfo)
//            }
//
//            for i in sectionRepresentMarker{
//                let sectionCountMarker = NMFMarker()
//                if i.count < 1 {
//                    continue
//                }else{
//                    sectionCountMarker.position = view.mapView.projection.latlng(from: i.point)
//                    sectionCountMarker.iconImage = NMF_MARKER_IMAGE_BLACK
//                    sectionCountMarker.captionText =  String(i.count)
//                    sectionCountMarker.captionAligns =  [NMFAlignType.top]
//
//                    sectionCountMarker.touchHandler = { (overlay) in
//                        if view.mapView.zoomLevel > 12{
//                            for pickable in view.mapView.pickAll(i.point, withTolerance: 45){
//                                if let marker = pickable as? NMFMarker{
//                                    marker.alpha = 1
//                                    sectionCountMarker.mapView = nil
//                                }
//                            }
//                        }
//
//                        return true
//                    }
//                    sectionCountMarker.mapView = view.mapView
//                }
//
//            }
//        }
//        // 시간 조정 해야됨
//        /// 마커들이 많아지면 ;;
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
//            if view.mapView.zoomLevel <= 12{
//                zoning()
//            }
//            else{
//                print("else")
//            }
//
//            //
//        }
        
        
        return view
    }
    
    // UIView 자체를 업데이트 해야 하는 변경이 swiftui 뷰에서 생길떄 마다 호출된다.
    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {
        // 연구 중
//        print(changeMap)
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
