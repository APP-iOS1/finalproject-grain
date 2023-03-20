//
//  ContentView.swift
//  Grain
//
//  Created by 조형구 on 2023/01/18.
//

import SwiftUI

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
    
    @State var modalSize = Screen.maxHeight * 0.25
    @StateObject var userVM = UserViewModel()
    

    @SceneStorage("isZooming") var isZooming: Bool = false

    @StateObject var locationManager = LocationManager()
    var userLatitude: Double {
        return locationManager.lastLocation?.coordinate.latitude ?? 37.5701759
    }
    var userLongitude: Double {
        return locationManager.lastLocation?.coordinate.longitude ?? 126.9835183
    }

    // 네트워크 감지
    @ObservedObject var networkManager = NetworkManager()

    var body: some View {
        Group{
            if networkManager.isConnected {
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
                                //                            .sheet(isPresented: $presented, content: {
                                //                                SelectPostView(presented: $presented, communityVM: communityVM, updateNumber: updateNumber, modalSize: $modalSize)
                                //                                    .presentationDetents([.height(modalSize)])
                                //                            })
                                    .fullScreenCover(isPresented: $presented) {
                                        VStack {
                                            SelectPostView(presented: $presented,
                                                           communityVM: communityVM,
                                                           updateNumber: updateNumber,magazineVM: magazineVM, userLatitude: userLatitude , userLongitude: userLongitude)
                                        }
                                    }
                                
                                switch selectedIndex {
                                case 0:
                                    NavigationStack {
                                        MagazineMainView(userViewModel: userVM, magazineVM: magazineVM)
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
                                        MapView(clikedMagazineData: clikedMagazineData, userLatitude: userLatitude, userLongitude: userLongitude)
                                    }
                                case 4:
                                    NavigationStack {
                                        MyPageView(magazineVM: magazineVM, magazineDocument: magazineVM.userPostsFilter(magazineData: magazineVM.magazines, userPostedArr: userVM.postedMagazineID), boomarkedMagazineDocument: magazineVM.userBookmarkedPostsFilter(magazineData: magazineVM.magazines, userBookmarkedPostedArr: userVM.bookmarkedMagazineID), bookmarkedCommunityDoument: communityVM.userBookmarkedCommunityFilter(communityData: communityVM.communities, userBookmarkedCommunityArr: userVM.bookmarkedCommunityID))
                                    }
                                default:
                                    NavigationStack {
                                        VStack {
                                            SelectPostView(presented: $presented,
                                                           communityVM: communityVM,
                                                           updateNumber: updateNumber,magazineVM: magazineVM, userLatitude: userLatitude , userLongitude: userLongitude)
                                        }
                                    }
                                }
                                Spacer()
                            }
                            if isZooming == false {
                                
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
                                                    .font(.title2)
                                                    .foregroundColor(.white)
                                                    .frame(width: 60, height: 60)
                                                    .background(.black)
                                                    .cornerRadius(30)
                                            }
                                            else {
                                                VStack{
                                                    Image(systemName: icons[number])
                                                        .font(.title2)
                                                        .foregroundColor(selectedIndex == number ? .black : Color(UIColor.lightGray))
                                                    Text(labels[number])
                                                        .font(.caption)
                                                        .foregroundColor(selectedIndex == number ? .black : Color(UIColor.lightGray))
                                                }
                                                .frame(width: 67, height: 60)
                                            }
                                        }
                                    }
                                }
                                
                                .transition(.move(edge: .bottom))
                            }
                        }
                        .animation(.default , value: isZooming)
                    }
                }
                .edgesIgnoringSafeArea(.top)    // <- 지도 때문에 넣음
                .tint(.black)
                .onAppear{
                    /// 처음부터 마커 데이터를 가지고 있으면 DispatchQueue를 안해도 되지 않을까?
                    magazineVM.fetchMagazine()
                    communityVM.fetchCommunity()
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
            } else {
                NetworkConnectionView(networkManager: networkManager)
            }
        }
        .edgesIgnoringSafeArea(.top)    // <- 지도 때문에 넣음
        .tint(.black)
        .onAppear{
            /// 처음부터 마커 데이터를 가지고 있으면 DispatchQueue를 안해도 되지 않을까?
            magazineVM.fetchMagazine()
            communityVM.fetchCommunity()
            userVM.fetchCurrentUser(userID: Auth.auth().currentUser?.uid ?? "")

            //                    magazineVM.updateMagazine()
        }
        .ignoresSafeArea(.keyboard)
//                .splashView {
//                    ZStack{
//                        SplashScreen()
//                    }
//        
//                }
    }
    
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthenticationStore())
    }
}
