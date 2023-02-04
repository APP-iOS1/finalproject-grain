//
//  Switchingview.swift
//  Grain
//
//  Created by 지정훈 on 2023/01/23.
//

import SwiftUI
import NMapsMap
struct Switchingview: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    //TODO: 임시코드 <- 리팩토링 하기
    @State var bindingWebURL : String = ""
    // 임시
    @State var presented : Bool = false
    @State var clickedMagazineDataID : String = ""
    @State var aroundPostArr : [String] = []
    
    // 정훈
    @State var updateNumber : NMGLatLng = NMGLatLng(lat: 0, lng: 0)
    @StateObject var mapVM = MapViewModel()
    @StateObject var magazineVM = MagazineViewModel()

    var body: some View {
        switch viewRouter.currentPage{
        case .contentView:
            ContentView().environmentObject(AuthenticationStore()).environmentObject(KakaoAuthenticationStore())
        case .mapView:
            MapView(mapData: $mapVM.mapData, magazineData: $magazineVM.magazines)
        case .photoSpotDetailView:
            PhotoSpotDetailView(magazineData: $magazineVM.magazines, clickedMagazineDataID: $clickedMagazineDataID, aroundPostArr: $aroundPostArr)
                .onAppear{
                    magazineVM.fetchMagazine()
                }
        case .webkitView:
            WebkitView(bindingWebURL: $bindingWebURL)   //TODO: 임시코드 <- 리팩토링 하기
        case .photoSpotMapView:
            PhotoSpotMapView(mapData: $mapVM.mapData)
        case .stationMapView:
            StationMapView(mapData: $mapVM.mapData)
        case .repairShopMapView:
            RepairShopMapView(mapData: $mapVM.mapData)
//        case .addMarkerMapView:
//            AddMarkerMapView(updateNumber: $updateNumber)
        case .magazineContentAddView:
            MagazineContentAddView(presented: $presented, updateNumber: updateNumber)
        case .testGeocodeView:
            TestGeocodeView()
        }
//            .splashView {
//                ZStack{
//                    SplashScreen()searchMap
//                }
//            }
    }
        
}
