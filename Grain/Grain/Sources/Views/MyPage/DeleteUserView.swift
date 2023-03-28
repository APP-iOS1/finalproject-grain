//
//  DeleteUserView.swift
//  Grain
//
//  Created by 박희경 on 2023/03/28.
//

import SwiftUI
import Kingfisher
import FirebaseAuth

struct DeleteUserView: View {
    @ObservedObject var userVM: UserViewModel
    @State private var content: String = ""
    
    var body: some View {
        VStack {
            
            if let user = userVM.currentUsers{
                VStack(alignment: .center) {
                    //MARK: 프로필 이미지
                    KFImage(URL(string: userVM.currentUsers?.profileImage.stringValue ?? "") ?? URL(string: "https://firebasestorage.googleapis.com/v0/b/grain-final.appspot.com/o/EditorFolder%2FdefaultImage%2Fdefault-user-icon-8.jpg?alt=media&token=1a514506-df59-484f-affb-b000ad1f348d"))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 85, height: 85)
                        .cornerRadius(64)
                        .overlay {
                            Circle()
                                .stroke(lineWidth: 0.1)
                        }
                        .padding(.trailing, 10)
                    
                    Text("\(user.nickName.stringValue) 님")
                        .bold()
                        .font(.title2)
                        .padding(.bottom, 3)
                    Text("정말로 계정을 삭제하시겠어요?🥹")
                        .bold()
                        .font(.title2)
                        .padding(.bottom, 30)
                    
                }.padding(.top, 30)
                
                Form{
                    Section("계정을 삭제하실 경우"){
                        Text("회원님의 구독자가 즉시 유실되며, 프로필사진과 모든 메거진, 커뮤니티 게시글이 영구적으로 삭제되어 다시 복구하실 수 없습니다. 정말로 삭제하시겠습니까?")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    
                    Section("계정을 삭제하는 이유를 알려주시면, 사용자님의 피드백을 바탕으로 더 나은 서비스를 제공하도록 노력하겠습니다.") {
                        TextField("내용을 입력해주세요", text: $content)
                            .font(.footnote)
                            .frame(height: 50)
                    }
                    
               
                    Section {
                        HStack {
                            Spacer()
                            Button {
                                let user: String = Auth.auth().currentUser?.uid ?? ""
                                let magazines: [String] = userVM.postedMagazineID
                                let communities: [String] = userVM.postedCommunityID
                                
                                // 삭제 되는데, 댓글까지 삭제해야댐
                                // 댓글 대댓글 삭제하려면 모든 게시글 댓글 get해서 그걸로 delete돌려야댐.
                                userVM.deleteUser(docID: user)
                                userVM.deleteUserCommunity(communities: communities)
                                userVM.deleteUserMagazine(magazines: magazines)
                            } label: {
                                Text("계정 삭제")
                                    .foregroundColor(.red)
                                
                            }
                            Spacer()
                        }
                    }
                    
                }
                
//                Button {
//                    // Test 입니다.
//                    //                                    let communities = ["4DF7212F-C40A-4A3A-90CE-3FF7155F6B30", "7AD561C1-EDF7-4DE9-9D4A-D1105407DEF2", "E5319C60-BF4C-45BE-A044-FFA6C5DAF2E5"]
//                    //                                    let magazines = ["4DD2A340-7A73-4149-A6D1-91E94699BC44", "F6194339-6932-44D6-BAB7-8EAFD7A7BB05"]
//
//                    let user: String = Auth.auth().currentUser?.uid ?? ""
//                    let magazines: [String] = userVM.postedMagazineID
//                    let communities: [String] = userVM.postedCommunityID
//
//                    // 삭제 되는데, 댓글까지 삭제해야댐
//                    // 댓글 대댓글 삭제하려면 모든 게시글 댓글 get해서 그걸로 delete돌려야댐.
//                    userVM.deleteUser(docID: user)
//                    userVM.deleteUserCommunity(communities: communities)
//                    userVM.deleteUserMagazine(magazines: magazines)
//                } label: {
//                    Text("유저탈퇴 테스트")
//                }

            } //if let

        }
    }
}
    //struct DeleteUserView_Previews: PreviewProvider {
    //    static var previews: some View {
    //        DeleteUserView()
    //    }
    //}
