////
////  UserPageView.swift
////  Grain
////
////  Created by 박희경 on 2023/03/02.
////
// 
//import SwiftUI
//import FirebaseAuth
//import Kingfisher
//
//// 다른 유저들의 프로필 뷰
//// 디테일뷰 -> 유저프로필 클릭했을때 나오는 뷰
//struct UserPageView: View {
//    // MARK: docID -> 파이어스토어 User -> 문서ID 값 유저마다 고유의 값으로 들어가야 될듯
//
//    @StateObject var magazineVM = MagazineViewModel()
//
//    var userVM: UserViewModel
//
//    var userID: String
//
//    @State private var magazines = [MagazineDocument]()
//
//    @State private var showDevices: Bool = false
//    @State private var angle: Double = 0
//
//    // isFollow 초기값 넣어줘야함. 팔로우한 유저인지 먼저 체크
//    // 체크하는 메소드 필요함.
//    @State private var isFollowingUser: Bool = false
//    @State private var isMyProfile: Bool = false
//
//
//    // TODO: 팔로우가 안되어있는 유저이면 "팔로워" 버튼 보여주고, 되어있다면 팔로잉으로(회색처리) 해주기
//    // 팔로우 버튼 눌렀을때 팔로워 팔로잉 각각 유저정보 update해줘야함.
//
//    var body: some View {
//        if let user = userVM.user {
//            NavigationStack {
//                VStack(alignment: .leading) {
//                    VStack(alignment: .leading){
//                        HStack{
//                            //MARK: 프로필 이미지
//                            KFImage(URL(string: user.profileImage.stringValue))
//                                .resizable()
//                                .scaledToFill()
//                                .frame(width: 85, height: 85)
//                                .cornerRadius(64)
//                                .overlay {
//                                    Circle()
//                                        .stroke(lineWidth: 0.1)
//                                }
//                                .padding(.trailing, 10)
//
//                            HStack {
//                                VStack(alignment: .leading){
//                                    Text(user.nickName.stringValue)
//                                        .font(.title3)
//                                        .bold()
//                                        .padding(.leading, 8)
//                                        .padding(.bottom, 1)
//
//                                    VStack(alignment: .leading){
//                                        HStack{
//                                            Text("매거진")
//                                            Text("\(magazines.count)")
//                                                .padding(.leading, -5)
//                                                .bold()
//                                        }
//                                        .padding(.leading, 9)
//                                        .padding(.bottom, 1)
//                                        .foregroundColor(.textGray)
//                                        .font(.footnote)
//
//                                        HStack{
//                                            NavigationLink {
//                                                FollowerListView(userVM: userVM)
//                                            } label: {
//                                                Text("구독자")
//                                            }
//
//                                            Text("\(user.follower.arrayValue.values.count == 1 ? 0 : userVM.follower.count-1)")
//                                                .padding(.leading, -5)
//                                                .bold()
//
//                                            Text("|")
//
//                                            NavigationLink {
//                                                FollowingListView(userVM: userVM)
//                                            } label: {
//                                                Text("구독중")
//                                            }
//
//                                            Text("\(user.following.arrayValue.values.count == 1 ? 0 : userVM.following.count-1)")
//                                                .padding(.leading, -5)
//                                                .bold()
//                                                .padding(.leading, 9)
//                                                .font(.footnote)
//                                                .foregroundColor(.textGray)
//                                        }
//                                    }
//
//                                } // vstack
//
//                                if !isMyProfile {
//                                    Button {
//                                        // userData update
//                                        isFollowingUser.toggle()
//                                    } label: {
//                                        if isFollowingUser {
//                                            RoundedRectangle(cornerRadius: 20)
//                                                .frame(width: 45, height: 25)
//                                                .foregroundColor(.white)
//                                                .overlay{
//                                                    Text("구독중")
//                                                        .foregroundColor(.black)
//                                                        .bold()
//                                                        .font(.caption)
//                                                }
//                                        } else {
//                                            RoundedRectangle(cornerRadius: 20)
//                                                .frame(width: 45, height: 25)
//                                                .foregroundColor(.black)
//                                                .overlay{
//                                                    Text("구독")
//                                                        .foregroundColor(.white)
//                                                        .bold()
//                                                        .font(.caption)
//
//                                                }
//                                        }
//                                    }.border(Color.black, width: 2)
//                                }
//                            }//hstack
//                        }
//                        .padding(.bottom, 15)
//                        //                    .padding(.trailing, 30)
//
//                        VStack(alignment: .leading){
//                            Text(user.introduce.stringValue)
//                                .font(.subheadline)
//                                .lineLimit(3)
//                        }
//                        .padding(.horizontal, 5)
//
//                        VStack{
//                            Button{
//                                showDevices.toggle()
//                            } label: {
//                                VStack(alignment: .leading){
//                                    HStack{
//                                        Text("장비 정보")
//                                            .font(.subheadline)
//                                        Image(systemName: "chevron.right")
//                                            .font(.caption)
//                                            .rotationEffect(Angle(degrees: self.showDevices ? 90 : 0))
//                                            .animation(.linear(duration: self.showDevices ? 0.1 : 0.1), value: showDevices)
//                                    }
//                                    .bold()
//
//
//                                    if showDevices {
//                                        VStack(alignment: .leading){
//                                            if let user = userVM.user {
//                                                user.myCamera.arrayValue.values.count > 1 ? Text("렌즈 | \(user.myLens.arrayValue.values[1].stringValue)") : nil
//
//                                                user.myLens.arrayValue.values.count > 1 ? Text("렌즈 | \(user.myLens.arrayValue.values[1].stringValue)") : nil
//
//                                                user.myCamera.arrayValue.values.count > 1 ? Text("렌즈 | \(user.myLens.arrayValue.values[1].stringValue)") : nil
//                                            }
//                                        }
//                                        .font(.subheadline)
//                                        .padding(.top, -9)
//                                    }
//                                }
//                                .padding(.top, 5)
//                            }
//
//                        }
//                        .padding(.leading, 5)
//                        .padding(.top, -5)
//                        .foregroundColor(.textGray)
//
//
//                    }
//                    .padding(.leading, 20)
//
//                    Rectangle()
//                        .frame(height: 1)
//                        .padding(.horizontal, 10)
//                        .padding(.top, 5)
//                        .foregroundColor(.brightGray)
//                    MyPageMyFeedView(magazineDocument: magazines)
//                }
//            }
//            .onAppear {
//                userVM.fetchUser()
//                userVM.fetchUserProfile(userID: userID)
//                magazineVM.fetchMagazine()
//
//                // 나의 following 리스트에 있는 사람인지 확인
//                if userVM.following.contains(userID) {
//                    isFollowingUser = true // 구독중
//                } else {
//                    isFollowingUser = false // 구독
//                }
//
//                // 내 프로필인지 확인
//                if let currentUser = userVM.currentUsers {
//                    if currentUser.id.stringValue == userID {
//                        isMyProfile = true
//                    } else {
//                        isMyProfile = false
//                    }
//                }
//            }
//            .onReceive(magazineVM.fetchMagazineSuccess, perform: { newValue in
//                self.magazines = magazineVM.filterUserMagazine(userID: userID)
//            })
//            .onDisappear {
//                /// 희경:  userViewModel 에 메소드로 따로 빼주는게 보기 좋을듯.
//                if isFollowingUser {
//                    // "구독중" 상태이고, 내 팔로잉 리스트에 없는 경우 => 구독
//                    if !userVM.following.contains(userID) {
//                        if let user = userVM.user, let currentUser = userVM.currentUsers {
//
//                            var currentUserFollowing: [String] = userVM.following
//                            var magazineUserFollower: [String] = userVM.parsingDataToStringArr(data: user)
//
//                            /// 내 팔로잉리스트에 이사람 id 넣어주고
//                            currentUserFollowing.append(userID)
//                            /// 이사람 팔로워리스트에 내 id 넣어줌.
//                            magazineUserFollower.append(currentUser.id.stringValue)
//
//                            userVM.updateCurrentUserArray(type: "following", arr: currentUserFollowing, docID: currentUser.id.stringValue)
//
//                            userVM.updateCurrentUserArray(type: "follower", arr: magazineUserFollower, docID: user.id.stringValue)
//                        }
//                    }
//                } else {
//                    // "구독" 상태이고, 내 팔로잉 리스트에 있는경우 => 구독취소
//                    if userVM.following.contains(userID) {
//                        if let user = userVM.user, let currentUser = userVM.currentUsers {
//
//                            var currentUserFollowing: [String] = userVM.following
//                            var magazineUserFollower: [String] =  userVM.parsingDataToStringArr(data: user)
//
//                            /// 내 팔로잉리스트에 이사람 id 삭제
//                            currentUserFollowing.removeAll {$0 == userID}
//                            /// 이사람 팔로워리스트에 내 id 삭제
//                            magazineUserFollower.removeAll {$0 == currentUser.id.stringValue}
//
//                            userVM.updateCurrentUserArray(type: "following", arr: currentUserFollowing, docID: currentUser.id.stringValue)
//
//                            userVM.updateCurrentUserArray(type: "follower", arr: magazineUserFollower, docID: user.id.stringValue)
//                        }
//                    }
//                }
//            }
//        }
//    }
//}
