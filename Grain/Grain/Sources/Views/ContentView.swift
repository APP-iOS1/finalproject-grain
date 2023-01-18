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
               AuthenticationTestView()
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

