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
//    @ObservedObject var commentVm : CommentViewModel
    @StateObject var commentVm = CommentViewModel()
    @ObservedObject var magazineVM : MagazineViewModel
    
    @State var deleteCommentAlertBool : Bool = false
    @State var deleteDocId : String = ""
    
    @Binding var editRecomment : Bool
    @Binding var editReDocID : String
    @Binding var editReData : CommentFields
    @Binding var commentText: String // 답글 입력 텍스트 필드 값
    var index : Int = 0
    
    var commentCollectionDocId : String
    var collectionName : String     // 경로 받아오기 최초 컬렉션 받아오기 ex) Magazine
    var collectionDocId : String    // 경로 받아오기 최초 컬렌션 하위 문서ID 받아오기 ex) Magazine - 4ADB415C-871A-4FAF-86EA-D279D145CD37

    var body: some View {
        
        VStack(alignment: .leading){
            
            // 댓글이 없으면 빈칸
            if commentVm.sortedRecentRecomment.count < 1 {
                
            }else{
                
                ForEach(commentVm.sortedRecentRecommentArray[index].indices, id:\.self){ item in
                    Divider()
                    HStack(alignment: .top){
                        // MARK: -  유저 프로필 이미지
                        VStack{
                            if let user = userVM.users.first(where: { $0.fields.id.stringValue == commentVm.sortedRecentRecommentArray[index][item].fields.userID.stringValue })
                            {
                                NavigationLink {
                                    UserDetailView(userVM: userVM , magazineVM: magazineVM, user: user)
                                } label: {
                                    KFImage(URL(string: commentVm.sortedRecentRecommentArray[index][item].fields.profileImage.stringValue) ?? URL(string:"https://cdn.travie.com/news/photo/202108/21951_11971_5847.jpg"))
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                        .cornerRadius(15)
                                        .overlay {
                                            Circle()
                                                .stroke(lineWidth: 0.5)
                                        }
                                        .padding(.horizontal, 7)
                                }
                            } else {
                                // 유저데이터가 없는경우: 탈퇴한 유저
                                // 디폴트 이미지 정하기
                                KFImage(URL(string:"https://firebasestorage.googleapis.com/v0/b/grain-final.appspot.com/o/G5KvQmuPEehYVxvO7bHWkpBoY0f2%2FCD8C78A7-C100-42BC-8481-17E7BBC2E962%2F2C7635E2-6C57-493F-83CB-3E4B3D862132?alt=media&token=58695683-ecf8-4109-afe9-c5084580907a"))
                                    .resizable()
                                    .frame(width: 35, height: 35)
                                    .cornerRadius(30)
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
                                if userVM.users.contains(where: { $0.fields.id.stringValue == commentVm.sortedRecentRecommentArray[index][item].fields.userID.stringValue }) {
                                    NavigationLink {
                                        //유저 프로필 뷰 입장
                                    } label: {
                                        // MARK: 유저 닉네임
                                        if let user = userVM.users.first(where: { $0.fields.id.stringValue == commentVm.sortedRecentRecommentArray[index][item].fields.userID.stringValue }){
                                            Text(user.fields.nickName.stringValue)
                                                .font(.caption)
                                                .fontWeight(.bold)
                                        }
                                    }
                                } else {
                                    Text("Unknown_User")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                }
                                HStack{
                                    Text("・")
                                        .font(.caption2)
                                        .padding(.trailing, -5)
                                    // MARK: 댓글 생성 날짜
                                    Text(commentVm.sortedRecentRecommentArray[index][item].createTime.toDate()?.renderTime() ?? "")
                                        .font(.caption2)
                                }
                                Spacer()

                            }
                            .padding(.bottom, -5)

                            //MARK: - 댓글 내용
                            Text(commentVm.sortedRecentRecommentArray[index][item].fields.comment.stringValue)
                                .font(.caption)
                                .padding(.bottom, -1)

                            // MARK: - 자기가 쓴 댓글일시 보여주는 수정/삭제
                            HStack{
                                if commentVm.sortedRecentRecommentArray[index][item].fields.userID.stringValue == Auth.auth().currentUser?.uid{
                                    Button {
                                        editRecomment.toggle()
                                        editReDocID = commentVm.sortedRecentRecommentArray[index][item].fields.id.stringValue
                                        editReData = commentVm.sortedRecentRecommentArray[index][item].fields
                                    } label: {
                                        Text("수정")
                                    }

                                    Button{
                                        deleteDocId = commentVm.sortedRecentRecommentArray[index][item].fields.id.stringValue
                                        deleteCommentAlertBool.toggle()
                                    } label: {
                                        Text("삭제")
                                            .alert(isPresented: $deleteCommentAlertBool) {
                                                Alert(title: Text("댓글을 삭제하시겠어요?"),
                                                      primaryButton:  .cancel(Text("취소")),
                                                      secondaryButton:.destructive(Text("삭제"),action: {
                                                    commentVm.deleteRecomment(collectionName: collectionName, collectionDocId: collectionDocId, commentCollectionName: "Comment", commentCollectionDocId: commentCollectionDocId, docID: deleteDocId)
                                                }))
                                            }
                                    }
                                    .task(id: deleteCommentAlertBool) {
                                        commentVm.fetchRecomment(collectionName: collectionName, collectionDocId: collectionDocId, commentCollectionName: "Comment", commentCollectionDocId: commentCollectionDocId)
                                    }

                                }
                            }
                            .font(.caption2)
                            .foregroundColor(.textGray)
                            .padding(.top, 1)
                            .padding(.bottom, -3)

                        }
                    }

                }
                
            }
            // 댓글이 한개 이상 존재하면 Foreach 구문 실행
//            if commentVm.sortedRecentRecommentArray[index].isEmpty {
//                Text("empty array")
//            }else{
//                ForEach(commentVm.sortedRecentRecommentArray[index], id:\.self){ item in
//                    //                                            Text(item.fields.comment.stringValue)
//                    Divider()
//                    HStack(alignment: .top){
//                        // MARK: -  유저 프로필 이미지
//                        VStack{
//                            if let user = userVM.users.first(where: { $0.fields.id.stringValue == item.fields.userID.stringValue })
//                            {
//                                NavigationLink {
//                                    UserDetailView(userVM: userVM , magazineVM: magazineVM, user: user)
//                                } label: {
//                                    KFImage(URL(string: item.fields.profileImage.stringValue) ?? URL(string:"https://cdn.travie.com/news/photo/202108/21951_11971_5847.jpg"))
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
//
//                            HStack{
//                                //                                if userVM.users.contains(where: { $0.fields.id.stringValue == item.userID.stringValue }) {
//                                //                                    NavigationLink {
//                                //                                        //유저 프로필 뷰 입장
//                                //                                    } label: {
//                                //                                        // MARK: 유저 닉네임
//                                //                                        if let user = userVM.users.first(where: { $0.fields.id.stringValue == item.fields.userID.stringValue }){
//                                //                                            Text(user.fields.nickName.stringValue)
//                                //                                                .font(.caption)
//                                //                                                .fontWeight(.bold)
//                                //                                        }
//                                //                                    }
//                                //                                } else {
//                                //                                    Text("Unknown_User")
//                                //                                        .font(.caption)
//                                //                                        .fontWeight(.bold)
//                                //                                }
//                                HStack{
//                                    Text("・")
//                                        .font(.caption2)
//                                        .padding(.trailing, -5)
//                                    // MARK: 댓글 생성 날짜
//                                    Text(item.createTime.toDate()?.renderTime() ?? "")
//                                        .font(.caption2)
//                                }
//                                Spacer()
//
//                            }
//                            .padding(.bottom, -5)
//
//                            //MARK: - 댓글 내용
//                            Text(item.fields.comment.stringValue)
//                                .font(.caption)
//                                .padding(.bottom, -1)
//
//                            // MARK: - 자기가 쓴 댓글일시 보여주는 수정/삭제
//                            HStack{
//                                if item.fields.userID.stringValue == Auth.auth().currentUser?.uid{
//                                    Button {
//                                        editRecomment.toggle()
//                                        editReDocID = item.fields.id.stringValue
//                                        editReData = item.fields
//                                    } label: {
//                                        Text("수정")
//                                    }
//
//                                    Button{
//                                        deleteDocId = item.fields.id.stringValue
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
            
        }
        .padding(.leading , -8)
//        .onAppear{
//            commentVm.fetchRecomment(collectionName: collectionName, collectionDocId: collectionDocId, commentCollectionName: "Comment", commentCollectionDocId: commentCollectionDocId)
//        }
    }
}
