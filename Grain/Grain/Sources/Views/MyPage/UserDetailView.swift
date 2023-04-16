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
    @State private var isUserReportAlertShown: Bool = false
    @State private var isUserBlockAlertShown: Bool = false
    
    @Environment(\.presentationMode) var presentationMode

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
        VStack(alignment: .leading) {
            VStack(alignment: .leading){
                HStack{
                    //MARK: 프로필 이미지
                    KFImage(URL(string: user.fields.profileImage.stringValue) ?? URL(string: defaultProfileImage()))
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
                                                    
                                                    var currentUserFollowing: [String] = userVM.following //
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
                                Text("피드")
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
                                        FollowingFollowerView(userVM: userVM, userData: user, magazineVM: magazineVM, selectedIndex: 0)
                                    } label: {
                                        Text("구독자")
                                    }
                                    
                                    Text("\(userData.fields.follower.arrayValue.values.count == 1 ? 0 : userData.fields.follower.arrayValue.values.count-1)")
                                        .padding(.leading, -5)
                                        .bold()
                                    
                                    Text("|")
                                    
                                    NavigationLink {
                                        FollowingFollowerView(userVM: userVM, userData: user, magazineVM: magazineVM, selectedIndex: 1)
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
                // MARK: - 유저 차단 alert
                .alert(isPresented: $isUserBlockAlertShown) {
                    Alert(title: Text("\(user.fields.nickName.stringValue)님을 차단하시겠습니까?"),
                          message: Text("상대방은 Grain에서 회원님의 프로필, 게시물을 찾을 수 없습니다. 상대방에게는 회원님이 차단했다는 정보를 알리지 않습니다."),
                          primaryButton:  .cancel(Text("취소")),
                          secondaryButton:.destructive(Text("차단"),
                                                       action: {
                        if let userData = self.userData {
                            if !userVM.blockingList.contains(userData.fields.id.stringValue) {
                                if let currentUser = userVM.currentUsers {
                               
                                    var myBlockingList: [String] = userVM.blockingList
                                    var userBlockedList: [String] = userVM.parsingBlockedDataToStringArr(data: userData)
                                    
                                    myBlockingList.append(userData.fields.id.stringValue)
                                    userBlockedList.append(currentUser.id.stringValue)
                                    
                                    userVM.updateCurrentUserArray(type: "blocking", arr: myBlockingList, docID: currentUser.id.stringValue)
                                    userVM.updateCurrentUserArray(type: "blocked", arr: userBlockedList, docID: userData.fields.id.stringValue)
                                }
                                
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
                                
                                if userVM.follower.contains(userData.fields.id.stringValue) {
                                    if let currentUser = userVM.currentUsers {
                                        var currentUserFollower: [String] = userVM.follower
                                        var magazineUserFollowing: [String] =  userVM.parsingFollowingDataToStringArr(data: userData)
                                        
                                        /// 내 팔로워리스트에 이사람 id 삭제
                                        currentUserFollower.removeAll {$0 ==  userData.fields.id.stringValue}
                                        /// 이사람 팔로잉리스트에 내 id 삭제
                                        magazineUserFollowing.removeAll {$0 == currentUser.id.stringValue}
                                        
                                        userVM.updateCurrentUserArray(type: "follower", arr: currentUserFollower, docID: currentUser.id.stringValue)
                                        
                                        userVM.updateCurrentUserArray(type: "following", arr: magazineUserFollowing, docID: userData.fields.id.stringValue)
                                    }
                                }
                            }

                        }
                        presentationMode.wrappedValue.dismiss()
                    }))
                }
                VStack(alignment: .leading){
                    Text(user.fields.introduce.stringValue)
                        .font(.subheadline)
                        .lineLimit(3)
                }
                .padding(.horizontal, 5)
                //MARK: - 유저 신고
                .sheet(isPresented: $isUserReportAlertShown) {
                    ReportUserMainView(userVM: userVM, reportID: user.fields.id.stringValue, reportCategory: "User", reportNickname: user.fields.nickName.stringValue, isReportAlertShown: $isUserReportAlertShown, isUserBlockAlertShown: $isUserBlockAlertShown)
                        .presentationDetents([.medium, .large])
                }
                
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
                UserPageUserFeedView(userVM: userVM, magazineVM: magazineVM, magazineDocument: magazineVM.otherUserPostsFilter(magazineData: magazineVM.sortedRecentMagazineData, userPostedArr: userData.fields.postedMagazineID.arrayValue.values))
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
        .onDisappear{
            if isFollowingUser == true {
                let sender = PushNotificationSender(serverKeyString: "")
                for i in user.fields.fcmToken.arrayValue.values {
                    sender.sendPushNotification(to: i.stringValue, title: "구독", message: "\(userVM.currentUsers?.nickName.stringValue ?? "")님이 \(userData?.fields.nickName.stringValue ?? "")님을 구독합니다 ", image: "")
                }
            }
        }
        .toolbar{
            if user.fields.id.stringValue != Auth.auth().currentUser?.uid{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(role: .destructive, action: { self.isUserReportAlertShown.toggle()}) {
                            Label("신고", systemImage: "exclamationmark.bubble")
                        }
                        Button(role: .destructive, action: { self.isUserBlockAlertShown.toggle()}) {
                            Label("차단", systemImage: "person.fill.xmark")
                        }
                        
                    } label: {
                        Label("더보기", systemImage: "ellipsis")
                        
                    }
                    
                }
            }
        }
    }
}
