//
//  ContentView.swift
//  Grain
//
//  Created by 조형구 on 2023/01/18.
//

import SwiftUI

import FirebaseAuth
import NMapsMap
import FirebaseAuth

struct ContentView: View {
    @EnvironmentObject var authenticationStore: AuthenticationStore
    @StateObject var communityVM = CommunityViewModel()
    @StateObject var mapVM = MapViewModel()
    @StateObject var magazineVM = MagazineViewModel()
    
    @State private var tabSelection: Int = 0
    @State var selectedIndex = 0
    @State var magazineViewPresented : Bool = false
    @State var presented = false
    @State var ispushedAddButton = false
    @State var updateNumber : NMGLatLng = NMGLatLng(lat: 0, lng: 0)
    @State var clikedMagazineData : MagazineDocument?
    
    let icons = ["film", "text.bubble", "plus","map", "person"]
    let labels = ["매거진", "커뮤니티", "", "지도", "마이"]
    
    
    @StateObject var userVM = UserViewModel()
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
                    ZStack {
                        Spacer()
                            .fullScreenCover(isPresented: $presented) {
                                VStack {
                                    SelectPostView(presented: $presented,
                                                   communityVM: communityVM,
                                                   updateNumber: updateNumber)
                                }
                            }
                        
                        switch selectedIndex {
                        case 0:
                            NavigationStack {
                                MagazineMainView(currentUsers: userVM.currentUsers)
                            }
                        case 1:
                            NavigationStack {
                                CommunityView(communityVM: communityVM)
                            }
                        case 2:
                            NavigationStack {
                                CommunityView(communityVM: communityVM)
                            }
                        case 3:
                            NavigationStack {
                                MapView(magazineData: $magazineVM.magazines,
                                        mapData:$mapVM.mapData,
                                        clikedMagazineData: clikedMagazineData)
                            }
                        case 4:
                            NavigationStack {
                                MyPageView(magazineDocument: magazineVM.userPostsFilter(magazineData: magazineVM.magazines, userPostedArr: userVM.postedMagazineID), boomarkedMagazineDocument: magazineVM.userBookmarkedPostsFilter(magazineData: magazineVM.magazines, userBookmarkedPostedArr: userVM.bookmarkedMagazineID))
                            }
                        default:
                            NavigationStack {
                                VStack {
                                    SelectPostView(presented: $presented,
                                                   communityVM: communityVM,
                                                   updateNumber: updateNumber)
                                }
                            }
                        }
                        Spacer()
                    }
                    
                    HStack {
                        ForEach(0..<5, id: \.self) { number in
                            Button {
                                if number == 2 {
                                    presented.toggle()
                                } else {
                                    self.selectedIndex = number
                                }
                            } label: {
                                if number == 2 {
                                    Image(systemName: icons[number])
                                        .font(.title3)
                                        .foregroundColor(.white)
                                        .frame(width: 60, height: 60)
                                        .background(.black)
                                        .cornerRadius(30)
                                }
                                else {
                                    VStack{
                                        Image(systemName: icons[number])
                                            .font(.title3)
                                            .foregroundColor(selectedIndex == number ? .black : Color(UIColor.lightGray))
                                        Text(labels[number])
                                            .font(.caption)
                                            .foregroundColor(selectedIndex == number ? .black : Color(UIColor.lightGray))
                                    }
                                    .frame(width: 60, height: 60)
                                }
                            }
                        }
                    }
                }
            }
        }
        .tint(.black)
        .onAppear{
            /// 처음부터 마커 데이터를 가지고 있으면 DispatchQueue를 안해도 되지 않을까?
            mapVM.fetchMap()
            magazineVM.fetchMagazine()
            userVM.fetchCurrentUser(userID: Auth.auth().currentUser?.uid ?? "")
            //                    magazineVM.updateMagazine()
        }
        .ignoresSafeArea(.keyboard)
        //        .splashView {
        //            ZStack{
        //                SplashScreen()
        //            }
        //
        //        }
    }
    
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthenticationStore())
    }
}
