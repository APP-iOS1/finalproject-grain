//
//  ReportMapView.swift
//  Grain
//
//  Created by 지정훈 on 2023/03/06.
//

import SwiftUI
import CoreLocation
import NMapsMap



struct ReportMapView: View {
    @Environment(\.dismiss) private var dismiss
    @State var clickedReportButtonBool : Bool = false   // updateUIView에서 경도 위도를 알 수 있게끔 해주는 Bool 값
    
    @Binding var updateNumber : NMGLatLng   // mapView에서 바인딩 받아야됨 아직 이유를 모르겠음
    
    @State var showingAlert : Bool = false
    @State var finalReportBool : Bool = false   // 최종 제보하기 버튼
    
    @State var writeDownCategory : String = ""  // 카테고리 적는 텍스트필드
    @State var writeDownStoreName : String = "" // 가게이름 적는 텍스트필드
    
    @StateObject var reportMapVM = ReportMapViewModel()
    
    var body: some View {
        ZStack{
            ReportUIMapView(clickedReportButtonBool: $clickedReportButtonBool, updateNumber: $updateNumber) //지도 호출
            
            // MARK: Mapview로 돌아가는 버튼
            Button {
                dismiss()
            } label: {
                Rectangle()
                    .foregroundColor(.white)
                    .overlay{
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                            .bold()
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.black  , lineWidth: 5)
                    }.cornerRadius(10)
                    .frame(width: Screen.maxWidth * 0.1 , height:  Screen.maxHeight * 0.045)
                    
            }
            .position(x: Screen.maxWidth * 0.1 , y: Screen.maxHeight * 0.1)
            
            // MARK: 화면 가운데 표시되는 이미지 가상 마커
            Image("uploadMarker")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: Screen.maxWidth * 0.1,height: Screen.maxHeight * 0.08)
                .position(x: Screen.maxWidth * 0.5 , y: Screen.maxHeight * 0.5)
           

            
            
            if (finalReportBool){   // 최종 제보하기 버튼 조건문
                Button {
                    print(updateNumber.lat)
                    print(updateNumber.lng)
                    
                   
                    reportMapVM.insertReportMap(data: ReportMapFields(longitude: ReportMapDoubleValue(doubleValue: updateNumber.lng), latitude: ReportMapDoubleValue(doubleValue: updateNumber.lat), storeName: ReportMapStringValue(stringValue: writeDownStoreName), category: ReportMapStringValue(stringValue: writeDownCategory)))
                    // post 
                    writeDownCategory = ""
                    writeDownStoreName = ""
                    
                    dismiss()
                } label: {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.black)
                        .frame(width: Screen.maxWidth * 0.85, height: Screen.maxHeight * 0.07)
                        .overlay {
                            Text("제보하기")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                }
                .position(x: Screen.maxWidth * 0.5 , y: Screen.maxHeight * 0.85)
            }else{
                RoundedRectangle(cornerRadius: 12)
                    .fill(.black)
                    .frame(width: Screen.maxWidth * 0.85, height: Screen.maxHeight * 0.07)
                    .overlay {
                        Button {
                            showingAlert.toggle()
                            clickedReportButtonBool.toggle()
                        } label: {
                            Text("현상소 / 수리점 제보하기")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        .alert("1. 카테고리를 입력해주세요\n 2. 가게이름을 입력해주세요", isPresented: $showingAlert) {
                            TextField("예) 수리점", text: $writeDownCategory)
                            TextField("예) 화성 제일 수리점", text: $writeDownStoreName)
                            Button("확인", action: {
                                finalReportBool.toggle()
                                clickedReportButtonBool = false
                            })
                            Button("취소", role: .cancel, action: {})
                        } message: {
                            //                            Text("제보 감사드립니다!")
                        }
                    }
                    .position(x: Screen.maxWidth * 0.5 , y: Screen.maxHeight * 0.85)
                
            }
           
        }
        .ignoresSafeArea()
    }
}
    

struct ReportUIMapView: UIViewRepresentable,View {

    
    @StateObject var locationManager = LocationManager()
    @Binding var clickedReportButtonBool : Bool
    
    
    @Binding var updateNumber : NMGLatLng
    
    
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
        view.mapView.isRotateGestureEnabled = false
        
        // MARK: 지도가 그려질때 현재 유저 GPS 위치로 카메라 움직임
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: userLatitude, lng: userLongitude))
        view.mapView.moveCamera(cameraUpdate)

        return view
    }
    
    
    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {
       
        if clickedReportButtonBool{
            updateNumber = uiView.mapView.projection.latlng(from: CGPoint(x: Screen.maxWidth * 0.5, y: Screen.maxHeight * 0.5))
            clickedReportButtonBool.toggle()
        }
        
        
    }
    
}
