//
//  MagazineCommentView.swift
//  Grain
//
//  Created by 조형구 on 2023/02/08.
//

import SwiftUI
import Kingfisher
import FirebaseAuth

struct MagazineCommentView: View {
    
    var currentUser : CurrentUserFields?  //현재 유저 받아오기
    @State var commentText: String = ""
    
    var body: some View {
        
        VStack {
            ScrollView {
                // 댓글이 들어갈 자리
                Text("comment")
            }
            HStack{
                //                 유저 프로필 이미지
                KFImage(URL(string: currentUser?.profileImage.stringValue ?? "") ?? URL(string:"https://cdn.travie.com/news/photo/202108/21951_11971_5847.jpg"))
                    .resizable()
                    .frame(width: 40, height: 40)
                    .cornerRadius(30)
                    .overlay {
                        Circle()
                            .stroke(lineWidth: 1)
                    }
                    .padding(.leading)
                MagazineCommentTextField(commentText: $commentText, currentUser: currentUser)
            }.onAppear{
                print(currentUser?.profileImage.stringValue)
            }
            
        }
        .navigationTitle("댓글")
        .navigationBarTitleDisplayMode(.inline)
    }
}
struct MagazineCommentTextField: View {
    @Binding var commentText: String
    @State var uploadButtonShowing : Bool = false
    var currentUser : CurrentUserFields?  //현재 유저 받아오기
    
    @StateObject var commentVm = CommentViewModel()
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 30)
                .stroke(Color.brightGray)
                .padding(7)
                .overlay{
                    TextField("댓글 달기...", text: $commentText)
                        .padding()
                    Spacer()
                    if uploadButtonShowing{
                        Button {
                            // MARK: 댓글 업로드 구혀
                            commentVm.insertComment(
                                collectionName: "Magazine",
                                collectionDocId: "1BA19CE5-119C-4898-9EC2-0BB920EAC64D",
                                data: CommentFields(
                                    comment: CommentString(stringValue: commentText),
                                    profileImage: CommentString(stringValue: currentUser?.profileImage.stringValue ?? ""),
                                    nickName: CommentString(stringValue: currentUser?.nickName.stringValue ?? ""),
                                    userID: CommentString(stringValue: Auth.auth().currentUser?.uid ?? ""),
                                    id: CommentString(stringValue: UUID().uuidString)
                                    )
                                )
                            
                            uploadButtonShowing.toggle()
                        } label: {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }.offset(x: 130)
                    }
                    
                }
                .onTapGesture {
                    uploadButtonShowing.toggle()
                }
            
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .frame(height: 56)
        
    }
}

//struct MagazineCommentView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack {
//            MagazineCommentView()
//        }
//    }
//}




