//
//  ContentView.swift
//  Grain
//
//  Created by 조형구 on 2023/01/18.
//

import SwiftUI

import FirebaseAuth
import NMapsMap

struct ContentView: View {
    @EnvironmentObject var authenticationStore: AuthenticationStore
    
    @State private var tabSelection: Int = 0
    @State var selectedIndex = 0
    @State var magazineViewPresented : Bool = false
    @State var presented = false
    //정훈
    @State var updateNumber : NMGLatLng = NMGLatLng(lat: 0, lng: 0)
    
    let icons = ["magazine", "note.text", "plus","map", "person"]
    
    var body: some View {
        VStack{
            switch authenticationStore.authenticationState {
            case .unauthenticated, .authenticating:
                NavigationStack{
                    AuthenticationView()
                }
                
            case.authenticated:
                VStack{
                    Spacer()
                    //EditorView()
                    ZStack {
                        Spacer().fullScreenCover(isPresented: $presented) {
                            VStack {
                                
                                if self.selectedIndex == 0 {
                                    MagazineContentAddView(presented: $presented, updateNumber: updateNumber)
                                } else if self.selectedIndex == 1{
                                    AddCommunityView(presented: $presented)
                                }
                                Spacer()
                                
                            }
                        }
                        
                        switch selectedIndex {
                        case 0:
                            NavigationStack {
                                MagazineMainView()
                            }
                        case 1:
                            NavigationStack {
                                CommunityView()
                            }
                        case 2:
                            NavigationStack {
                                CommunityView()
                            }
                        case 3:
                            NavigationStack {
                                MapView()
                            }
                        case 4:
                            NavigationStack {
                                MyPageView()
                            }
                        default:
                            NavigationStack {
                                VStack {
                                    
                                    if self.selectedIndex == 0 {
                                        MagazineContentAddView(presented: $presented, updateNumber: NMGLatLng(lat: 0, lng: 0))
                                    } else if self.selectedIndex == 1{
                                        AddCommunityView(presented: $presented)
                                    }
                                }
                            }
                        }
                        Spacer()
                    }
                    
                    Divider()
                        .padding(.top, -8)
                    
                    HStack {
                        ForEach(0..<5, id: \.self) { number in
                            Spacer()
                            Button {
                                if number == 2 {
                                    presented.toggle()
                                } else {
                                    self.selectedIndex = number
                                }
                            } label: {
                                if number == 2 {
                                    Image(systemName: icons[number])
                                        .font(.system(size: 25,
                                                      weight: .regular,  design: .default))
                                        .foregroundColor(.white)
                                        .frame(width: 60, height: 60)
                                        .background(.black)
                                        .cornerRadius(30)
                                    
                                }
                                else {
                                    Image(systemName: icons[number])
                                        .font(.system(size: 25,
                                                      weight: .regular,  design: .default))
                                        .foregroundColor(selectedIndex == number ? .black : Color(UIColor.lightGray))
                                }
                            }
                            Spacer()
                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Text("Grain")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .padding()
                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            HStack {
                                Button {
                                    //검색
                                } label: {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(.black)
                                }
                                Button {
                                    //글쓰기
                                } label: {
                                    Image(systemName: "plus")
                                        .foregroundColor(.black)
                                }
                            }
                        }
                    }
                    
                    
                }
                .ignoresSafeArea(.keyboard)
            }
        }
        .splashView {
            ZStack{
                SplashScreen()
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
