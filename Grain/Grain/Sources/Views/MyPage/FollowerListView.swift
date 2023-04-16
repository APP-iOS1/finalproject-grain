//
//  FollowerListView.swift
//  Grain
//
//  Created by 박희경 on 2023/03/01.
//

import SwiftUI
import Kingfisher

struct FollowerListView: View {
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
                ForEach(userVM.filterUserFollow(user: user), id: \.self) { item in
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
            .emptyPlaceholder(userVM.filterUserFollow(user: user)) {
                FollowerPlaceholderView(userNickName: user.fields.nickName.stringValue)
            }
        } //scrollview
        .padding([.leading, .top], 10)
    }
}

struct CurrentUserFollowerListView: View {
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
                ForEach(userVM.followerList, id: \.self) { item in
                    
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
            .emptyPlaceholder(userVM.followerList) {
                CurrentUserFollowerPlaceholderView(userNickName: userVM.currentUsers?.nickName.stringValue ?? "")
            }
        } //scrollview
        .padding([.leading, .top], 10)
    }
}

