//
//  MyPageView.swift
//  Grain
//
//  Created by 한승수 on 2023/01/31.
//

import SwiftUI
import Kingfisher

struct MyPageView: View {
//    var images: [Image] = [Image("1"), Image("2"), Image("3"), Image("test"), Image("sampleImage"), Image("testImage")]
    let columns = [
        GridItem(.adaptive(minimum: 100))
    ]
    // MARK: docID -> 파이어스토어 User -> 문서ID 값 유저마다 고유의 값으로 들어가야 될듯
    @AppStorage("docID") private var docID : String?
    @StateObject var userVM = UserViewModel()
    
    var magazineDocument: [MagazineDocument]
    var boomarkedMagazineDocument: [MagazineDocument]
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(alignment: .leading){
                    HStack{
                        //MARK: 프로필 이미지
                        KFImage(URL(string: userVM.currentUsers?.profileImage.stringValue ?? "") ?? URL(string:"https://cdn.travie.com/news/photo/202108/21951_11971_5847.jpg"))
                            .resizable()
                            .frame(width: 90, height: 90)
                            .cornerRadius(64)
                            .overlay {
                                Circle()
                                    .stroke(lineWidth: 1.5)
                            }
                            .padding(.trailing)
                        
                        VStack(alignment: .leading){
                            Text("자기소개 글 blah blahblahblahblahblahblah")
                                .lineLimit(3)
                                .padding(.top, 2)
                        }
                    }
                    .padding(.bottom)
                    .padding(.trailing, 30)
                    
//                    Text("userNickName")
                    Text(userVM.currentUsers?.nickName.stringValue ?? "닉네임 없음")
                        .font(.title3)
                        .bold()
                        .padding(.leading, 8)
                }
                MyPageMyFeedView(magazineDocument: magazineDocument)
            }
            .onAppear{
                // MARK: userID에 UserDefaults이용해서 저장
                userVM.fetchCurrentUser(userID: docID ?? "")
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

//struct MyPageView_Previews: PreviewProvider {
//    static var previews: some View {
//        MyPageView(magazineDocument: [], boomarkedMagazineDocument: [])
//    }
//}
