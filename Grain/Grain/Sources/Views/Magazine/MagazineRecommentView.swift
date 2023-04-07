//
//  MagazineRecommentView.swift
//  Grain
//
//  Created by 지정훈 on 2023/03/02.
//

import SwiftUI
import Kingfisher
import FirebaseAuth


struct MagazineRecommentView: View {
    
    @ObservedObject var userVM : UserViewModel
    @ObservedObject var commentVm : CommentViewModel
    //    @StateObject var commentVm = CommentViewModel()
    @ObservedObject var magazineVM : MagazineViewModel
    
    @State var deleteCommentAlertBool : Bool = false
    @State var deleteDocId : String = ""
    @State var nickName : String = "" // 닉네임 변경을 위해
    
    @Binding var editRecomment : Bool
    @Binding var editReDocID : String
    @Binding var editReColletionDocID: String // commentCollectionDocId 이 값 넘기기 위해
    @Binding var editReData : CommentFields
    @Binding var commentText: String // 답글 입력 텍스트 필드 값
    
    
    var commentCollectionDocId : String
    var collectionName : String     // 경로 받아오기 최초 컬렉션 받아오기 ex) Magazine
    var collectionDocId : String    // 경로 받아오기 최초 컬렌션 하위 문서ID 받아오기 ex) Magazine - 4ADB415C-871A-4FAF-86EA-D279D145CD37
    
    func defaultProfileImage() -> String{
        var https : String = "https://"
        if let infolist = Bundle.main.infoDictionary {
            if let url = infolist["FailProfileImage"] as? String {
                https += url
            }
        }
        return https
    }
    func infolistCommentString() -> String{
        var commentString : String = ""
        if let infolist = Bundle.main.infoDictionary {
            if let str = infolist["UuidComment"] as? String {
                commentString = str
            }
        }
        return commentString
    }
    
    var body: some View {
        
        VStack(alignment: .leading){
            ForEach(Array(commentVm.sortedRecentRecommentArray.filter { $0.key == commentCollectionDocId }.values), id:\.self){ element in
                ForEach(element , id:\.self){ index in
                    if let user = userVM.users.first(where: { $0.fields.id.stringValue == index.fields.userID.stringValue }){
                        HStack(alignment: .top){
                            // MARK: -  유저 프로필 이미지
                            VStack{
                                NavigationLink {
                                    UserDetailView(userVM: userVM , magazineVM: magazineVM, user: user)
                                } label: {
                                    KFImage(URL(string: index.fields.profileImage.stringValue) ?? URL(string: defaultProfileImage()))
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                        .cornerRadius(15)
                                        .overlay {
                                            Circle()
                                                .stroke(lineWidth: 0.5)
                                        }
                                        .padding(.horizontal, 7)
                                }
                            }
                            .frame(width: Screen.maxWidth * 0.1)
                            
                            VStack(alignment: .leading){
                                
                                HStack{
                                    MagazineCommentNickNameView(user: user)
                                    HStack{
                                        Text("・")
                                            .font(.caption2)
                                            .padding(.trailing, -5)
                                        // MARK: 댓글 생성 날짜
                                        Text(index.createTime.toDate()?.renderTime() ?? "")
                                            .font(.caption2)
                                    }
                                    Spacer()
                                    
                                }
                                .padding(.bottom, -5)
                                
                                
                                //MARK: - 댓글 내용
                                Text(index.fields.comment.stringValue)
                                    .font(.caption)
                                    .padding(.bottom, -1)
                                    .padding(.top, 3)
                                // MARK: - 자기가 쓴 댓글일시 보여주는 수정/삭제
                                HStack{
                                    if index.fields.userID.stringValue == Auth.auth().currentUser?.uid{
                                        Button {
                                            editRecomment.toggle()
                                            editReDocID = index.fields.id.stringValue
                                            editReData = index.fields
                                            editReColletionDocID = commentCollectionDocId
                                        } label: {
                                            Text("수정")
                                                .font(.caption2)
                                                .foregroundColor(.textGray)
                                                .padding(.top, 1)
                                                .padding(.bottom, -3)
                                        }
                                        
                                        Button{
                                            deleteDocId = index.fields.id.stringValue
                                            deleteCommentAlertBool.toggle()
                                        } label: {
                                            Text("삭제")
                                                .font(.caption2)
                                                .foregroundColor(.textGray)
                                                .padding(.top, 1)
                                                .padding(.bottom, -3)
                                                .alert(isPresented: $deleteCommentAlertBool) {
                                                    Alert(title: Text("댓글을 삭제하시겠어요?"),
                                                          primaryButton:  .cancel(Text("취소")),
                                                          secondaryButton:.destructive(Text("삭제"),action: {
                                                        commentVm.deleteRecomment(collectionName: collectionName, collectionDocId: collectionDocId, commentCollectionName: infolistCommentString(), commentCollectionDocId: commentCollectionDocId, docID: deleteDocId)
                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                            commentVm.fetchComment(collectionName: collectionName, collectionDocId: collectionDocId)
                                                        }
                                                    }))
                                                }
                                        }
                                    }
                                    
                                }
                                
                            }
                            .offset(x : -7)
                        }
                    }
                    else{
                        Divider()
                        HStack(alignment: .top){
                            // MARK: -  유저 프로필 이미지
                            VStack{
                                Image("defaultUserImage")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .cornerRadius(15)
                                    .padding(.horizontal, 7)
                                    .overlay {
                                        Circle()
                                            .stroke(lineWidth: 0.5)
                                    }
                            }
                            .frame(width: Screen.maxWidth * 0.1)
                            
                            VStack(alignment: .leading){
                                HStack{
                                    
                                    Text("탈퇴한 유저입니다")
                                        .foregroundColor(.gray)
                                        .font(.caption)
                                        .fontWeight(.bold)
                                    
                                   
                                    HStack{
                                        Text("・")
                                            .font(.caption2)
                                            .padding(.trailing, -5)
                                        // MARK: 댓글 생성 날짜
                                        Text(index.createTime.toDate()?.renderTime() ?? "")
                                            .font(.caption2)
                                    }
                                    Spacer()
                                }
                                .padding(.bottom, -5)
                                //MARK: - 댓글 내용
                                Text("삭제된 댓글입니다.")
                                    .font(.footnote)
                                    .padding(.bottom, -1)
                            }
                            .offset(x : -7)
                            
                            
                        }
                    }
                }
            }
        }
        .padding(.top, 3)
        .padding(.leading, -10)
    }
}

