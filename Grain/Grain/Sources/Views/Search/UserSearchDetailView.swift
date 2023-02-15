//
//  UserSearchDetailView.swift
//  Grain
//
//  Created by 조형구 on 2023/02/07.
//

import SwiftUI
import Kingfisher
import FirebaseAuth

//struct UserSearchDetailView: View {
//    var images: [Image] = [Image("1"), Image("2"), Image("3"), Image("test"), Image("sampleImage"), Image("testImage")]
//    let columns = [
//        GridItem(.adaptive(minimum: 100))
//    ]
//    // MARK: docID -> 파이어스토어 User -> 문서ID 값 유저마다 고유의 값으로 들어가야 될듯
//
//    @ObservedObject var userViewModel: UserViewModel = UserViewModel()
//
//    let user: UserDocument
//
//    var body: some View {
//        NavigationStack {
//            VStack {
//
//                //MARK: 프로필 이미지
//                Image("2")
//                    .resizable()
//                    .frame(width: 100, height: 100)
//                    .cornerRadius(64)
//                    .overlay {
//                        Circle()
//                            .stroke(lineWidth: 1.5)
//                    }
//                Text(user.fields.nickName.stringValue)
//                    .font(.title2)
//                    .bold()
//                Text(user.fields.name.stringValue)
//                    .foregroundColor(.textGray)
//                Text("자기소개글")
//                    .padding(.top, 3)
//                UserSearchFeedView(userD: user)
//
//            }
//            .onAppear{
//                // MARK: userID에 UserDefaults이용해서 저장
////                userViewModel.fetchUser()
//            }
//        }
//    }
//}

//struct UserSearchDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserSearchDetailView()
//    }
//}
struct UserSearchDetailView: View {
    
    // MARK: docID -> 파이어스토어 User -> 문서ID 값 유저마다 고유의 값으로 들어가야 될듯
    
    @StateObject var userVM = UserViewModel()
    @StateObject var magazineVM = MagazineViewModel()

    let user: UserDocument

    
//    var magazineDocument: [MagazineDocument]
//    var boomarkedMagazineDocument: [MagazineDocument]
//    var bookmarkedCommunityDoument: [CommunityDocument]
    
    @State private var showDevices: Bool = false
    @State private var angle: Double = 0
    //    @State var transitionView: Bool = false
    
    var body: some View {
        NavigationStack {
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
                                    Text("매거진")
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
//                                .padding(.bottom)
                                .font(.footnote)
                                .foregroundColor(.textGray)
//                                .font(.subheadline)
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
                            //                                transitionView.toggle()
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
                UserPageUserFeedView(magazineDocument: magazineVM.otherUserPostsFilter(magazineData: magazineVM.magazines, userPostedArr: user.fields.postedMagazineID.arrayValue.values))                //                    .padding(.top, -80)
            }
            .onAppear{
                // MARK: userID에 UserDefaults이용해서 저장
                magazineVM.fetchMagazine()
            }
        }
    }
}
