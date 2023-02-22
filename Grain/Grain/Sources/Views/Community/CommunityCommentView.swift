//
//  CommunityCommentView.swift
//  Grain
//
//  Created by 윤소희 on 2023/02/15.
//


import SwiftUI
import UIKit
import FirebaseAuth
import Kingfisher

//MARK: 댓글 입력창
struct CommunityCommentView: View {
    
    var currentUser : CurrentUserFields?  //현재 유저 받아오기
    let community: CommunityDocument
    @StateObject var communityVM = CommunityViewModel()
    @StateObject var userVM = UserViewModel()
    @StateObject var commentVm = CommentViewModel()
    @State var replyContent: String = ""
    
    var trimContent: String {
        replyContent.trimmingCharacters(in: .whitespaces)
    }
    
    var body: some View {
//        VStack{
//            RoundedRectangle(cornerRadius: 3)
//                .foregroundColor(.white)
//                .border(.gray)
//                .frame(width: Screen.maxWidth*0.94, height: Screen.maxWidth*0.1)
//                .overlay{
//                    HStack {
//                        TextField("댓글을 작성해주세요", text: $replyContent, axis: .vertical)
//                        if trimContent.count > 0 {
//                            Button {
//                                commentVm.insertComment(collectionName: "Community", collectionDocId: community.fields.id.stringValue, data: CommentFields(comment: CommentString(stringValue: replyContent), profileImage: CommentString(stringValue: community.fields.profileImage.stringValue), nickName: CommentString(stringValue: community.fields.nickName.stringValue), userID: CommentString(stringValue: Auth.auth().currentUser?.uid ?? ""), id: CommentString(stringValue: UUID().uuidString)))
//                                replyContent = ""
//                            } label: {
//                                Image(systemName: "paperplane")
//                                    .foregroundColor(.black)
//                            }
//                        }
//                    }
//                    .padding(.horizontal, 10)
//                }
//        }
        HStack{
            KFImage(URL(string: currentUser?.profileImage.stringValue ?? "") ?? URL(string:"https://cdn.travie.com/news/photo/202108/21951_11971_5847.jpg"))
                .resizable()
                .frame(width: 35, height: 35)
                .cornerRadius(30)
                .overlay {
                    Circle()
                        .stroke(lineWidth: 0.5)
                }
                .padding(.leading)
            
            TextField("댓글 달기...", text: $replyContent)
                .padding()
                .overlay{
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(lineWidth: 1)
                        .foregroundColor(.textGray)
                        .frame(height: 35)
                }
            Spacer()
            
            //                        if uploadButtonShowing{
            if trimContent.count > 0 {
                
                Button {
                    // MARK: 댓글 업로드 구현
//                    commentVm.insertComment(
//                        collectionName: collectionName,
//                        collectionDocId: collectionDocId,
//                        data: CommentFields(
//                            comment: CommentString(stringValue: replyContent),
//                            profileImage: CommentString(stringValue: currentUser?.profileImage.stringValue ?? ""),
//                            nickName: CommentString(stringValue: currentUser?.nickName.stringValue ?? ""),
//                            userID: CommentString(stringValue: Auth.auth().currentUser?.uid ?? ""),
//                            id: CommentString(stringValue: UUID().uuidString)
//                        )
//                    )
                    commentVm.insertComment(collectionName: "Community", collectionDocId: community.fields.id.stringValue, data: CommentFields(comment: CommentString(stringValue: replyContent), profileImage: CommentString(stringValue: community.fields.profileImage.stringValue), nickName: CommentString(stringValue: community.fields.nickName.stringValue), userID: CommentString(stringValue: Auth.auth().currentUser?.uid ?? ""), id: CommentString(stringValue: UUID().uuidString)))
                    
//                        uploadButtonShowing.toggle()
                    replyContent = ""        //댓글 텍스트 필드 초기화
                    
//                    commentVm.fetchComment(collectionName: collectionName, collectionDocId: collectionDocId)
                    
                } label: {
                    //                            Image(systemName: "checkmark")
                    //                                .foregroundColor(.blue)
                    Text("등록")
                        .font(.subheadline)
                        .foregroundColor(.textGray)
                        .bold()
                        .padding(.trailing)
                }
            }
            //                        .offset(x: 130)
            //                            .padding(.leading,260)
            else {
                Text("등록")
                    .font(.subheadline)
                    .foregroundColor(.middlebrightGray)
                    .bold()
                    .padding(.trailing)

            }
            
        }
    }
}

//struct CommunityCommentView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommunityCommentView()
//    }
//}
