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
    @State private var pushDeleteButton: Bool = false
    
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
        VStack {
            
            if let user = userVM.currentUsers{
                VStack(alignment: .center) {
                    //MARK: 프로필 이미지
                    KFImage(URL(string: userVM.currentUsers?.profileImage.stringValue ?? "") ?? URL(string:  defaultProfileImage()))
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
                        TextEditor(text: $content)
                            .font(.footnote)

                    }
                    
               
                    Section {
                        HStack {
                            Spacer()
                            Button {
                                pushDeleteButton.toggle()
                            } label: {
                                Text("계정 삭제")
                                    .foregroundColor(.red)
                                
                            }
                            .alert(isPresented: $pushDeleteButton) {
                                Alert(title: Text("정말로 계정을 삭제하시겠습니까?"), message: Text("회원님의 모든 데이터들이 영구적으로 삭제됩니다. "), primaryButton: .destructive(Text("삭제"), action: {
                                            // 'Delete' 버튼을 눌렀을 때 실행할 코드 작성
                                            let user: String = Auth.auth().currentUser?.uid ?? ""
                                            let magazines: [String] = userVM.postedMagazineID
                                            let communities: [String] = userVM.postedCommunityID
                                            
                                            // 삭제 되는데, 댓글까지 삭제해야댐
                                            // 댓글 대댓글 삭제하려면 모든 게시글 댓글 get해서 그걸로 delete돌려야댐.
                                            userVM.deleteUser(docID: user)
                                            userVM.deleteUserCommunity(communities: communities)
                                            userVM.deleteUserMagazine(magazines: magazines)
                                        }), secondaryButton: .cancel())
                                    }
                            Spacer()
                        }
                    }
                    
                }
            } //if let

        }
    }
}
    //struct DeleteUserView_Previews: PreviewProvider {
    //    static var previews: some View {
    //        DeleteUserView()
    //    }
    //}
