//
//  Switchingview.swift
//  Grain
//
//  Created by 지정훈 on 2023/01/23.
//

import SwiftUI

struct Switchingview: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        switch viewRouter.currentPage{
        case .contentView:
            ContentView().environmentObject(AuthenticationStore())
        case .mapView:
            MapView()
        case .photoSpotDetailView:
            PhotoSpotDetailView()
        case .webkitView:
            WebkitView()
        case .photoSpotMapView:
            PhotoSpotMapView()
        case .stationMapView:
            StationMapView()
        case .repairShopMapView:
            RepairShopMapView()
        }
    }
}
