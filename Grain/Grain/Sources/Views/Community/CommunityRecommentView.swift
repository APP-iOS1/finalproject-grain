//
//  CommunityRecommentView.swift
//  Grain
//
//  Created by 지정훈 on 2023/03/15.
//

import SwiftUI
import Kingfisher
import FirebaseAuth

struct CommunityRecommentView: View {
    @ObservedObject var commentVm : CommentViewModel
    @ObservedObject var userVM : UserViewModel
    @ObservedObject var magazineVM : MagazineViewModel

    @State var deleteCommentAlertBool : Bool = false
    @State var deleteDocId : String = ""
    @State var nickName : String = "" // 닉네임 변경을 위해

    
    var commentCollectionDocId : String
    var collectionName : String     // 경로 받아오기 최초 컬렉션 받아오기 ex) Magazine
    var collectionDocId : String    // 경로 받아오기 최초 컬렌션 하위 문서ID 받아오기 ex) Community - 4ADB415C-871A-4FAF-86EA-D279D145CD37

    @Binding var replyContent : String
    @Binding var editRecomment : Bool
    @Binding var editReDocID : String
    @Binding var editReData : CommentFields
    @Binding var editReColletionDocID: String
    
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
                                    KFImage(URL(string: index.fields.profileImage.stringValue) ?? URL(string:"https://cdn.travie.com/news/photo/202108/21951_11971_5847.jpg"))
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

                                    NavigationLink {
                                        //유저 프로필 뷰 입장
                                    } label: {
                                        // MARK: 유저 닉네임
                                        Text(nickName)
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .onAppear{
                                                nickName = user.fields.nickName.stringValue
                                            }
                                    }
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

                                // MARK: - 자기가 쓴 댓글일시 보여주는 수정/삭제
                                HStack{
                                    if index.fields.userID.stringValue == Auth.auth().currentUser?.uid{
                                        Button {
                                            editRecomment.toggle()
                                            editReDocID = index.fields.id.stringValue
                                            editReData = index.fields
                                            editReColletionDocID =  commentCollectionDocId
                                        } label: {
                                            Text("수정")
                                        }

                                        Button{
                                            deleteDocId = index.fields.id.stringValue
                                            deleteCommentAlertBool.toggle()
                                        } label: {
                                            Text("삭제")
                                                .alert(isPresented: $deleteCommentAlertBool) {
                                                    Alert(title: Text("댓글을 삭제하시겠어요?"),
                                                          primaryButton:  .cancel(Text("취소")),
                                                          secondaryButton:.destructive(Text("삭제"),action: {
                                                        commentVm.deleteRecomment(collectionName: collectionName, collectionDocId: collectionDocId, commentCollectionName: "Comment", commentCollectionDocId: commentCollectionDocId, docID: deleteDocId)
                                                        
                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                            commentVm.fetchComment(collectionName: collectionName, collectionDocId: collectionDocId)
                                                        }
                                                    }))
                                                }
                                        }
                                    }
                                }
                                .font(.caption2)
                                .foregroundColor(.textGray)
                                .padding(.top, 1)
                                .padding(.bottom, -3)

                            }
                        }
                        Divider()
                    }
                    else{
                        
                        HStack(alignment: .top){
                            // MARK: -  유저 프로필 이미지
                            VStack{
                                KFImage(URL(string:"https://firebasestorage.googleapis.com/v0/b/grain-final.appspot.com/o/EditorFolder%2FdefaultImage%2Fdefault-user-icon-8.jpg?alt=media&token=1a514506-df59-484f-affb-b000ad1f348d"))
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .cornerRadius(15)
                                    .overlay {
                                        Circle()
                                            .stroke(lineWidth: 0.5)
                                    }
                                    .padding(.horizontal, 7)
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
                            .frame(width: Screen.maxWidth * 0.8)

                        }
                        Divider()
                    }
                }
            }
        }
        .padding(.leading , -8)
    }
}

// 희경: 댓글 Test 를 위한 ReCommentView 입니다.
//struct TestCommunityRecommentView: View {
//
//    @ObservedObject var commentVM : CommentViewModel
//    @ObservedObject var userVM : UserViewModel
//    @ObservedObject var magazineVM : MagazineViewModel
//
//    @State var deleteCommentAlertBool : Bool = false // 대댓글 삭제시 alert Bool 값
//    @State var deleteDocId : String = "" // 대댓글 삭제시 필요한 대댓글 ID
//
////    @Binding var replyContent : String // 답글 달기 표시 Bool값
//    @Binding var editRecomment : Bool // 대댓글 수정 Bool 값
//    @Binding var editReDocID : String // 대댓글 수정시 필요한 대댓글 ID
//    @Binding var editReData : CommentFields // 수정 내용 반영한 대댓글
//
//    var commentCollectionDocId : String // 댓글 id
//    var collectionName : String     // 경로 받아오기 최초 컬렉션 받아오기 ex) Magazine, Community
//    var collectionDocId : String    // MagazineID or CommunityID
//
//    // 댓글(한개당) 달린 대댓글 배열
//    var recomments : [CommentDocument]
//
//
//    var body: some View {
//        HStack {
//            Spacer()
//            VStack(alignment: .leading) {
//                ForEach(recomments, id: \.self) { recomment in
//                    HStack(alignment: .top) {
//                        if let user = userVM.users.first(where: {
//                            $0.fields.id.stringValue ==  recomment.fields.userID.stringValue
//                        }) {
//                            NavigationLink {
//                                UserDetailView(userVM: userVM, magazineVM: magazineVM, user: user)
//                            } label: {
//                                ProfileImage(imageName: recomment.fields.profileImage.stringValue)
//                            } // profileView HStack
//                        } // if let user
//
//                        VStack(alignment: .leading) {
//                            HStack {
//                                //MARK: - 닉네임, 시간, 내용
//                                Text(recomment.fields.nickName.stringValue)
//                                    .font(.caption)
//                                    .fontWeight(.bold)
//
//                                Text("・")
//                                    .font(.caption2)
//                                    .padding(.trailing, -5)
//
//                                Text(recomment.createTime.toDate()?.renderTime() ?? "")
//                                    .font(.caption2)
//
//
//                            } // 닉네임 + 댓글생성날짜 HStack
//                            .padding(.bottom, -5)
//
//                            //MARK: - 댓글 내용
//                            Text(recomment.fields.comment.stringValue)
//                                .font(.caption)
//                                .padding(.bottom, -1)
//
//                            // MARK: - 자기가 쓴 댓글일시 보여주는 수정/삭제
//                            HStack {
//                                if recomment.fields.userID.stringValue == Auth.auth().currentUser?.uid {
//                                    // 수정버튼
//                                    Button {
//                                        editRecomment.toggle()
//                                        editReDocID = recomment.fields.id.stringValue
//                                        editReData = recomment.fields
//                                    } label: {
//                                        Text("수정")
//                                    }
//
//                                    // 삭제버튼
//                                    Button {
//                                        deleteDocId = recomment.fields.id.stringValue
//                                        deleteCommentAlertBool.toggle()
//                                    } label: {
//                                        Text("삭제")
//                                    }
//                                    .alert(isPresented: $deleteCommentAlertBool) {
//                                        Alert(title: Text("댓글을 삭제하시겠어요?"),
//                                              primaryButton:  .cancel(Text("취소")),
//                                              secondaryButton:.destructive(Text("삭제"),action: {
//                                            commentVM.deleteRecomment(collectionName: collectionName, collectionDocId: collectionDocId, commentCollectionName: "Comment", commentCollectionDocId: commentCollectionDocId, docID: deleteDocId)
//                                        }))
//                                    } // 삭제 확인 alert
//                                }
//                            }
//                            .font(.caption2)
//                            .foregroundColor(.textGray)
//                            .padding(.top, 1)
//                            .padding(.bottom, -3)
//                        } // 닉네임 + 시간 / 댓글내용 / 수정 + 삭제 버튼 VStack
//                    } // 최상단 HStack
//                }// 첫번째 ForEach
//                // if
//            } // 최상단 VStack
//            .padding(.leading, 20)
//        }
//    }
//}
