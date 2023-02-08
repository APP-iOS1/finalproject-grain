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
    
    var body: some View {
        NavigationStack {
            VStack {
                //MARK: 프로필 이미지
                Image("2")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .cornerRadius(64)
                    .overlay {
                        Circle()
                            .stroke(lineWidth: 1.5)
                    }
                Text(userVM.currentUsers?.name.stringValue ?? "")
                    .font(.title2)
                    .bold()
                Text("자기소개글")
                    .padding(.top, 3)
                MyPageMyFeedView(magazineDocument: magazineDocument)
            }
            .onAppear{
                // MARK: userID에 UserDefaults이용해서 저장
                userVM.fetchCurrentUser(userID: docID ?? "")
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        MyPageOptionView(userVM: userVM)
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
//        MyPageView()
//    }
//}
