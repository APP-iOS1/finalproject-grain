//
//  UserSearchDetailView.swift
//  Grain
//
//  Created by 조형구 on 2023/02/07.
//

import SwiftUI
import Kingfisher
import FirebaseAuth


struct UserSearchDetailView: View {

    @ObservedObject var userVM : UserViewModel
    @ObservedObject var magazineVM: MagazineViewModel
    
    let user: UserDocument
    
    @State private var showDevices: Bool = false
    @State private var angle: Double = 0
    
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
                                
                                Button{
                                    
                                } label: {
                                    RoundedRectangle(cornerRadius: 20)
                                        .frame(width: 50, height: 20)
                                        .overlay{
                                            Text("+ 구독")
                                                .font(.caption)
                                                .bold()
                                                .foregroundColor(.white)
                                            
                                        }
                                }
                                .padding(.trailing)
                            }
                            VStack(alignment: .leading){
                                HStack{
                                    Text("피드")
                                    Text("\(user.fields.postedMagazineID.arrayValue.values.count - 1)")
                                        .padding(.leading, -5)
                                        .bold()
                                }
                                .padding(.leading, 9)
                                .padding(.bottom, 1)
                                .foregroundColor(.textGray)
                                .font(.footnote)
                                
                                HStack{
                                    Text("구독자")
                                    Text("\(user.fields.follower.arrayValue.values.count - 1)")
                                        .padding(.leading, -5)
                                        .bold()
                                    
                                    Text("|")
                                    
                                    Text("구독중")
                                    Text("\(user.fields.following.arrayValue.values.count - 1)")
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
                    //                    .padding(.trailing, 30)
                    
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
                UserPageUserFeedView(userVM: userVM, magazineVM: magazineVM, magazineDocument: magazineVM.otherUserPostsFilter(magazineData: magazineVM.magazines, userPostedArr: user.fields.postedMagazineID.arrayValue.values))
            }
            .onAppear{
                // MARK: userID에 UserDefaults이용해서 저장
                magazineVM.fetchMagazine()
            }
        }
    }
}
