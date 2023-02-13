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
//    var images: [Image] = [Image("1"), Image("2"), Image("3"), Image("test"), Image("sampleImage"), Image("testImage")]
//    let columns = [
//        GridItem(.adaptive(minimum: 100))
//    ]
    // MARK: docID -> 파이어스토어 User -> 문서ID 값 유저마다 고유의 값으로 들어가야 될듯
     
    @StateObject var userVM = UserViewModel()
    
    var magazineDocument: [MagazineDocument]
    var boomarkedMagazineDocument: [MagazineDocument]
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                VStack(alignment: .leading){
                    HStack{
                        //MARK: 프로필 이미지
                        KFImage(URL(string: userVM.currentUsers?.profileImage.stringValue ?? "") ?? URL(string:"https://cdn.travie.com/news/photo/202108/21951_11971_5847.jpg"))
                            .resizable()
                            .frame(width: 85, height: 85)
                            .cornerRadius(64)
                            .overlay {
                                Circle()
                                    .stroke(lineWidth: 1.2)
                            }
                            .padding(.trailing)

                        VStack(alignment: .leading){
                            Text(userVM.currentUsers?.introduce.stringValue ?? "자기소개를 작성해보세요")
                                .font(.subheadline)
                                .lineLimit(3)
                                .padding(.top, 2)
                        }
                    }
                    .padding(.bottom, 15)
                    .padding(.trailing, 30)

//                    Text("userNickName")
                    VStack(alignment: .leading){
                        Text(userVM.currentUsers?.nickName.stringValue ?? "닉네임 없음")
                            .font(.headline)
                            .padding(.leading, 8)

                        HStack{
                            Text("팔로워 123124")
                            Text("|")
                            Text("팔로잉 123")
                        }
                        .padding(.leading, 9)
                        .padding(.top, -5)
                        .font(.footnote)
                        .foregroundColor(.textGray)

                    }
//                    ZStack(alignment: .bottomLeading){
//                        Image("3")
//                            .resizable()
//                            .scaledToFill()
//                            .frame(height: Screen.maxHeight / 2.8)
//                            .ignoresSafeArea()
//
//                        VStack{
//                            Text("nickN")
//                                .font(.title)
//                                .bold()
//                                .frame(width: 300)
//                                .padding(.leading, 80)
//
//                            VStack{
//                                Text("전국을 돌아다니며 ")
//                            }
//                            .frame(width: 300)
//                            .padding(.leading, 105)
//                            HStack{
//                                Text("팔로우")
//                                Text("|")
//                                Text("팔로워")
//                            }
//                        }
//                        .frame(width: 200, height: 100)
//                        .padding()
//                    }
//                    .frame(width: Screen.maxWidth, height: Screen.maxHeight / 3)
//                    .foregroundColor(.white)
                }
                .padding(.leading, 20)
//                Image("2")
//                    .resizable()
//                    .frame(width: Screen.maxWidth, height: Screen.maxHeight / 3.5)
//                    .scaledToFit()
//                    .blur(radius: 1)
////                    .edgesIgnoringSafeArea(.top)
//                    .overlay{
//                        VStack(alignment: .leading){
//                            Text("nickNam")
//                                .font(.title)
//                                .bold()
//                            Text("전국을 돌아다니며 사진찍으러 다닙니다 같이 찍어요~!")
////                                .frame(width: Screen.maxWidth / 1.5)
////                                .padding(.trailing, 50)
//
//                            HStack{
//                                Text("팔로우 12213")
//                                Text("|")
//                                Text("팔로워 231")
//                            }
//                        }
//                        .padding(.bottom, 30)
//                        .padding(.trailing, 100)
//                    }.foregroundColor(.white)
                                
                MyPageMyFeedView(magazineDocument: magazineDocument)
//                    .padding(.top, -80)
            }
            .onAppear{
                // MARK: userID에 UserDefaults이용해서 저장
                userVM.fetchCurrentUser(userID: Auth.auth().currentUser?.uid ?? "")
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        MyPageOptionView(userVM: userVM, bookmarkedMagazineDocument: boomarkedMagazineDocument)
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
}

struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView(magazineDocument: [], boomarkedMagazineDocument: [])
    }
}







