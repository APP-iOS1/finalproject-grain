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
    @ObservedObject var authenticationStore : AuthenticationStore = AuthenticationStore()
    
    
    var magazineDocument: [MagazineDocument]
    var boomarkedMagazineDocument: [MagazineDocument]
    var bookmarkedCommunityDoument: [CommunityDocument]
    
    @State private var showDevices: Bool = false
    @State private var angle: Double = 0
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                VStack(alignment: .leading){
                    HStack{
                        //MARK: 프로필 이미지
                        KFImage(URL(string: userVM.currentUsers?.profileImage.stringValue ?? "") ?? URL(string:"https://cdn.travie.com/news/photo/202108/21951_11971_5847.jpg"))
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
                            Text(userVM.currentUsers?.nickName.stringValue ?? "123456789101789")
                                .font(.title3)
                                .bold()
                                .padding(.leading, 8)
                                .padding(.bottom, 1)
                            
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
                                        CurrentUserFollowerListView(userVM: userVM)
                                    } label: {
                                        Text("구독자")
                                    }
                                    
                                    Text("\(userVM.follower.count == 1 ? 0 : userVM.follower.count-1)")
                                        .padding(.leading, -5)
                                        .bold()

                                    Text("|")

                                    NavigationLink {
                                        CurrentUserFollowingListView(userVM: userVM)
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
                    
                    VStack{
                        Button{
                            showDevices.toggle()
                        } label: {
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
                                
                                
                                if showDevices {
                                    VStack(alignment: .leading){
                                        userVM.myCamera.count > 1 ? Text("바디 | \(userVM.myCamera[1])") : nil
                                        
                                        userVM.myLens.count > 1 ? Text("렌즈 | \(userVM.myLens[1])") : nil
                                        
                                        userVM.myFilm.count > 1 ? Text("필름 | \(userVM.myFilm[1])") : nil
                                        
                                    }
                                    .font(.subheadline)
                                    .padding(.top, -9)
                                }
                            }
                            .padding(.top, 5)
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
                MyPageMyFeedView(userVM: userVM, magazineVM: magazineVM, magazineDocument: magazineDocument)
            }
            .onAppear{
                // MARK: userID에 UserDefaults이용해서 저장
                userVM.fetchUser()
                userVM.fetchCurrentUser(userID: Auth.auth().currentUser?.uid ?? "")
            }
            .onReceive(userVM.fetchUsersSuccess, perform: { newValue in
                // userVM 의 fetchUser가 수행되어 값이 들어왔을때 currentUser의 팔로워, 팔로잉 리스트를 필터링하는 메소드 실행
                /// 희경: onReceive 메소드 사용 이유: fetchUser 메소드와 fetchCurrentUser메소드를 동시에 실행시키면 fetchUser가 완료되기 전에 fetchCurrentUser가 실행되어 filterCurrentUsersFollow가 제대로 수행되지 않음.
                userVM.filterCurrentUsersFollow()
            })
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        MyPageOptionView(commentVm: commentVm,communityVM: communityVM, magazineVM: magazineVM, userVM: userVM, bookmarkedMagazineDocument: boomarkedMagazineDocument, bookmarkedCommunityDoument: bookmarkedCommunityDoument)
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
}

//struct MyPageView_Previews: PreviewProvider {
//    static var previews: some View {
//        MyPageView(magazineDocument: [], boomarkedMagazineDocument: [], bookmarkedCommunityDoument: [])
//    }
//}
