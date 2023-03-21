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
    @StateObject var editorVM = EditorViewModel()
    @StateObject var userVM = UserViewModel()
    @StateObject var locationManager = LocationManager()
    @StateObject var commentVm = CommentViewModel()
    
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
    
    @SceneStorage("isZooming") var isZooming: Bool = false
    
    
    var userLatitude: Double {
        return locationManager.lastLocation?.coordinate.latitude ?? 37.5701759
    }
    var userLongitude: Double {
        return locationManager.lastLocation?.coordinate.longitude ?? 126.9835183
    }
    
    // 네트워크 감지
    @ObservedObject var networkManager = NetworkManager()
    
    var body: some View {
//        Group{
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
                                    .fullScreenCover(isPresented: $presented) {
                                        VStack {
                                            SelectPostView(userVM: userVM,
                                                           communityVM: communityVM,
                                                           magazineVM: magazineVM,
                                                           mapVM : mapVM,
                                                           locationManager : locationManager,
                                                           presented: $presented,
                                                           updateNumber: updateNumber,userLatitude: userLatitude , userLongitude: userLongitude)
                                        }
                                    }
                                
                                switch selectedIndex {
                                case 0:
                                    NavigationStack {
                                        MagazineMainView(userViewModel: userVM, magazineVM: magazineVM, editorVM: editorVM)
                                    }
                                case 1:
                                    NavigationStack {
                                        CommunityView(communityVM: communityVM, userVM: userVM, magazineVM: magazineVM)
                                    }
                                case 2:
                                    NavigationStack {
                                        // 게시물 추가 버튼 부분
                                    }
                                case 3:
                                    NavigationStack {
                                        MapView(mapVM: mapVM, userVM : userVM, magazineVM : magazineVM, locationManager : locationManager, clikedMagazineData: clikedMagazineData, userLatitude: userLatitude, userLongitude: userLongitude)
                                    }
                                case 4:
                                    NavigationStack {
                                        MyPageView(commentVm: commentVm, communityVM: communityVM, userVM: userVM, magazineVM: magazineVM, magazineDocument: magazineVM.userPostsFilter(magazineData: magazineVM.magazines, userPostedArr: userVM.postedMagazineID), boomarkedMagazineDocument: magazineVM.userBookmarkedPostsFilter(magazineData: magazineVM.magazines, userBookmarkedPostedArr: userVM.bookmarkedMagazineID), bookmarkedCommunityDoument: communityVM.userBookmarkedCommunityFilter(communityData: communityVM.communities, userBookmarkedCommunityArr: userVM.bookmarkedCommunityID))
                                    }
                                default:
                                    NavigationStack {
                                        VStack {
                                            SelectPostView(userVM: userVM,
                                                           communityVM: communityVM,
                                                           magazineVM: magazineVM,
                                                           mapVM : mapVM,
                                                           locationManager : locationManager,
                                                           presented: $presented,
                                                           updateNumber: updateNumber,userLatitude: userLatitude , userLongitude: userLongitude)
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
                    editorVM.fetchEditor()
                    magazineVM.fetchMagazine()
                    communityVM.fetchCommunity()
                    userVM.fetchCurrentUser(userID: Auth.auth().currentUser?.uid ?? "")
                    userVM.fetchUser()
                    
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
//        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthenticationStore())
    }
}
