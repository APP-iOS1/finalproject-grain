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
    //
    @StateObject var userVm = UserViewModel()
    @State var commentText: String = ""
    
    var body: some View {
        
        VStack {
            ScrollView {
                Text("comment")
            }
            HStack{
                //                 유저 프로필 이미지
                KFImage(URL(string: userVm.currentUsers?.profileImage.stringValue ?? "") ?? URL(string:"https://cdn.travie.com/news/photo/202108/21951_11971_5847.jpg"))
                    .resizable()
                    .frame(width: 40, height: 40)
                    .cornerRadius(30)
                    .overlay {
                        Circle()
                            .stroke(lineWidth: 1)
                    }
                    .padding(.leading)
                MagazineCommentTextField(commnetText: $commentText)
                
            }
            
        }
        .onAppear{
            userVm.fetchCurrentUser(userID: Auth.auth().currentUser?.uid ?? "")
        }
        .navigationTitle("댓글")
        .navigationBarTitleDisplayMode(.inline)
    }
}
struct MagazineCommentTextField: View {
    @Binding var commnetText: String
    @State var uploadButtonShowing : Bool = false
    @StateObject var commentVm = CommentViewModel()
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 30)
                .stroke(Color.brightGray)
                .padding(7)
                .overlay{
                    TextField("댓글 달기...", text: $commnetText)
                        .padding()
                    Spacer()
                    if uploadButtonShowing{
                        Button {
                            commentVm.insertComment(collectionName: "Magazine", collectionDocId: "1BA19CE5-119C-4898-9EC2-0BB920EAC64D", data: CommentFields(comment: CommentString(stringValue: commnetText), profileImage: CommentString(stringValue: ""), nickName: CommentString(stringValue: ""), userID: CommentString(stringValue: ""), id: CommentString(stringValue: UUID().uuidString)))
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
struct MagazineCommentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MagazineCommentView()
        }
    }
}




