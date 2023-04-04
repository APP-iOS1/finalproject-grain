//
//  UserDetailView.swift
//  Grain
//
//  Created by 박희경 on 2023/03/06.
//

import SwiftUI
import FirebaseAuth
import Kingfisher

struct UserDetailView: View {

    @ObservedObject var userVM: UserViewModel
    @ObservedObject var magazineVM : MagazineViewModel
    
    @State private var showDevices: Bool = false
    @State private var angle: Double = 0
    // 유저가 올린 메거진 데이터
    @State var magazines = [MagazineDocument]()
    // isFollow 초기값 넣어줘야함. 팔로우한 유저인지 먼저 체크
    @State private var isFollowingUser: Bool = false
    // 내 프로필인지 체크 (구독버튼을 보여줄지 판단하기 위해)
    @State private var isMyProfile: Bool = false
    
    let user: UserDocument
    @State var userData: UserDocument?
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading){
                HStack{
                    //MARK: 프로필 이미지
                    KFImage(URL(string: user.fields.profileImage.stringValue) ?? URL(string:"https://cdn.travie.com/news/photo/202108/21951_11971_5847.jpg"))
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
                        HStack{
                            Text(user.fields.nickName.stringValue)
                                .font(.title3)
                                .bold()
                                .padding(.leading, 8)
                                .padding(.bottom, 1)
                            
                            Spacer()
                            
                            if let userData = self.userData {
                                if !isMyProfile {
                                    Button {
                                        // userData update
                                        isFollowingUser.toggle()
                                        /// 희경:  userViewModel 에 메소드로 따로 빼주는게 보기 좋을듯.
                                        if isFollowingUser {
                                            // "구독중" 상태이고, 내 팔로잉 리스트에 없는 경우 => 구독
                                            if !userVM.following.contains(userData.fields.id.stringValue) {
                                                if let currentUser = userVM.currentUsers {
                                                    
                                                    var currentUserFollowing: [String] = userVM.following
                                                    var magazineUserFollower: [String] = userVM.parsingFollowerDataToStringArr(data: userData)
                                                    
                                                    /// 내 팔로잉리스트에 이사람 id 넣어주고
                                                    currentUserFollowing.append(userData.fields.id.stringValue)
                                                    /// 이사람 팔로워리스트에 내 id 넣어줌.
                                                    magazineUserFollower.append(currentUser.id.stringValue)
                                                    
                                                    userVM.updateCurrentUserArray(type: "following", arr: currentUserFollowing, docID: currentUser.id.stringValue)
                                                    
                                                    userVM.updateCurrentUserArray(type: "follower", arr: magazineUserFollower, docID: userData.fields.id.stringValue)
                                                }
                                            }
                                            let sender = PushNotificationSender(serverKeyString: "")
                                            for i in user.fields.fcmToken.arrayValue.values {
                                                sender.sendPushNotification(to: i.stringValue, title: "구독", message: "\(userVM.currentUsers?.nickName.stringValue ?? "")님이 \(userData.fields.nickName.stringValue) 을 구독합니다 ", image: "")
                                            }
                                            
                                            
                                        } else {
                                            // "구독" 상태이고, 내 팔로잉 리스트에 있는경우 => 구독취소
                                            if userVM.following.contains(userData.fields.id.stringValue) {
                                                if let currentUser = userVM.currentUsers {
                                                    var currentUserFollowing: [String] = userVM.following
                                                    var magazineUserFollower: [String] =  userVM.parsingFollowerDataToStringArr(data: userData)
                                                    
                                                    /// 내 팔로잉리스트에 이사람 id 삭제
                                                    currentUserFollowing.removeAll {$0 ==  userData.fields.id.stringValue}
                                                    /// 이사람 팔로워리스트에 내 id 삭제
                                                    magazineUserFollower.removeAll {$0 == currentUser.id.stringValue}
                                                    
                                                    userVM.updateCurrentUserArray(type: "following", arr: currentUserFollowing, docID: currentUser.id.stringValue)
                                                    
                                                    userVM.updateCurrentUserArray(type: "follower", arr: magazineUserFollower, docID: userData.fields.id.stringValue)
                                                }
                                            }
                                        }
                                    } label: {
                                        if isFollowingUser {
                                            RoundedRectangle(cornerRadius: 20)
                                                .frame(width: 50, height: 20)
                                                .overlay{
                                                    Text("구독중")
                                                        .font(.caption)
                                                        .bold()
                                                        .foregroundColor(.white)
                                                    
                                                }
                                        } else {
                                            RoundedRectangle(cornerRadius: 20)
                                                .frame(width: 50, height: 20)
                                                .overlay{
                                                    Text("+ 구독")
                                                        .font(.caption)
                                                        .bold()
                                                        .foregroundColor(.white)
                                                    
                                                }
                                        }
                                    }.padding(.trailing, 20)
                                }
                            }
                        }//hstack
                        VStack(alignment: .leading){
                            HStack{
                                Text("매거진")
                                Text("\(magazines.count)")
                                    .padding(.leading, -5)
                                    .bold()
                            }
                            .padding(.leading, 9)
                            .padding(.bottom, 1)
                            .foregroundColor(.textGray)
                            .font(.footnote)
                            
                            if let userData = self.userData {
                                HStack{
                                    NavigationLink {
                                        FollowingFollowerView(userVM: userVM, userData: userData, magazineVM: magazineVM, selectedIndex: 0)
                                    } label: {
                                        Text("구독자")
                                    }
                                    
                                    Text("\(userData.fields.follower.arrayValue.values.count == 1 ? 0 : userData.fields.follower.arrayValue.values.count-1)")
                                        .padding(.leading, -5)
                                        .bold()
                                    
                                    Text("|")
                                    
                                    NavigationLink {
                                        FollowingFollowerView(userVM: userVM, userData: userData, magazineVM: magazineVM, selectedIndex: 1)
                                    } label: {
                                        Text("구독중")
                                    }
                                    
                                    Text("\(userData.fields.following.arrayValue.values.count == 1 ? 0 : userData.fields.following.arrayValue.values.count-1)")
                                        .padding(.leading, -5)
                                        .bold()
                                }
                                .padding(.leading, 9)
                                .font(.footnote)
                                .foregroundColor(.textGray)
                            }
                        }
                    } // vstack
                    
                    
                }
                .padding(.bottom, 15)
                
                VStack(alignment: .leading){
                    Text(user.fields.introduce.stringValue)
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
                                    user.fields.myCamera.arrayValue.values.count > 1 ? Text("바디 | \(user.fields.myCamera.arrayValue.values[1].stringValue)") : nil
                                    
                                    user.fields.myLens.arrayValue.values.count > 1 ? Text("렌즈 | \(user.fields.myLens.arrayValue.values[1].stringValue)") : nil
                                    
                                    user.fields.myFilm.arrayValue.values.count > 1 ? Text("필름 | \(user.fields.myFilm.arrayValue.values[1].stringValue)") : nil
                                    
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
            if let userData = self.userData {
                UserPageUserFeedView(userVM: userVM, magazineVM: magazineVM, magazineDocument: magazineVM.otherUserPostsFilter(magazineData: magazineVM.magazines, userPostedArr: userData.fields.postedMagazineID.arrayValue.values))
            }
        }
        .onAppear{
            self.userData = user
            
        }
        .task(id: userVM.users) {
            if let user = userVM.users.first(where: {
                $0.fields.id.stringValue == user.fields.id.stringValue
            }) {
                self.userData = user
            }
        }
        .onReceive(magazineVM.fetchMagazineSuccess, perform: { newValue in
            self.magazines = magazineVM.filterUserMagazine(userID: user.fields.id.stringValue)
        })
        .onReceive(userVM.fetchCurrentUsersSuccess, perform: { _ in
            if let userData = self.userData {
                // 나의 following 리스트에 있는 사람인지 확인
                if userVM.following.contains(userData.fields.id.stringValue) {
                    isFollowingUser = true // 구독중
                } else {
                    isFollowingUser = false // 구독
                }
                
                // 내 프로필인지 확인
                if let currentUser = userVM.currentUsers {
                    if currentUser.id.stringValue == userData.fields.id.stringValue {
                        isMyProfile = true
                    } else {
                        isMyProfile = false
                        
                    }
                }
            }
        })
    }
}
