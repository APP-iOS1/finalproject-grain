//
//  CommunityRecommentView.swift
//  Grain
//
//  Created by 지정훈 on 2023/03/15.
//

import SwiftUI
import Kingfisher
import FirebaseAuth

//struct CommunityRecommentView: View {
//    @ObservedObject var commentVm : CommentViewModel
//    @ObservedObject var userVM : UserViewModel
//    @ObservedObject var magazineVM : MagazineViewModel
//
//    @State var deleteCommentAlertBool : Bool = false
//    @State var deleteDocId : String = ""
//    var commentCollectionDocId : String
//    var collectionName : String     // 경로 받아오기 최초 컬렉션 받아오기 ex) Magazine
//    var collectionDocId : String    // 경로 받아오기 최초 컬렌션 하위 문서ID 받아오기 ex) Community - 4ADB415C-871A-4FAF-86EA-D279D145CD37
//
//    @Binding var replyContent : String
//    @Binding var editRecomment : Bool
//    @Binding var editReDocID : String
//    @Binding var editReData : CommentFields
//
//    var body: some View {
//        VStack(alignment: .leading){
//            // 댓글이 없으면 빈칸
//            if commentVm.sortedRecentRecomment.count < 1 {
//            }
//            // 댓글이 한개 이상 존재하면 Foreach 구문 실행
//            else{
//                ForEach(commentVm.sortedRecentRecomment.indices, id: \.self){ index in
//                    Divider()
//                    HStack(alignment: .top){
//                        // MARK: -  유저 프로필 이미지
//                        VStack{
//                            if let user = userVM.users.first(where: { $0.fields.id.stringValue == commentVm.sortedRecentRecomment[index].fields.userID.stringValue})
//                            {
//                                NavigationLink {
//                                    UserDetailView(userVM: userVM, magazineVM: magazineVM, user: user)
//                                } label: {
//                                    KFImage(URL(string: commentVm.sortedRecentRecomment[index].fields.profileImage.stringValue) ?? URL(string:"https://cdn.travie.com/news/photo/202108/21951_11971_5847.jpg"))
//                                        .resizable()
//                                        .frame(width: 25, height: 25)
//                                        .cornerRadius(15)
//                                        .overlay {
//                                            Circle()
//                                                .stroke(lineWidth: 0.5)
//                                        }
//                                        .padding(.horizontal, 7)
//                                }
//                            } else {
//                                // 유저데이터가 없는경우: 탈퇴한 유저
//                                // 디폴트 이미지 정하기
//                                KFImage(URL(string:"https://firebasestorage.googleapis.com/v0/b/grain-final.appspot.com/o/G5KvQmuPEehYVxvO7bHWkpBoY0f2%2FCD8C78A7-C100-42BC-8481-17E7BBC2E962%2F2C7635E2-6C57-493F-83CB-3E4B3D862132?alt=media&token=58695683-ecf8-4109-afe9-c5084580907a"))
//                                    .resizable()
//                                    .frame(width: 35, height: 35)
//                                    .cornerRadius(30)
//                                    .overlay {
//                                        Circle()
//                                            .stroke(lineWidth: 0.5)
//                                    }
//                                    .padding(.horizontal, 7)
//                            }
//                        }
//                        .frame(width: Screen.maxWidth * 0.1)
//
//                        VStack(alignment: .leading){
//                            HStack{
//                                if userVM.users.contains(where: { $0.fields.id.stringValue == commentVm.sortedRecentComment[index].fields.userID.stringValue }) {
//                                    NavigationLink {
//                                        //유저 프로필 뷰 입장
//                                    } label: {
//                                        // MARK: 유저 닉네임
//                                        if let user = userVM.users.first(where: { $0.fields.id.stringValue == commentVm.sortedRecentComment[index].fields.userID.stringValue }){
//                                            Text(user.fields.nickName.stringValue)
//                                                .font(.caption)
//                                                .fontWeight(.bold)
//                                        }
//                                    }
//                                }
//                                else {
//                                    Text("Unknown_User")
//                                        .font(.caption)
//                                        .fontWeight(.bold)
//                                }
//
//
//                                HStack{
//                                    Text("・")
//                                        .font(.caption2)
//                                        .padding(.trailing, -5)
//                                    // MARK: 댓글 생성 날짜
//                                    Text(commentVm.sortedRecentRecomment[index].createTime.toDate()?.renderTime() ?? "")
//                                        .font(.caption2)
//                                }
//                                Spacer()
//
//                            }
//                            .padding(.bottom, -5)
//
//                            //MARK: - 댓글 내용
//                            Text(commentVm.sortedRecentRecomment[index].fields.comment.stringValue)
//                                .font(.caption)
//                                .padding(.bottom, -1)
//
//                            // MARK: - 자기가 쓴 댓글일시 보여주는 수정/삭제
//                            HStack{
//                                if commentVm.sortedRecentRecomment[index].fields.userID.stringValue == Auth.auth().currentUser?.uid{
//                                    Button {
//                                        editRecomment.toggle()
//                                        editReDocID = commentVm.sortedRecentRecomment[index].fields.id.stringValue
//                                        editReData = commentVm.sortedRecentRecomment[index].fields
//                                    } label: {
//                                        Text("수정")
//                                    }
//
//                                    Button{
//                                        deleteDocId = commentVm.sortedRecentRecomment[index].fields.id.stringValue
//                                        deleteCommentAlertBool.toggle()
//                                    } label: {
//                                        Text("삭제")
//                                            .alert(isPresented: $deleteCommentAlertBool) {
//                                                Alert(title: Text("댓글을 삭제하시겠어요?"),
//                                                      primaryButton:  .cancel(Text("취소")),
//                                                      secondaryButton:.destructive(Text("삭제"),action: {
//                                                    commentVm.deleteRecomment(collectionName: collectionName, collectionDocId: collectionDocId, commentCollectionName: "Comment", commentCollectionDocId: commentCollectionDocId, docID: deleteDocId)
//                                                }))
//                                            }
//                                    }
//                                    .task(id: deleteCommentAlertBool) {
//                                        commentVm.fetchRecomment(collectionName: collectionName, collectionDocId: collectionDocId, commentCollectionName: "Comment", commentCollectionDocId: commentCollectionDocId)
//                                    }
//
//                                }
//                            }
//                            .font(.caption2)
//                            .foregroundColor(.textGray)
//                            .padding(.top, 1)
//                            .padding(.bottom, -3)
//
//                        }
//                    }
//
//                }
//            }
//        }
//        .padding(.leading , -8)
////        .onAppear{
////            commentVm.fetchRecomment(collectionName: collectionName, collectionDocId: collectionDocId, commentCollectionName: "Comment", commentCollectionDocId: commentCollectionDocId)
////        }
//    }
//}

// 희경: 댓글 Test 를 위한 ReCommentView 입니다.
struct TestCommunityRecommentView: View {
    
    @ObservedObject var commentVM : CommentViewModel
    @ObservedObject var userVM : UserViewModel
    @ObservedObject var magazineVM : MagazineViewModel

    @State var deleteCommentAlertBool : Bool = false // 대댓글 삭제시 alert Bool 값
    @State var deleteDocId : String = "" // 대댓글 삭제시 필요한 대댓글 ID
    
//    @Binding var replyContent : String // 답글 달기 표시 Bool값
    @Binding var editRecomment : Bool // 대댓글 수정 Bool 값
    @Binding var editReDocID : String // 대댓글 수정시 필요한 대댓글 ID
    @Binding var editReData : CommentFields // 수정 내용 반영한 대댓글
    
    var commentCollectionDocId : String // 댓글 id
    var collectionName : String     // 경로 받아오기 최초 컬렉션 받아오기 ex) Magazine, Community
    var collectionDocId : String    // MagazineID or CommunityID
    
    // 댓글(한개당) 달린 대댓글 배열
    var recomments : [CommentDocument]
    
    
    var body: some View {
        HStack {
            Spacer()
            VStack(alignment: .leading) {
                ForEach(recomments, id: \.self) { recomment in
                    HStack(alignment: .top) {
                        if let user = userVM.users.first(where: {
                            $0.fields.id.stringValue ==  recomment.fields.userID.stringValue
                        }) {
                            NavigationLink {
                                UserDetailView(userVM: userVM, magazineVM: magazineVM, user: user)
                            } label: {
                                ProfileImage(imageName: recomment.fields.profileImage.stringValue)
                            } // profileView HStack
                        } // if let user
                        
                        VStack(alignment: .leading) {
                            HStack {
                                //MARK: - 닉네임, 시간, 내용
                                Text(recomment.fields.nickName.stringValue)
                                    .font(.caption)
                                    .fontWeight(.bold)
                                
                                Text("・")
                                    .font(.caption2)
                                    .padding(.trailing, -5)
                                
                                Text(recomment.createTime.toDate()?.renderTime() ?? "")
                                    .font(.caption2)
                                
                                
                            } // 닉네임 + 댓글생성날짜 HStack
                            .padding(.bottom, -5)
                            
                            //MARK: - 댓글 내용
                            Text(recomment.fields.comment.stringValue)
                                .font(.caption)
                                .padding(.bottom, -1)
                            
                            // MARK: - 자기가 쓴 댓글일시 보여주는 수정/삭제
                            HStack {
                                if recomment.fields.userID.stringValue == Auth.auth().currentUser?.uid {
                                    // 수정버튼
                                    Button {
                                        editRecomment.toggle()
                                        editReDocID = recomment.fields.id.stringValue
                                        editReData = recomment.fields
                                    } label: {
                                        Text("수정")
                                    }
                                    
                                    // 삭제버튼
                                    Button {
                                        deleteDocId = recomment.fields.id.stringValue
                                        deleteCommentAlertBool.toggle()
                                    } label: {
                                        Text("삭제")
                                    }
                                    .alert(isPresented: $deleteCommentAlertBool) {
                                        Alert(title: Text("댓글을 삭제하시겠어요?"),
                                              primaryButton:  .cancel(Text("취소")),
                                              secondaryButton:.destructive(Text("삭제"),action: {
                                            commentVM.deleteRecomment(collectionName: collectionName, collectionDocId: collectionDocId, commentCollectionName: "Comment", commentCollectionDocId: commentCollectionDocId, docID: deleteDocId)
                                        }))
                                    } // 삭제 확인 alert
                                }
                            }
                            .font(.caption2)
                            .foregroundColor(.textGray)
                            .padding(.top, 1)
                            .padding(.bottom, -3)
                        } // 닉네임 + 시간 / 댓글내용 / 수정 + 삭제 버튼 VStack
                    } // 최상단 HStack
                }// 첫번째 ForEach
                // if
            } // 최상단 VStack
            .padding(.leading, 20)
        }
    }
}
