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
    
    @State private var tabViewSelectedIndex: Int = 0
    @State private var selectedAgainIndex: Int = 0
    @State var magazineViewPresented : Bool = false
    @State private var presented = false
    @State var updateNumber : NMGLatLng = NMGLatLng(lat: 0, lng: 0)
    @State var clikedMagazineData : MagazineDocument?
    @State private var isSearchViewShown: Bool = false
    @State private var magazineScrollToTop: Bool = false
    @State private var communityScrollToTop: Bool = false
    @State private var myPageScrollToTop: Bool = false
    
    let icons = ["film", "text.bubble", "plus","map", "person"]
    let labels = ["피드", "커뮤니티", "", "지도", "마이"]
    
    @State var modalSize = Screen.maxHeight * 0.25
    
    @AppStorage("authenticationState") var authenticationState: AuthenticationState = .unauthenticated
    
    @SceneStorage("isZooming") var isZooming: Bool = false
    
    
    var userLatitude: Double {
        return locationManager.lastLocation?.coordinate.latitude ?? 0.0
    }
    var userLongitude: Double {
        return locationManager.lastLocation?.coordinate.longitude ?? 0.0
    }
    
    // 네트워크 감지
    @ObservedObject var networkManager = NetworkManager()
    init(){
        UITabBar.appearance().isHidden = true
    }
    var body: some View {
        Group{
            if networkManager.isConnected {
                VStack{
                    switch authenticationState {
                    case .unauthenticated, .authenticating , .freshman:
                        NavigationStack{
                            AuthenticationView(userVM: userVM)
                        }
                    case.authenticated:
                        NavigationStack{
                            VStack{
                                TabView(selection: $tabViewSelectedIndex) {
                                    MagazineMainView(communityVM: communityVM, userVM: userVM, magazineVM: magazineVM, editorVM: editorVM, scrollToTop: $magazineScrollToTop)
                                        .tag(0)
                                    CommunityView(communityVM: communityVM, userVM: userVM, magazineVM: magazineVM, scrollToTop: $communityScrollToTop)
                                        .tag(1)
                                    
                                    MapView(mapVM: mapVM, userVM : userVM, magazineVM : magazineVM, locationManager : locationManager, clikedMagazineData: clikedMagazineData, userLatitude: userLatitude, userLongitude: userLongitude)
                                        .edgesIgnoringSafeArea(.top)
                                        .tag(3)
                                    MyPageView(commentVm: commentVm, communityVM: communityVM, userVM: userVM, magazineVM: magazineVM, magazineDocument: magazineVM.userPostsFilter(magazineData: magazineVM.magazines, userPostedArr: userVM.postedMagazineID), presented: $presented, scrollToTop: $myPageScrollToTop)
                                        .tag(4)
                                    
                                }
                                .onAppear{
                                    UIApplication.shared.applicationIconBadgeNumber = 0
                                }
                                .toolbar {
                                    if (tabViewSelectedIndex == 0) || (tabViewSelectedIndex == 1) {
                                        ToolbarItem(placement: .navigationBarLeading) {
                                            Text("GRAIN")
                                                .font(.title)
                                                .bold()
                                                .kerning(7)
                                        }
                                        
                                        ToolbarItem(placement: .navigationBarTrailing) {
                                            Button {
                                                self.isSearchViewShown = true
                                            } label: {
                                                Image(systemName: "magnifyingglass")
                                                    .foregroundColor(.black)
                                            }
                                        
                                        }
                                        
                                    }
                                    
                                    if tabViewSelectedIndex == 4{
                                        ToolbarItem(placement: .navigationBarLeading) {
                                            Text("GRAIN")
                                                .font(.title)
                                                .bold()
                                                .kerning(7)

                                        }
                                        
                                        ToolbarItem(placement: .navigationBarTrailing) {
                                            NavigationLink {
                                                MyPageOptionView(commentVm: commentVm,communityVM: communityVM, magazineVM: magazineVM, userVM: userVM, presented: $presented)
                                            } label: {
                                                Image(systemName: "ellipsis")
                                                    .foregroundColor(.black)
                                            }
                                        }
                                    }
                                    
                                }

                                HStack(alignment: .top, spacing: 11) {
                                    ForEach(0..<5, id: \.self) { number in
                                        
                                        if number == 2 {
                                            Circle()
                                                .frame(width: 38, height: 38)
                                                .foregroundColor(.black)
                                                .overlay {
                                                    Image(systemName: icons[number])
                                                        .font(.title3)
                                                        .foregroundColor(.white)
                                                        .monospacedDigit()
                                                }
                                                .padding(.horizontal, 9)
                                                .onTapGesture {
                                                    presented.toggle()
                                                    
                                                }
                                        }
                                        else {
                                            VStack{
                                                Image(systemName: icons[number])
                                                    .font(.title3)
                                                    .foregroundColor(tabViewSelectedIndex == number ? .black : Color(UIColor.lightGray))
                                                    .monospacedDigit()
                                                Text(labels[number])
                                                    .font(.caption2)
                                                    .foregroundColor(tabViewSelectedIndex == number ? .black : Color(UIColor.lightGray))
                                                    .monospacedDigit()
                                                
                                            }
                                            .frame(width: 65, height: 42)
                                            .onTapGesture {
                                                if tabViewSelectedIndex != number{
                                                    self.tabViewSelectedIndex = number
                                                    
                                                }else if tabViewSelectedIndex == number{
                                                    if tabViewSelectedIndex == 0 {
                                                        self.magazineScrollToTop.toggle()
                                                        
                                                    }else if tabViewSelectedIndex == 1{
                                                        self.communityScrollToTop.toggle()
                                                        
                                                    }else if tabViewSelectedIndex == 4{
                                                        self.myPageScrollToTop.toggle()
                                                    }
                                                }
                                                
                                            }
                                        }
                                        
                                    }
                                }
                                
                            }
                            .navigationDestination(isPresented: $isSearchViewShown) {
                                MainSearchView(communityViewModel: communityVM, magazineViewModel: magazineVM, userViewModel: userVM)
                            }
                        }
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
                    }
                }
                .tint(.black)
                .onAppear{
                    /// 처음부터 마커 데이터를 가지고 있으면 DispatchQueue를 안해도 되지 않을까?
                    self.isSearchViewShown = false
                    editorVM.fetchEditor()
//                    magazineVM.fetchMagazine(nextPageToken: "")
                    communityVM.fetchCommunity(nextPageToken: "")
                    userVM.fetchCurrentUser(userID: Auth.auth().currentUser?.uid ?? "")
                    userVM.fetchUser(nextPageToken: "")
                    
                    // 로그인을 할때 토큰값 넣기
                    if authenticationState == .authenticated{
                        authenticationStore.addToken()
                    }

                }
                .splashView {
                    ZStack{
                        SplashScreen()
                    }

                }
            } else {
                NetworkConnectionView(networkManager: networkManager)
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
