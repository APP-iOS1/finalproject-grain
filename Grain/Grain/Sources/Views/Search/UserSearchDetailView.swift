//
//  UserSearchDetailView.swift
//  Grain
//
//  Created by 조형구 on 2023/02/07.
//

import SwiftUI

struct UserSearchDetailView: View {
    var images: [Image] = [Image("1"), Image("2"), Image("3"), Image("test"), Image("sampleImage"), Image("testImage")]
    let columns = [
        GridItem(.adaptive(minimum: 100))
    ]
    // MARK: docID -> 파이어스토어 User -> 문서ID 값 유저마다 고유의 값으로 들어가야 될듯
    @AppStorage("docID") private var docID : String?
    @ObservedObject var userViewModel: UserViewModel = UserViewModel()
    
    let user: UserDocument
    
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
                Text(user.fields.nickName.stringValue)
                    .font(.title2)
                    .bold()
                Text(user.fields.name.stringValue)
                    .foregroundColor(.textGray)
                Text("자기소개글")
                    .padding(.top, 3)
                UserSearchFeedView(userD: user)

            }
            .onAppear{
                // MARK: userID에 UserDefaults이용해서 저장
//                userViewModel.fetchUser()
            }
        }
    }
}

//struct UserSearchDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserSearchDetailView()
//    }
//}
