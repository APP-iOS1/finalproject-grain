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
    // 정훈
    @State var updateNumber : NMGLatLng = NMGLatLng(lat: 0, lng: 0)
   
    var body: some View {
        switch viewRouter.currentPage{
        case .contentView:
            ContentView().environmentObject(AuthenticationStore())
//                .environmentObject(KakaoAuthenticationStore())
                
        case .mapView:
            MapView()
        case .photoSpotDetailView:
            PhotoSpotDetailView()
        case .webkitView:
            WebkitView(bindingWebURL: $bindingWebURL)   //TODO: 임시코드 <- 리팩토링 하기
        case .photoSpotMapView:
            PhotoSpotMapView()
        case .stationMapView:
            StationMapView()
        case .repairShopMapView:
            RepairShopMapView()
        case .addMarkerMapView:
            AddMarkerMapView(updateNumber: $updateNumber)
        case .magazineContentAddView:
            MagazineContentAddView(presented: $presented, updateNumber: updateNumber)
        }
    }
}
