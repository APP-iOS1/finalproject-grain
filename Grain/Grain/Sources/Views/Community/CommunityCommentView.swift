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

    @ObservedObject var commentVm : CommentViewModel
    @ObservedObject var userVM : UserViewModel
    
    let community: CommunityDocument
    
    @Binding var commentCollectionDocId: String
    @Binding var replyCommentText: String
    @Binding var replyContent: String
    @Binding var replyComment : Bool  // 답글 표시 Bool값
    
    @Binding var editComment : Bool
    @Binding var editDocID : String
    @Binding var editData : CommentFields
    @Binding var editRecomment : Bool
    @Binding var editReDocID : String
    @Binding var editReData : CommentFields
    @Binding var editReColletionDocID: String
    @Binding var reommentUserID : String
    @Binding var communityData: CommunityDocument?
    
    
    var trimContent: String {
        replyContent.trimmingCharacters(in: .whitespaces)
    }
    
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
        VStack{
            
            // MARK: -
            if replyComment {
                Rectangle()
                    .fill(Color(hex: "e9ecef"))
                    .frame(width: Screen.maxWidth * 1,height: Screen.maxHeight * 0.055)
                    .overlay {
                        HStack{
                            Text(replyCommentText)
                                .foregroundColor(.black)
                                .font(.subheadline)
                                .fontWeight(.bold)
                            Text("님에게 답글 남기는 중")
                                .foregroundColor(.textGray)
                                .font(.subheadline)
                                .offset(x: -5)
                            Spacer()
                            Button {
                                replyComment.toggle()
                                replyContent = ""
                            } label: {
                                Image(systemName: "xmark")
                            }
                        }.padding(10)
                    }.onAppear{
                        editComment = false
                        editRecomment = false
                    }
            }
            if editComment {
                Rectangle()
                    .fill(Color(hex: "e9ecef"))
                    .frame(width: Screen.maxWidth * 1,height: Screen.maxHeight * 0.055)
                    .overlay {
                        HStack{
                            Text("댓글을 수정하는 중입니다")
                                .foregroundColor(.textGray)
                                .font(.subheadline)
                            Spacer()
                            Button {
                                editComment.toggle()
                                replyContent = ""
                            } label: {
                                Image(systemName: "xmark")
                            }
                        }.padding(10)
                    }.onAppear{
                        replyComment = false
                        editRecomment = false
                    }
            }
            if editRecomment{
                Rectangle()
                    .fill(Color(hex: "e9ecef"))
                    .frame(width: Screen.maxWidth * 1,height: Screen.maxHeight * 0.055)
                    .overlay {
                        HStack{
                            Text("댓글을 수정하는 중입니다")
                                .foregroundColor(.textGray)
                                .font(.subheadline)
                            Spacer()
                            Button {
                                editRecomment.toggle()
                                replyContent = ""
                            } label: {
                                Image(systemName: "xmark")
                            }
                        }.padding(10)
                    }.onAppear{
                        replyComment = false
                        editComment = false
                    }
            }
            
            HStack{
                KFImage(URL(string: userVM.currentUsers?.profileImage.stringValue ?? "") ?? URL(string: defaultProfileImage()))
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
                            replyComment = false
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
                            commentVm.fetchComment(collectionName: "Community", collectionDocId: community.fields.id.stringValue)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                                commentVm.fetchComment(collectionName: "Community", collectionDocId: community.fields.id.stringValue)
                            }
                            
                            let sender = PushNotificationSender(serverKeyString: "")
                            if let user = userVM.users.first(where: { $0.fields.id.stringValue == reommentUserID })
                            {
                                if user.fields.id.stringValue != userVM.currentUsers?.id.stringValue{
                                    for i in user.fields.fcmToken.arrayValue.values {
                                        sender.sendPushNotification(to: i.stringValue, title: "바로 지금! 대댓글이 도착했습니다. 📨", message: "\(userVM.currentUsers?.nickName.stringValue ?? "")님이 회원님의 댓글에 대댓글을 남겼어요 💬", image: communityData?.fields.image.arrayValue.values[0].stringValue ?? "")
                                    }
                                }
                            }
                            
                        } label: {
                            Text("등록")
                                .font(.subheadline)
                                .foregroundColor(.textGray)
                                .bold()
                                .padding(.trailing)
                        }
                    }
                    else if editComment {
                        Button {
                            editComment = false
                            commentVm.updateComment(collectionName: "Community", collectionDocId: community.fields.id.stringValue, docID: editDocID, updateComment: replyContent, data: editData)
                            replyContent = ""
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                                commentVm.fetchComment(collectionName: "Community", collectionDocId: community.fields.id.stringValue)
                            }
                        } label: {
                            Text("등록")
                                .font(.subheadline)
                                .foregroundColor(.textGray)
                                .bold()
                                .padding(.trailing)
                        }
                    }
                    else if editRecomment{
                        Button {
                            editRecomment = false
                            commentVm.updateRecomment(collectionName: "Community", collectionDocId: community.fields.id.stringValue, commentCollectionName: "Comment", commentCollectionDocId: editReColletionDocID, docID: editReDocID, updateComment: replyContent, data: editReData)
                            replyContent = ""
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                                commentVm.fetchComment(collectionName: "Community", collectionDocId: community.fields.id.stringValue)
                            }
                        } label: {
                            Text("등록")
                                .font(.subheadline)
                                .foregroundColor(.textGray)
                                .bold()
                                .padding(.trailing)
                        }
                    }
                    else{
                        Button {
                            // MARK: 댓글 업로드 구현
                            replyComment = false
                            commentVm.insertComment(
                                collectionName: "Community",
                                collectionDocId: community.fields.id.stringValue,
                                data: CommentFields(comment: CommentString(stringValue: replyContent),
                                                    profileImage: CommentString(stringValue: userVM.currentUsers?.profileImage.stringValue ?? ""),
                                                    nickName: CommentString(stringValue: userVM.currentUsers?.nickName.stringValue ?? ""),
                                                    userID: CommentString(stringValue: Auth.auth().currentUser?.uid ?? ""),
                                                    id: CommentString(stringValue: UUID().uuidString)))
                            
                            replyContent = ""
                            commentVm.fetchComment(collectionName: "Community", collectionDocId: community.fields.id.stringValue)
                            
                            if let communityData = self.communityData {
                                
                                if let user = userVM.users.first(where: { $0.fields.id.stringValue == communityData.fields.userID.stringValue })
                                {
                                    if user.fields.id.stringValue != userVM.currentUsers?.id.stringValue{
                                        let sender = PushNotificationSender(serverKeyString: "")
                                        for i in user.fields.fcmToken.arrayValue.values {
                                            sender.sendPushNotification(to: i.stringValue, title:  "게시글에 새로운 댓글이 달렸습니다! 📨", message: "\(userVM.currentUsers?.nickName.stringValue ?? "")님이 회원님의 \(communityData.fields.title.stringValue) 커뮤니티 게시글에 댓글을 남겼어요, 지금 확인하고 댓글 작성자와 함께 대화해 보세요. 💬 ", image: communityData.fields.image.arrayValue.values[0].stringValue ?? "")
                                        }
                                    }
                                }
                            }
                            
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
