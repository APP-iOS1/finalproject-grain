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
import FirebaseAuth


struct AddMarkerMapView: View {
    
    @StateObject var naverVM = NaverAPIViewModel()  // 네이버 API 관련
    
    @ObservedObject var magazineVM : MagazineViewModel
    @ObservedObject var userVM : UserViewModel
    @ObservedObject var mapVM : MapViewModel
    @ObservedObject var locationManager : LocationManager
    
    @State var reMarkerAddButtonBool : Bool = false
    @State var markerAddButtonBool : Bool = false
    @State var locationcheckBool : Bool = false
    @State var searchResponseBool : Bool = false
    @State var writeDownCustomPlaceAlert : Bool = false
    @State var writeDownCustomPlaceCheck : Bool = false
    @State var writeDownCustomPlaceText : String = ""
    
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
    
    // 위치 검색 결과 값
    @State var searchResponse : [Address] = [Address(roadAddress: "", jibunAddress: "", englishAddress: "", x: "", y: "", distance: 0)]
    
    @State var updateReverseGeocodeResult :  [ReverseGeocodeResult] = [ReverseGeocodeResult(region: Region(area1: Area(name: ""), area2: Area(name: ""), area3: Area(name: ""), area4: Area(name: "")))]
    
    @Binding var inputTitle: String
    @Binding var inputContent: String
    @Binding var selectedImages: [UIImage]
    @Binding var inputCustomPlace: String
    @Binding var presented : Bool
    
    @Binding var selectedCamera: String
    @Binding var selectedLense: String
    @Binding var selectedFilm: String
    
    @State var isDragging = false
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State private var showingAlert = false
    @State private var isFinishedSpot = false
    @State private var isShowingSearchProgress = false
    
    @State private var isUpdateMagazineSuccess: Bool = false
    @State private var isClickedSubmitButton: Bool = false
    
    var userLatitude: Double
    var userLongitude: Double
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack(alignment: .top) {
                    //MARK: 맵뷰 상단 검색바
                    HStack{
                        Button {
                            self.mode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 44,height: 44)
                                .foregroundColor(.black)
                                .bold()
                        }
                        TextField("ex) 서울시 종로구 사직동", text: $searchMap)
                            .padding()
                            .background(.white)
                            .frame(width: Screen.maxWidth * 0.7, height:  Screen.maxHeight * 0.0525)
                            .cornerRadius(15)
                            .shadow(color: .gray, radius: 5)
                            .onSubmit {
                                // MARK: Geocode API 실행
                                naverVM.fetchGeocode(requestAddress: searchMap)
                            }
                            .padding(.leading, -5)
                        
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.black)
                            .frame(width: Screen.maxWidth * 0.125, height:  Screen.maxHeight * 0.0525)
                            .shadow(color: .gray, radius: 5)
                            .onTapGesture {
                                searchResponse = naverVM.addresses
                                searchResponseBool = true
                                isShowingSearchProgress = true
                            }
                            .overlay{
                                Image(systemName: "location.magnifyingglass")
                                    .foregroundColor(.white)
                                    .onTapGesture {
                                        searchResponse = naverVM.addresses
                                        searchResponseBool = true
                                        isShowingSearchProgress = true
                                    }
                            }
                    }
                    .zIndex(1)
                    .padding(.trailing , 5)
                    
                    //MARK: 네이버맵뷰
                    AddMarkerUIMapView(naverVM: naverVM, locationManager: locationManager, updateNumber: $updateNumber, updateReverseGeocodeResult1: $updateReverseGeocodeResult1, reMarkerAddButtonBool: $reMarkerAddButtonBool, markerAddButtonBool: $markerAddButtonBool, locationcheckBool: $locationcheckBool, searchResponseBool: $searchResponseBool, searchResponse: $searchResponse, updateReverseGeocodeResult: $updateReverseGeocodeResult, userLatitude: userLatitude , userLongitude: userLongitude)
                        .edgesIgnoringSafeArea(.top)
                        .zIndex(0)
                        .onTapGesture {
                            hideKeyboard()
                            //markerAddButtonBool.toggle()
                        }
                    Image("uploadMarker")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: Screen.maxWidth * 0.1,height: Screen.maxHeight * 0.08)
                        .position(x: Screen.maxWidth * 0.5 , y: Screen.maxHeight * 0.29)
                    
                    
                    // MARK: - 검색 프로그레스
                    if isShowingSearchProgress  {
                        ProgressView()
                            .onAppear{
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    isShowingSearchProgress = false
                                }
                            }
                            .position(x: Screen.maxWidth * 0.5 , y: Screen.maxHeight * 0.25)
                            .zIndex(1)
                    }
                    
                    if isUpdateMagazineSuccess {
                        ProgressView()
                            .onAppear{
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    isUpdateMagazineSuccess = false
                                }
                            }
                            .position(x: Screen.maxWidth * 0.5 , y: Screen.maxHeight * 0.25)
                            .zIndex(1)
                    }
                    
                }//ZStack
                .opacity(isClickedSubmitButton ? 0.5 : 1)
                
                HStack {
                    Text("포토 스팟으로 핀을 이동하세요")
                        .font(.headline)
                    Spacer()
                }
                .frame(width: Screen.maxWidth * 0.85, height: Screen.maxHeight * 0.05)
                HStack {
                    Image(systemName: "pin.fill")
                    if updateReverseGeocodeResult1.count == 0 {
                        Text("-")
                    } else {
                        Text(updateReverseGeocodeResult1)
                    }
                    Spacer()
                    if isFinishedSpot {
                        Button {
                            updateReverseGeocodeResult1 = ""
                            isFinishedSpot = false
                        } label: {
                            Image(systemName: "x.circle")
                        }
                        
                    }
                }
                .frame(width: Screen.maxWidth * 0.85, height: Screen.maxHeight * 0.05)
                
                if (isFinishedSpot && writeDownCustomPlaceCheck){   // 핀과 커스텀 플레이스가 작성이 되었을때
//                    NavigationLink {
//                        CameraLenseFilmModalView(magazineVM: magazineVM, userVM: userVM, mapVM: mapVM, inputTitle: $inputTitle, inputContent: $inputContent, updateNumber: $updateNumber, updateReverseGeocodeResult1: $updateReverseGeocodeResult1, selectedImages: $selectedImages, inputCustomPlace: $inputCustomPlace, presented: $presented, writeDownCustomPlaceText: $writeDownCustomPlaceText)
//                            .navigationBarBackButtonHidden(true)
//                    } label:{
//                        RoundedRectangle(cornerRadius: 12)
//                            .fill(.black)
//                            .frame(width: Screen.maxWidth * 0.85, height: Screen.maxHeight * 0.07)
//                            .overlay {
//                                Text("다음")
//                                   .font(.headline)
//                                   .foregroundColor(.white)
//                        }
//                    }
                    
                    Button {
                        // 프로그레스뷰 ON
                        isUpdateMagazineSuccess = true
                        // 완료 버튼 1번 누르면 더이상 누르지 못하게 막기
                        isClickedSubmitButton = true
                        
                        // data.field에 데이터 저장
                        var docId = UUID().uuidString
                        
                        var data: MagazineFields = MagazineFields(filmInfo: MagazineString(stringValue: ""),
                                                                  id: MagazineString(stringValue: docId),
                                                                  customPlaceName: MagazineString(stringValue: ""),
                                                                  longitude: MagazineLocation(doubleValue: 0.0),
                                                                  title: MagazineString(stringValue: " "),
                                                                  comment: MagazineComment(arrayValue: MagazineArrayValue(values: [])),
                                                                  lenseInfo: MagazineString(stringValue: ""),
                                                                  userID: MagazineString(stringValue: ""),
                                                                  image: MagazineComment(arrayValue: MagazineArrayValue(values: [])),
                                                                  likedNum: LikedNum(integerValue: "0"),
                                                                  latitude: MagazineLocation(doubleValue: 0.0),
                                                                  content: MagazineString(stringValue: ""),
                                                                  nickName: MagazineString(stringValue: ""),
                                                                  roadAddress: MagazineString(stringValue: ""),
                                                                  cameraInfo: MagazineString(stringValue: ""))
               
                        data.id.stringValue = docId
                        data.userID.stringValue = userVM.currentUsers?.id.stringValue ?? ""
                        data.customPlaceName.stringValue = writeDownCustomPlaceText
                        data.title.stringValue = inputTitle
                        data.content.stringValue = inputContent
                        data.cameraInfo.stringValue = selectedCamera
                        data.filmInfo.stringValue = selectedFilm
                        data.lenseInfo.stringValue = selectedLense
                        data.likedNum.integerValue = "0"
                        data.longitude.doubleValue = updateNumber.lng
                        data.latitude.doubleValue = updateNumber.lat
                        data.nickName.stringValue = userVM.currentUsers?.nickName.stringValue ?? ""
                        data.roadAddress.stringValue = updateReverseGeocodeResult1
                        data.comment.arrayValue = MagazineArrayValue(values: [])
                        data.image.arrayValue = MagazineArrayValue(values: [])
                        
                        // FIXME: 이부분 나중에 여기서 배열 처리 해야함.. !
                        var postMagazineArr : [String]  = userVM.postedMagazineID
                        postMagazineArr.append(docId)
                        userVM.updateCurrentUserArray(type: "postedMagazineID", arr: postMagazineArr, docID: Auth.auth().currentUser?.uid ?? "")
                        
                        // FIXME: - insertMap 동작안함
                        magazineVM.insertMagazine(data: data, images: selectedImages)
                        mapVM.insertMap(data: data)
                    } label: {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.black)
                            .frame(width: Screen.maxWidth * 0.85, height: Screen.maxHeight * 0.07)
                            .overlay {
                                Text("완료")
                                   .font(.headline)
                                   .foregroundColor(.white)
                        }
                    }.disabled(isClickedSubmitButton) // magazine update 하는 동안은 button 비활성화

                } else if isFinishedSpot { //핀이 찍혔을 경우
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.black)
                            .frame(width: Screen.maxWidth * 0.85, height: Screen.maxHeight * 0.07)
                            .overlay {
                                Button {
                                    showingAlert.toggle()
                                } label: {
                                    Text("나만의 장소 이름 설정하기")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                }
                                .alert("나만의 장소 이름 설정해주세요 😃", isPresented: $showingAlert) {
                                    TextField("예) 이불 속이 최고야 🛌", text: $writeDownCustomPlaceText)
                                    Button("설정", action: {
                                        writeDownCustomPlaceCheck = true
                                    })
                                    Button("취소", role: .cancel, action: {})
                                } message: {
                                    Text("게시물에 같이 표시될 예정입니다!")
                                }
                            }
                }else { //핀이 안찍혔을 경우
                    Button {
                        markerAddButtonBool.toggle()
                        isFinishedSpot = true
                    } label: {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.black)
                            .frame(width: Screen.maxWidth * 0.85, height: Screen.maxHeight * 0.07)
                            .overlay {
                                Text("포토스팟 설정")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                    }
                }
                
            }.onAppear{
                writeDownCustomPlaceCheck = false
            }
            .onReceive(magazineVM.insertMagazineSuccess) { _ in
                // 프로그레스뷰 OFF
                isUpdateMagazineSuccess = false
                // 창닫기
                presented.toggle()
            }
        }
    }
}


// FIXME: 네이버 지도
// 네이버 지도를 띄울 수 있게끔 만들어주는 코드들 <- 연구가 필요!! 이해 완료 후 주석 달아보기
struct AddMarkerUIMapView: UIViewRepresentable,View {
    
    //임시
    @ObservedObject var naverVM : NaverAPIViewModel
    @ObservedObject var locationManager : LocationManager
    // 가상 마커 CGPoint 좌표 값을 통해 지도 좌표 넘겨주기
    @Binding var updateNumber : NMGLatLng
    @Binding var updateReverseGeocodeResult1 : String
    
    @Binding var reMarkerAddButtonBool : Bool
    @Binding var markerAddButtonBool : Bool
    @Binding var locationcheckBool : Bool
    @Binding var searchResponseBool : Bool
    
    @State var changeMap : CGPoint = CGPoint(x: 0, y: 0)    //여기서는 안쓰임
    // 위에서 값 받아오기
    @Binding var searchResponse : [Address]
    
    @Binding var updateReverseGeocodeResult :  [ReverseGeocodeResult]
    
    var userLatitude: Double 
    
    var userLongitude: Double
    
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
        
        // MARK: 네이버 지도 나침판, 현재 유저 위치 GPS 버튼
        view.showCompass = false
        view.showLocationButton = true
        view.mapView.isRotateGestureEnabled = false
        
        view.mapView.touchDelegate = context.coordinator
        
        // MARK: 지도가 그려질때 현재 유저 GPS 위치로 카메라 움직임
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: userLatitude, lng: userLongitude))
        view.mapView.moveCamera(cameraUpdate)
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
        
        
        
        let addUserMarker = NMFMarker()
        
        if markerAddButtonBool{
            addUserMarker.position = uiView.mapView.projection.latlng(from: CGPoint(x: Screen.maxWidth * 0.5, y: Screen.maxHeight * 0.38))
            addUserMarker.iconImage = NMFOverlayImage(name: "uploadMarker")
            addUserMarker.width = Screen.maxWidth * 0.1
            addUserMarker.height = Screen.maxHeight * 0.045
            addUserMarker.mapView = uiView.mapView
            
            
            // 업로드에 위치 정보 넘겨줌
            updateNumber = addUserMarker.position
            naverVM.fetchReverseGeocode(latitude: addUserMarker.position.lat, longitude: addUserMarker.position.lng)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                if naverVM.reverseGeocodeResult.count == 0{
                    updateReverseGeocodeResult1 = "주소지 없음"
                }else{
                    updateReverseGeocodeResult1 = naverVM.reverseGeocodeResult[0].region.area1.name + " " + naverVM.reverseGeocodeResult[0].region.area2.name + " " +
                    naverVM.reverseGeocodeResult[0].region.area3.name
                }

            }
            markerAddButtonBool.toggle()
        }
        
        if reMarkerAddButtonBool{
            // 추가하기 FIXME: 고쳐야함
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

