//
//  ViewRouter.swift
//  Grain
//
//  Created by 지정훈 on 2023/01/23.
//

import Foundation
import SwiftUI

class ViewRouter : ObservableObject{
    
    //현재 첫 번째 페이지는 mainLoginView
    @Published var currentPage : Page = .contentView
}

enum Page {
    case contentView
//    case mapView    // FIX
//    case photoSpotDetailView    // FIX
    case webkitView // FIX
    case stationMapView
    case repairShopMapView
    case photoSpotMapView
//    case addMarkerMapView
    case magazineContentAddView
}
