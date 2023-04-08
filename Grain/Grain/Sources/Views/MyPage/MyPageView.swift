//
//  MyPageView.swift
//  Grain
//
//  Created by 한승수 on 2023/01/31.
//

import SwiftUI
import Kingfisher
import FirebaseAuth

struct MyPageView: View {
    @ObservedObject var commentVm: CommentViewModel
    @ObservedObject var communityVM : CommunityViewModel
    @ObservedObject var userVM : UserViewModel
    @ObservedObject var magazineVM: MagazineViewModel
    @EnvironmentObject var authenticationStore: AuthenticationStore
    
    
    var magazineDocument: [MagazineDocument]
    //    var boomarkedMagazineDocument: [MagazineDocument]
    //    var bookmarkedCommunityDoument: [CommunityDocument]
    
    @State private var showDevices: Bool = false
    @State private var angle: Double = 0
    
    @Binding var presented: Bool
    @Binding var scrollToTop: Bool

    func defaultProfileImage() -> String{
        var https : String = "https://"
        if let infolist = Bundle.main.infoDictionary {
            if let url = infolist["FailProfileImage"] as? String {
                https += url
            }
        }
        return https
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                VStack(alignment: .leading){
                    HStack{
                        //MARK: 프로필 이미지
                        KFImage(URL(string: userVM.currentUsers?.profileImage.stringValue ?? "") ?? URL(string: defaultProfileImage()))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 85, height: 85)
                            .cornerRadius(64)
                            .overlay {
                                Circle()
                                    .stroke(lineWidth: 0.1)
                            }
                            .padding(.trailing, 10)
                        
                        VStack(alignment: .leading){
                            HStack {
                                Text(userVM.currentUsers?.nickName.stringValue ?? "123456789101789")
                                    .font(.title3)
                                    .bold()
                                    .padding(.leading, 8)
                                    .padding(.bottom, 1)
                                
                                
                            }
                            VStack(alignment: .leading){
                                HStack{
                                    Text("매거진")
                                    Text("\(userVM.postedMagazineID.count - 1)")
                                        .padding(.leading, -5)
                                        .bold()
                                }
                                .padding(.leading, 9)
                                .padding(.bottom, 1)
                                .foregroundColor(.textGray)
                                .font(.footnote)
                                
                                HStack{
                                    NavigationLink {
                                        //                                        CurrentUserFollowerListView(userVM: userVM)
                                        CurrentUserFollowingFollowerView(userVM: userVM, magazineVM: magazineVM, selectedIndex: 0)
                                        //                                            .onAppear{
                                        //                                                selectedIndex = 0
                                        //                                            }
                                    } label: {
                                        Text("구독자")
                                    }
                                    
                                    
                                    Text("\(userVM.follower.count == 1 ? 0 : userVM.follower.count-1)")
                                        .padding(.leading, -5)
                                        .bold()
                                    
                                    Text("|")
                                    
                                    NavigationLink {
                                        //                                        CurrentUserFollowingListView(userVM: userVM)
                                        CurrentUserFollowingFollowerView(userVM: userVM, magazineVM: magazineVM, selectedIndex: 1)
                                        //                                            .onAppear{
                                        //                                                selectedIndex = 1
                                        //                                            }
                                        
                                    } label: {
                                        Text("구독중")
                                    }
                                    
                                    
                                    Text("\(userVM.following.count == 1 ? 0 : userVM.following.count-1)")
                                        .padding(.leading, -5)
                                        .bold()
                                }
                                .padding(.leading, 9)
                                .font(.footnote)
                                .foregroundColor(.textGray)
                            }
                        }
                    }
                    .padding(.bottom, 15)
                    
                    VStack(alignment: .leading){
                        Text(userVM.currentUsers?.introduce.stringValue ?? "자기 소개를 작성해보세요")
                            .font(.subheadline)
                            .lineLimit(3)
                    }
                    .padding(.horizontal, 5)
                    
                    VStack(alignment: .leading){
                        HStack{
                            Text("장비 정보")
                                .font(.subheadline)
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .rotationEffect(Angle(degrees: self.showDevices ? 90 : 0))
                                .animation(.linear(duration: self.showDevices ? 0.1 : 0.1), value: showDevices)
                        }
                        .bold()
                        .padding(.top, 5)
                        .onTapGesture {
                            withAnimation {
                                showDevices.toggle()
                            }
                        }
                        
                        if showDevices {
                            VStack(alignment: .leading){
                                userVM.myCamera.count > 1 ? Text("바디 \(Image(systemName: "poweron")) \(userVM.myCamera[1])") : nil
                                
                                userVM.myLens.count > 1 ? Text("렌즈 \(Image(systemName: "poweron")) \(userVM.myLens[1])") : nil
                                
                                userVM.myFilm.count > 1 ? Text("필름 \(Image(systemName: "poweron")) \(userVM.myFilm[1])") : nil
                                
                            }
                            .font(.subheadline)
                            .padding(.top, -9)
                            .transition(.moveAndFade)
                            .animation(.default, value: showDevices)

                        }
                        
                    }
                    .padding(.leading, 5)
                    .padding(.top, -5)
                    .foregroundColor(.textGray)
                    
                    
                }
                .padding(.leading, 20)
                
                Rectangle()
                    .frame(height: 1)
                    .padding(.horizontal, 10)
                    .padding(.top, 5)
                    .foregroundColor(.brightGray)
                MyPageMyFeedView(userVM: userVM, magazineVM: magazineVM, magazineDocument: magazineDocument, presented: $presented, scrollToTop: $scrollToTop)
            }
            .onAppear{
                // MARK: userID에 UserDefaults이용해서 저장
                userVM.fetchUser()
                userVM.fetchCurrentUser(userID: Auth.auth().currentUser?.uid ?? "")
                
                // 로그인을 할때 토큰값 넣기 -> 로그아웃 하고 로그인하는 사람이 있어서 어쩔수 없이 마이페이지 쪽에도 토큰 넣는것을 넣어야할듯!
                if authenticationStore.authenticationState == .authenticated{
                    authenticationStore.addToken()
                }
                
            }
            .onReceive(userVM.fetchUsersSuccess, perform: { newValue in
                // userVM 의 fetchUser가 수행되어 값이 들어왔을때 currentUser의 팔로워, 팔로잉 리스트를 필터링하는 메소드 실행
                /// 희경: onReceive 메소드 사용 이유: fetchUser 메소드와 fetchCurrentUser메소드를 동시에 실행시키면 fetchUser가 완료되기 전에 fetchCurrentUser가 실행되어 filterCurrentUsersFollow가 제대로 수행되지 않음.
                userVM.filterCurrentUsersFollow()
            })
          
        }
        .refreshable {
            userVM.fetchUser()
            userVM.fetchCurrentUser(userID: Auth.auth().currentUser?.uid ?? "")
        }
    }
}

//struct MyPageView_Previews: PreviewProvider {
//    static var previews: some View {
//        MyPageView(magazineDocument: [], boomarkedMagazineDocument: [], bookmarkedCommunityDoument: [])
//    }
//}
