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
    
    @StateObject var mapVM = MapViewModel()
    @StateObject var magazineVM = MagazineViewModel()
    
    @State var categoryString : String = "전체"   // 카테고리 버튼 default : 전체
    
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
    
    @State var moreCategoryButton : Bool = true // 카테고리 더보기 버튼 Bool
    @State var reportButton : Bool = false  // 제보하러가기 버튼 Bool
    
    
    @State var markerAddButtonBool: Bool = false     //???
    @State var changeMap: CGPoint = CGPoint(x: 0, y: 0) // 클러스팅 할때 쓰일 예정
    
    @State var allButtonClickedBool : Bool = false
    
    @State var updateNumber : NMGLatLng = NMGLatLng(lat: 0.0, lng: 0.0)
  
    @State private var isSheetPresented = true

    @State var researchButtonBool : Bool = false
    @State var researchCGPoint : CGPoint = CGPoint(x: Screen.maxWidth * 0.5, y: Screen.maxHeight * 0.5)
    
    @State private var searchFocus : Bool = false
    
    var userLatitude : Double
    var userLongitude : Double
        
    var body: some View {
        VStack{
            
            // MARK: 지도 탭의 상단
            ZStack(alignment: .center){
                
                    HStack{
                        
                        TextField("🔍 ex) 서울시 종로구 사직동", text: $searchText)
                            .padding()
                            .background(.white)
                            .frame(width: Screen.maxWidth * 0.75, height:  Screen.maxHeight * 0.0525)
                            .cornerRadius(15)
                            .onSubmit {
                                // MARK: Geocode API 실행
                                naverVM.fetchGeocode(requestAddress: searchText)
                            }
                            .onTapGesture {
                                searchFocus.toggle()
                                allButtonClickedBool.toggle()
                            }
                            .overlay{
                                // FIXME: onSubmit 하고 버튼 눌러야함
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.black, lineWidth: 3)
                            }.padding()
                        
                        // 검색 확인 버튼
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.black)
                            .frame(width: Screen.maxWidth * 0.125, height:  Screen.maxHeight * 0.0525)
                            .onTapGesture {
                                searchFocus = false
                            }
                            .overlay{
                                Image(systemName: "location.magnifyingglass")
                                    .foregroundColor(.white)
                                    .onTapGesture {
                                        searchResponse = naverVM.addresses
                                        searchResponseBool.toggle()
                                    }
                            }
                            .onTapGesture {
                                searchFocus = false
                            }
                            .padding(.trailing, 10)
                            
                    }
                    .zIndex(1)
                    .position(x: Screen.maxWidth * 0.5 , y: Screen.maxHeight * 0.1)
                    if !searchFocus{
                        HStack{
                            /// 카테고리 버튼 셀 뷰 -> 카테고리 클릭 정보 받아옴
                            if !moreCategoryButton{
                                MapCategoryCellView(categoryString: $categoryString, moreCategoryButton: $moreCategoryButton, reportButton: $reportButton)
                                    .padding(.leading, 7)
                                Spacer()
                            }else{
                                MapCategoryCellView(categoryString: $categoryString, moreCategoryButton: $moreCategoryButton, reportButton: $reportButton)
                                    .padding(.leading, 7)
                                Spacer()
                            }

                        }
                        .zIndex(1)
                        .padding(.leading , 7) // -> 검증 필요
                        .position(x: Screen.maxWidth * 0.5 , y: Screen.maxHeight * 0.17)
                    }
                
                

                
                // MARK: 모달이 띄워질때 뒷 배경 어둡게
                if isShowingWebView {
                    Rectangle()
                        .zIndex(1)
                        .opacity(0.7)
                }
                // MARK: 필름스팟 띄워질때 뒷 배경 어둡게
                if isShowingPhotoSpot{
                    Rectangle()
                        .zIndex(0)
                        .opacity(0.7)
                        .onTapGesture {
                            isShowingPhotoSpot.toggle()
                        }
                }
               
                // MARK:
                if isSheetPresented{
                    // MARK: 지도 뷰
                    /// 카테고리 버튼 별로 해당하는 지도 뷰가 보여줌
                    switch categoryString{
                        
                    case "전체":
                        NavigationStack{
                            UIMapView(mapData: $mapVM.mapData, nearbyPostsArr: $nearbyPostsArr, isShowingPhotoSpot: $isShowingPhotoSpot, isShowingWebView: $isShowingWebView,bindingWebURL:$bindingWebURL, markerAddButtonBool: $markerAddButtonBool,changeMap: $changeMap, searchResponseBool: $searchResponseBool, searchResponse: $searchResponse, researchButtonBool: $researchButtonBool, researchCGPoint: $researchCGPoint, userLatitude: userLatitude , userLongitude: userLongitude)
                                .zIndex(0)
                                
                        }
                    case "필름스팟":
                        NavigationStack{
                            PhotoSpotMapView(mapData: $mapVM.mapData,searchResponseBool: $searchResponseBool,searchResponse: $searchResponse, isShowingPhotoSpot: $isShowingPhotoSpot, magazineData: $magazineVM.magazines, userLatitude: userLatitude , userLongitude: userLongitude)
                                .zIndex(0)
                        }
                    case "현상소":
                        NavigationStack{
                            StationMapView(mapData: $mapVM.mapData, isShowingWebView: $isShowingWebView, searchResponseBool: $searchResponseBool,searchResponse: $searchResponse, userLatitude: userLatitude , userLongitude: userLongitude)
                                .zIndex(0)
                        }
                    case "수리점":
                        NavigationStack{
                            RepairShopMapView(mapData: $mapVM.mapData, isShowingWebView: $isShowingWebView, searchResponseBool: $searchResponseBool,searchResponse: $searchResponse, userLatitude: userLatitude , userLongitude: userLongitude)
                                .zIndex(0)
                        }
                        
                    default:
                        NavigationStack{
                            UIMapView(mapData: $mapVM.mapData, nearbyPostsArr: $nearbyPostsArr, isShowingPhotoSpot: $isShowingPhotoSpot, isShowingWebView: $isShowingWebView,bindingWebURL:$bindingWebURL, markerAddButtonBool: $markerAddButtonBool,changeMap: $changeMap, searchResponseBool: $searchResponseBool, searchResponse: $searchResponse, researchButtonBool: $researchButtonBool, researchCGPoint: $researchCGPoint, userLatitude: userLatitude , userLongitude: userLongitude)
                                .zIndex(0)
                                
                        }
                        
                    }
                }
                else{
                    SearchProgress()
                }
                
                // FIXME: 
                if !isShowingPhotoSpot && !searchFocus {

                    // 이지역 재 검색 버튼
                    RoundedRectangle(cornerRadius: 17)
                        .frame(width: Screen.maxWidth * 0.4, height: 40)
                        .foregroundColor(.black)
                        .overlay{
                            HStack{
                                Image(systemName: "arrow.clockwise")
                                    .foregroundColor(.white)
                                Text("이 지역 재검색")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                            }.onTapGesture {
//                                isSheetPresented.toggle()
                                researchCGPoint = CGPoint(x: Screen.maxWidth * 0.5, y: Screen.maxHeight * 0.44)
                                researchButtonBool.toggle()
                                mapVM.fetchNextPageMap(nextPageToken: "")
                                magazineVM.fetchMagazine()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                                    isSheetPresented.toggle()
                                }
                            }
                            
                        }
                        .position(x: Screen.maxWidth * 0.5 , y: Screen.maxHeight * 0.82)
                }
                
                
                if isShowingPhotoSpot{
                    /// nearbyMagazineData -> NearbyPostsComponent뷰에서 ForEach을 위한 Magazine 데이터
                    /// magazineVM.nearbyPostsFilter메서드 호출 반환 값으로 [MagazineDocument]
                    /// 매개변수로는 contentView에서 전달 받은 magazineData 값 전달 / nearbyPostsArr : 포토스팟 클릭 마커
                    /// 그럼 메서드에서 for in 두번 돌려 필요한 값만 전달
                    /// 이 과정에서 DB 연관 없다고 생각 듬! -> 확인  필요
                    NearbyPostsComponent(visitButton: $visitButton, isShowingPhotoSpot: $isShowingPhotoSpot, nearbyMagazineData: magazineVM.nearbyPostsFilter(magazineData: magazineVM.magazines, nearbyPostsArr: nearbyPostsArr), clikedMagazineData: $clikedMagazineData)
                        .zIndex(1)
                        .position(x: Screen.maxWidth * 0.5 , y: Screen.maxHeight * 0.75)
                        .padding(.leading, nearbyPostsArr.count > 1 ? 0 : 30)   // 포스트 갯수가 1개 이상이면 패딩값 0 아니면 30
                }

            }
            .ignoresSafeArea()
            .ignoresSafeArea(.keyboard)
            .fullScreenCover(isPresented: $visitButton, content: {
                PhotoSpotDetailView(data: clikedMagazineData!)
            })
            .sheet(isPresented: $isShowingWebView) {    // webkit 모달뷰
                WebkitView(bindingWebURL: $bindingWebURL).presentationDetents( [.medium, .large])
                    .background(Color.black.opacity(0.5))   // <- 적용이 안된듯
            }
            .fullScreenCover(isPresented: $reportButton) {
                ReportMapView(updateNumber: $updateNumber, userLatitude: userLatitude , userLongitude: userLongitude) // 제보하러 가기 모달 뷰
            }
        }
        .onAppear{
            mapVM.fetchNextPageMap(nextPageToken: "")
            magazineVM.fetchMagazine()
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
    //모달뷰
    @Binding var isShowingPhotoSpot: Bool
    
    @Binding var isShowingWebView: Bool
    @Binding var bindingWebURL : String
    
    @Binding var markerAddButtonBool: Bool
    @Binding var changeMap: CGPoint
    
    @Binding var searchResponseBool: Bool
    @Binding var searchResponse : [Address]
    
    @Binding var researchButtonBool : Bool
    @Binding var researchCGPoint : CGPoint
    
    var userLatitude : Double
    var userLongitude : Double

    
    // UIView 기반 컴포넌트의 인스턴스 생성하고 필요한 초기화 작업을 수행한 뒤 반환한다.
    func makeUIView(context: Context) -> NMFNaverMapView {
        // MARK: 네이버 맵 지도 생성
        let view = NMFNaverMapView()
        view.showZoomControls = false
        view.mapView.positionMode = .direction
        
        /// 숫자가 작을수록 축소 , 숫자가 클수록 확대
        view.mapView.zoomLevel = 12
        view.mapView.minZoomLevel = 10
        view.mapView.maxZoomLevel = 16
        view.mapView.isRotateGestureEnabled = false // 지도 회전 잠금
        
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
            for item in mapData{
                let marker = NMFMarker()
                marker.position = NMGLatLng(lat: item.fields.latitude.doubleValue, lng: item.fields.longitude.doubleValue)
                switch item.fields.category.stringValue{
                case "필름스팟":
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
                case "현상소":
                    marker.iconImage = NMFOverlayImage(name: "stationMarker")
                    marker.width = 25
                    marker.height = 25
                    // MARK: 아이콘 캡션 - 현상소 글씨
                    marker.captionText = item.fields.category.stringValue
                    marker.captionColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1)
                    marker.captionTextSize = 9
                    marker.captionHaloColor = UIColor(.white)
                    marker.userInfo = ["url" :  item.fields.url.stringValue]
                    marker.tag = 1
                case "수리점":
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
                            isShowingPhotoSpot = false
                            bindingWebURL = marker.userInfo["url"] as! String
                        case 2: //수리점
                            isShowingWebView.toggle()
                            isShowingPhotoSpot = false
                            bindingWebURL = marker.userInfo["url"] as! String
                        default:    //없음
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
        // 연구 중
        //        print(changeMap)
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
                marker.captionColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1)
                marker.captionTextSize = 9
                marker.captionHaloColor = UIColor(.gray)
                
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
        }
//        if researchButtonBool{
//            switch uiView.mapView.zoomLevel{
//            case 12...16:
//                print("줌레벨 측정 : \(uiView.mapView.zoomLevel)")
//                return
//            case 10..<12:
//                print("줌레벨 측정 : \(uiView.mapView.zoomLevel)")
//                return
//            default:
//                return
//            }
//        }
//        /// 숫자가 작을수록 축소 , 숫자가 클수록 확대
//        view.mapView.zoomLevel = 12
//        view.mapView.minZoomLevel = 10
//        view.mapView.maxZoomLevel = 16
        
    }
    
    func makeCoordinator() -> Coordinator {
        //임시
        return Coordinator(viewModel: self.viewModel, markerAddButtonBool: $markerAddButtonBool,changeMap: $changeMap)
        //        return Coordinator(markerAddButtonBool: $markerAddButtonBool, markerPoint: $markerPoint)
    }

    
    
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
//        print("\(latlng.lat), \(latlng.lng)")
//        print(point)
        
        
    }
    
}
//
class MapSceneViewModel: ObservableObject {

}
