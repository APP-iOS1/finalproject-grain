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
    @State private var presented = false
    @State var updateNumber : NMGLatLng = NMGLatLng(lat: 0, lng: 0)
    @State var clikedMagazineData : MagazineDocument?
    @State private var isSearchViewShown: Bool = false
    
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
    init(){
        UITabBar.appearance().isHidden = true
        
    }
    var body: some View {
        Group{
            if networkManager.isConnected {
                VStack{
                    switch authenticationStore.authenticationState {
                    case .unauthenticated, .authenticating , .freshman:
                        NavigationStack{
                            AuthenticationView(userVM: userVM)
                        }
                    case.authenticated:
                        NavigationStack{
                            
                            
                                TabView(selection: $selectedIndex) {
                                    MagazineMainView(communityVM: communityVM, userVM: userVM, magazineVM: magazineVM, editorVM: editorVM)
                                        .tag(0)
                                    CommunityView(communityVM: communityVM, userVM: userVM, magazineVM: magazineVM)
                                        .tag(1)
                                    
                                    MapView(mapVM: mapVM, userVM : userVM, magazineVM : magazineVM, locationManager : locationManager, clikedMagazineData: clikedMagazineData, userLatitude: userLatitude, userLongitude: userLongitude)
                                        .edgesIgnoringSafeArea(.top)
                                        .tag(3)
                                    MyPageView(commentVm: commentVm, communityVM: communityVM, userVM: userVM, magazineVM: magazineVM, magazineDocument: magazineVM.userPostsFilter(magazineData: magazineVM.magazines, userPostedArr: userVM.postedMagazineID), presented: $presented)
                                        .tag(4)
                                    
                                }
                                .toolbar {
                                    if (selectedIndex == 0) || (selectedIndex == 1) {
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
                                    
                                    if selectedIndex == 4{
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
                                                        
                                    HStack(alignment: .top, spacing: 10) {
                                        ForEach(0..<5, id: \.self) { number in
                                            
                                            
                                            if number == 2 {
                                                
                                                Circle()
                                                    .frame(width: 40, height: 40)
                                                    .foregroundColor(.black)
                                                    .overlay {
                                                        Image(systemName: icons[number])
                                                            .font(.title3)
                                                            .foregroundColor(.white)
                                                            .monospacedDigit()
                                                    }
                                                    .padding(.horizontal, 8)
                                                    .onTapGesture {
                                                        presented.toggle()
                                                        
                                                    }
                                                
                                                
                                            }
                                            else {
                                                VStack{
                                                    Image(systemName: icons[number])
                                                        .font(.title3)
                                                        .foregroundColor(selectedIndex == number ? .black : Color(UIColor.lightGray))
                                                        .monospacedDigit()
                                                    Text(labels[number])
                                                        .font(.caption2)
                                                        .foregroundColor(selectedIndex == number ? .black : Color(UIColor.lightGray))
                                                        .monospacedDigit()
                                                    
                                                }
                                                .frame(width: 65, height: 45)
                                                .onTapGesture {
                                                    self.selectedIndex = number
                                                }
                                            }
                                            
                                        }
                                    }
                            .edgesIgnoringSafeArea(.top)    // <- 지도 때문에 넣음
                            .navigationDestination(isPresented: $isSearchViewShown) {
                                MainSearchView(communityViewModel: communityVM, magazineViewModel: magazineVM, userViewModel: userVM)
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
                        .edgesIgnoringSafeArea(.top)    // <- 지도 때문에 넣음
                    }
                }
                .tint(.black)
                .onAppear{
                    /// 처음부터 마커 데이터를 가지고 있으면 DispatchQueue를 안해도 되지 않을까?
                    self.isSearchViewShown = false
                    editorVM.fetchEditor()
                    magazineVM.fetchMagazine()
                    communityVM.fetchCommunity()
                    userVM.fetchCurrentUser(userID: Auth.auth().currentUser?.uid ?? "")
                    userVM.fetchUser()
                    
                    // 유저 디비 안에 현재 uid값이 있으면 토큰 넣기
                    // 이 조건을 안걸어주면 지금 일어나는 유저 디비에 유저 uid가 없는 사람도 값을 넣어서 유저 디비가 망가짐 - 정훈
//                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 30) {
//                        if let user = userVM.users.first(where: { $0.fields.id.stringValue == Auth.auth().currentUser?.uid ?? ""}){
//                            authenticationStore.addToken()
//                        }
//                    }
                
                }
//                .splashView {
//                    ZStack{
//                        SplashScreen()
//                    }
//
//                }
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
