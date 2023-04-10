//
//  AppDataModel.swift
//  Grain
//
//  Created by 홍수만 on 2023/04/10.
//

import SwiftUI

class AppDataModel: ObservableObject {
    @Published var currentTab: Tab = .MagazineMainView
    
    func checkkDeepLink(url: URL) -> Bool{
        guard let host = URLComponents(url: url, resolvingAgainstBaseURL: true)?.host else{
            return false
        }
        
        if host == Tab.MagazineMainView.rawValue{
            currentTab = .MagazineMainView
        }
        else if host == Tab.CommunityView.rawValue{
            currentTab = .CommunityView
        }
        else if host == Tab.MapView.rawValue{
            currentTab = .MapView
        }
        else if host == Tab.MyPageView.rawValue{
            currentTab = .MyPageView
        }
        else {
            return false
        }
        
        return true 
    }
}

enum Tab: String {
    case MagazineMainView = "MagazineMainView"
    case CommunityView = "CommunityView"
    case MapView = "MapView"
    case MyPageView = "MyPageView"
}
