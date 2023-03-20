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
    @ObservedObject var commentVm : CommentViewModel //댓글 뷰 모델 사용
    @ObservedObject var userVM : UserViewModel
    
    let community: CommunityDocument
    
    @Binding var commentCollectionDocId: String
    @Binding var replyCommentText: String
    @Binding var replyContent: String
    @Binding var replyComment : Bool  // 답글 표시 Bool값
    
    var trimContent: String {
        replyContent.trimmingCharacters(in: .whitespaces)
    }
    
    var body: some View {
        VStack{
            if replyComment {
                Rectangle()
                    .fill(Color(hex: "e9ecef"))
                    .frame(width: Screen.maxWidth * 1,height: Screen.maxHeight * 0.055)
                    .overlay {
                        HStack{
                            Text(replyCommentText + "님에게 답글 남기는 중")
                                .foregroundColor(.textGray)
                                .font(.subheadline)
                            Spacer()
                            Button {
                                replyComment.toggle()
                                replyContent = ""
                            } label: {
                                Image(systemName: "xmark")
                            }
                        }.padding(10)
                    }
            }
            HStack{
                KFImage(URL(string: userVM.currentUsers?.profileImage.stringValue ?? "") ?? URL(string:"https://cdn.travie.com/news/photo/202108/21951_11971_5847.jpg"))
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
                
                
                if trimContent.count > 0 {
                    if replyComment{
                        Button {
                            commentVm.insertRecomment(collectionName: "Community"
                                                      , collectionDocId: community.fields.id.stringValue
                                                      , commentCollectionName: "Comment"
                                                      , commentCollectionDocId: commentCollectionDocId
                                                      , data: CommentFields(
                                                        comment: CommentString(stringValue: replyContent),
                                                        profileImage: CommentString(stringValue: userVM.currentUsers?.profileImage.stringValue ?? ""),
                                                        nickName: CommentString(stringValue: userVM.currentUsers?.nickName.stringValue ?? ""),
                                                        userID: CommentString(stringValue: Auth.auth().currentUser?.uid ?? ""),
                                                        id: CommentString(stringValue: UUID().uuidString)
                                                      )
                            )
                            replyContent = ""
                            replyComment = false
                        } label: {
                            Text("등록")
                                .font(.subheadline)
                                .foregroundColor(.textGray)
                                .bold()
                                .padding(.trailing)
                        }
                    }else{
                        Button {
                            // MARK: 댓글 업로드 구현
                            commentVm.insertComment(
                                collectionName: "Community",
                                collectionDocId: community.fields.id.stringValue,
                                data: CommentFields(comment: CommentString(stringValue: replyContent),
                                                    profileImage: CommentString(stringValue: userVM.currentUsers?.profileImage.stringValue ?? ""),
                                                    nickName: CommentString(stringValue: userVM.currentUsers?.nickName.stringValue ?? ""),
                                                    userID: CommentString(stringValue: Auth.auth().currentUser?.uid ?? ""),
                                                    id: CommentString(stringValue: UUID().uuidString)))
                            
                            replyContent = ""        //댓글 텍스트 필드 초기화
                        } label: {
                            Text("등록")
                                .font(.subheadline)
                                .foregroundColor(.textGray)
                                .bold()
                                .padding(.trailing)
                        }
                    }
                }
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
}

//struct CommunityCommentView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommunityCommentView()
//    }
//}
