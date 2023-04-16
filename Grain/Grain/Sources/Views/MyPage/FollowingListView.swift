//
//  FollowingListView.swift
//  Grain
//
//  Created by 박희경 on 2023/03/01.
//

import SwiftUI
import Kingfisher

struct FollowingListView: View {
    @ObservedObject var userVM: UserViewModel
    var user: UserDocument
    @ObservedObject var magagineVM: MagazineViewModel
    
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
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(userVM.filterUserFollowing(user: user), id: \.self) { item in
                    NavigationLink {
                        UserDetailView(userVM: userVM, magazineVM: magagineVM, user: item)
                    } label: {
                        HStack {
                            KFImage(URL(string: item.fields.profileImage.stringValue) ?? URL(string: defaultProfileImage()))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .cornerRadius(64)
                                .overlay {
                                    Circle()
                                        .stroke(lineWidth: 0.1)
                                }
                                .padding([.trailing, .leading], 10)
                            
                            Text(item.fields.nickName.stringValue)
                                .font(.callout)
                                .bold()
                                .padding(.leading, 5)
                                .padding(.bottom, 1)
                            
                            Spacer()
                        }//hstack
                    }
                } // foreach
            } // vstack
            .emptyPlaceholder(userVM.filterUserFollowing(user: user)) {
                FollowingPlaceholderView(userNickName: user.fields.nickName.stringValue)
            }
        } //scrollview
        .padding([.leading, .top], 10)
    }
}

struct CurrentUserFollowingListView: View {
    @ObservedObject var userVM: UserViewModel
    @ObservedObject var magagineVM: MagazineViewModel

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
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(userVM.followingList, id: \.self) { item in
                    NavigationLink {
                        UserDetailView(userVM: userVM, magazineVM: magagineVM, user: item)
                    } label: {
                        HStack {
                            KFImage(URL(string: item.fields.profileImage.stringValue) ?? URL(string: defaultProfileImage()))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .cornerRadius(64)
                                .overlay {
                                    Circle()
                                        .stroke(lineWidth: 0.1)
                                }
                                .padding([.trailing, .leading], 10)
                            
                            Text(item.fields.nickName.stringValue)
                                .font(.callout)
                                .bold()
                                .padding(.leading, 5)
                                .padding(.bottom, 1)
                            
                            Spacer()
                        }//hstack
                    }
                } // foreach
            } // vstack
            .emptyPlaceholder(userVM.followingList) {
                CurrentUserFollowingPlaceholderView()
            }
        } //scrollview
        .padding([.leading, .top], 10)
        .onReceive(userVM.fetchUsersSuccess, perform: { newValue in
            // userVM 의 fetchUser가 수행되어 값이 들어왔을때 currentUser의 팔로워, 팔로잉 리스트를 필터링하는 메소드 실행
            /// 희경: onReceive 메소드 사용 이유: fetchUser 메소드와 fetchCurrentUser메소드를 동시에 실행시키면 fetchUser가 완료되기 전에 fetchCurrentUser가 실행되어 filterCurrentUsersFollow가 제대로 수행되지 않음.
            userVM.filterCurrentUsersFollow()
            userVM.filterCurrentUsersBlock()
            print("Dddd")
        })
    }
}

