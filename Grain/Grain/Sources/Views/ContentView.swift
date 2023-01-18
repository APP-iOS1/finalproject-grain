//
//  ContentView.swift
//  Grain
//
//  Created by 조형구 on 2023/01/18.
//

import SwiftUI

import FirebaseAuth


struct ContentView: View {
    @EnvironmentObject var authenticationStore: AuthenticationStore
    
    @State private var tabSelection: Int = 0
    
    var body: some View {
        switch authenticationStore.authenticationStatus {
        case .unAuthenticated:
            NavigationStack{
                AuthenticationView()
            }
            
        case.authenticated(let user):
            TabView(selection: $tabSelection) {
                
                MagazineBestView()
                    .tabItem {
                        Text("매거진뷰")
                    }.tag(0)
                
                CommunityView()
                    .tabItem {
                        Text("커뮤니티뷰")
                    }.tag(1)
                MapView()
                    .tabItem {
                        Text("맵뷰")
                    }.tag(2)
            }
        }
    }
}






struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthenticationStore())
    }
}
