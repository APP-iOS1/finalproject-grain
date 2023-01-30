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
    @State var presented : Bool = true

   
    var body: some View {
        switch viewRouter.currentPage{
        case .contentView:
            ContentView().environmentObject(AuthenticationStore())
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
            AddMarkerMapView(updateNumber: NMGLatLng(lat: 0, lng: 0))
        case .magazineContentAddView:
            MagazineContentAddView(presented: $presented)
        }
    }
}
