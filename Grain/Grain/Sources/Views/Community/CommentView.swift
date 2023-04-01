//
//  CommentView.swift
//  Grain
//
//  Created by 홍수만 on 2023/01/20.
//

import SwiftUI
import FirebaseAuth
import Kingfisher

//MARK: 입력된 댓글 레이아웃
struct CommentView: View {
    @StateObject var commentVm = CommentViewModel()
    
    @ObservedObject var userVM : UserViewModel
    @ObservedObject var magazineVM : MagazineViewModel
    
    @State var readMoreComments : Bool = false   //답글 더보기 Bool값
    @State var deleteCommentAlertBool : Bool = false
    @State var deleteDocId : String = ""
    @State var nickName : String = "" // 닉네임 변경을 위해
    
    @State var recomments = [[String: CommentFields]]()
    
    var collectionName : String     // 경로 받아오기 최초 컬렉션 받아오기 ex) Magazine
    var collectionDocId : String    // 경로 받아오기 최초 컬렌션 하위 문서ID 받아오기 ex)
    
    @Binding var commentCollectionDocId: String // 댓글
    @Binding var replyCommentText: String // @nickName + 님에게
    @Binding var replyContent: String // 대댓글 내용
    @Binding var replyComment : Bool  // 답글 달기 표시 Bool값
    @Binding var editComment : Bool // 댓글 수정 Bool값
    @Binding var editDocID : String
    @Binding var editData : CommentFields
    @Binding var editRecomment : Bool // 대댓글 수정 Bool값
    @Binding var editReDocID : String
    @Binding var editReData : CommentFields
    
    var body: some View {
        VStack(alignment: .leading){
            ScrollView() {
                ForEach(commentVm.sortedRecentComment, id:\.self){ index in
                    if let user = userVM.users.first(where: { $0.fields.id.stringValue == index.fields.userID.stringValue})
                    {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading){
                                NavigationLink {
                                    UserDetailView(userVM: userVM, magazineVM: magazineVM, user: user)
                                } label: {
                                    KFImage(URL(string: index.fields.profileImage.stringValue) ?? URL(string:"https://cdn.travie.com/news/photo/202108/21951_11971_5847.jpg"))
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

                            VStack(alignment: .leading) {
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
                                        Text(index.createTime.toDate()?.renderTime() ?? "")
                                            .font(.caption2)
                                    }
                                }
                                .padding(.bottom, -5)

                                Text(index.fields.comment.stringValue)
                                    .font(.footnote)
                                    .padding(.bottom, -1)

                                //MARK: 댓글 에디트
                                HStack {
                                    Button {
                                        replyComment.toggle()
                                        replyCommentText = "@" + nickName
                                        commentCollectionDocId = index.fields.id.stringValue
                                    } label: {
                                        Text("답글달기")
                                    }
                                    // MARK: 답글 더보기
                                    Button {

                                    } label: {
                                        if let recommentCount = commentVm.sortedRecentRecommentCount[commentVm.sortedRecentComment[index].fields.id.stringValue]{
                                            Text("답글 더보기 (\(recommentCount))")
                                        }else{
                                            Text("답글 더보기 (0)" )
                                        }
                                    }

                                    if index.fields.userID.stringValue == Auth.auth().currentUser?.uid{
                                        Button{
                                            editComment.toggle()
                                            editDocID = index.fields.id.stringValue
                                            editData = index.fields
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
                                                        commentVm.deleteComment(collectionName: "Community", collectionDocId: collectionDocId, docID: deleteDocId)
                                                    }))
                                                }
                                        }

                                    }
                                }
                                .font(.caption2)
                                .foregroundColor(.textGray)
                                .padding(.top, 1)
                                .padding(.bottom, -3)
                                Divider()

                                VStack{
                                    // 리코멘트
                                    if let recommentCount = commentVm.sortedRecentRecommentCount[commentVm.sortedRecentComment[index].fields.id.stringValue]{
                                        if recommentCount <= 5 || readMoreComments{
//                                            CommunityRecommentView(commentVm: commentVm, userVM: userVM, magazineVM: magazineVM, commentCollectionDocId: index.fields.id.stringValue, collectionName: collectionName, collectionDocId: collectionDocId, replyContent: $replyContent , editRecomment: $editRecomment ,editReDocID: $editReDocID , editReData : $editReData)
                                        }
                                    }

                                }

                            }

                        }

                    }
                    else
                    { //MARK: 탈퇴 유저
                        HStack(alignment: .top){
                            // MARK: -  유저 프로필 이미지
                            VStack{
                                ProfileImage(imageName: "https://firebasestorage.googleapis.com/v0/b/grain-final.appspot.com/o/G5KvQmuPEehYVxvO7bHWkpBoY0f2%2FCD8C78A7-C100-42BC-8481-17E7BBC2E962%2F2C7635E2-6C57-493F-83CB-3E4B3D862132?alt=media&token=58695683-ecf8-4109-afe9-c5084580907a")

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

                                HStack{

                                    // MARK: 답글 더보기
                                    Button {


                                    } label: {
                                        if let recommentCount = commentVm.sortedRecentRecommentCount[index.fields.id.stringValue]{
                                            Text("답글 더보기 (\(recommentCount))")
                                        }else{
                                            Text("답글 더보기 (0)" )
                                        }
                                    }
                                }
                                .font(.caption2)
                                .foregroundColor(.textGray)
                                .padding(.top, 1)
                                .padding(.bottom, -3)

                                VStack{

                                }

                            }
                            .frame(width: Screen.maxWidth * 0.8)
                            //                                .padding(.leading, 20)
                        }
                        Divider()
                    }
                }.padding(7)
            }
        }
        .onAppear {
            commentVm.fetchComment(collectionName: "Community", collectionDocId: collectionDocId)
        }
    }
    
}
// 희경: 댓글 Test 를 위한 CommentView 입니다.
//struct TestCommentView: View {
//
//    @ObservedObject var commentVM: CommentViewModel
//    @ObservedObject var userVM : UserViewModel
//    @ObservedObject var magazineVM : MagazineViewModel
//
//    @State var deleteCommentAlertBool : Bool = false // 삭제버튼 alert
//    @State var deleteDocId : String = "" // 삭제시 필요한 CommentID
//    @State var nickName : String = "" // 닉네임 변경을 위해 -> @nickName 님에게
//    @State var recomments: [CommentDocument] = []
//
//    var collectionName : String     // Magazine, Community
//    var collectionDocId : String    // MagazineID, CommunityID
//
//    @Binding var commentCollectionDocId: String // 댓글 ID
//    @Binding var replyCommentText: String // @nickName + 님에게
//    @Binding var replyContent: String // 대댓글 내용
//    @Binding var replyComment : Bool  // 답글 달기 표시 Bool값
//    @Binding var editComment : Bool // 댓글 수정 Bool값
//    @Binding var editDocID : String // 댓글 수정시 필요한 댓글 ID
//    @Binding var editData : CommentFields // 수정 내용 반영한 댓글 data
//    @Binding var editRecomment : Bool // 대댓글 수정 Bool값
//    @Binding var editReDocID : String // 대댓글 수정시 필요한 대댓글 ID
//    @Binding var editReData : CommentFields // 수정 내용 반영한 대댓글 data
//
//
//    var body: some View {
//        VStack(alignment: .leading) {
//            ScrollView(showsIndicators: false) {
//                ForEach(commentVM.sortedRecentComment, id: \.self) { comment in
//                    VStack {
//                        HStack(alignment: .top) {
//                            // profileview
//                            VStack(alignment: .leading) {
//                                if let user = userVM.users.first(where: {
//                                    $0.fields.id.stringValue == comment.fields.userID.stringValue
//                                }) {
//                                    NavigationLink {
//                                        UserDetailView(userVM: userVM, magazineVM: magazineVM, user: user)
//                                    } label: {
//                                        ProfileImage(imageName: comment.fields.profileImage.stringValue)
//                                    }
//                                } // if let user
//                                else {
//                                    ProfileImage(imageName: "https://firebasestorage.googleapis.com/v0/b/grain-final.appspot.com/o/G5KvQmuPEehYVxvO7bHWkpBoY0f2%2FCD8C78A7-C100-42BC-8481-17E7BBC2E962%2F2C7635E2-6C57-493F-83CB-3E4B3D862132?alt=media&token=58695683-ecf8-4109-afe9-c5084580907a")
//                                }
//                            }// 프로필뷰 VStack
//
//                            VStack(alignment: .leading) {
//                                HStack {
//
//                                    if userVM.users.contains(where: {
//                                        $0.fields.id.stringValue == comment.fields.userID.stringValue
//                                    }) {
//                                        Text(comment.fields.nickName.stringValue)
//                                            .font(.caption)
//                                            .fontWeight(.bold)
//                                    } else {
//                                        Text("UnknownUser")
//                                            .font(.caption)
//                                            .fontWeight(.bold)
//                                    }
//
//                                    Text("・")
//                                        .font(.caption2)
//                                        .padding(.trailing, -5)
//                                    Text(comment.createTime.toDate()?.renderTime() ?? "")
//                                        .font(.caption2)
//                                }// 닉네임 + 시간 HStack
//                                .padding(.bottom, -5)
//
//                                // 댓글 내용 Text
//                                Text(comment.fields.comment.stringValue)
//                                    .font(.footnote)
//                                    .padding(.bottom, -1)
//
//                                HStack {
//                                    Button {
//                                        replyComment.toggle()
//                                        replyCommentText = "@" + nickName
//                                        commentCollectionDocId = comment.fields.id.stringValue
//                                    } label: {
//                                        Text("답글달기")
//                                    }
//
//
//                                    // 내가 쓴 댓글이라면, 수정, 삭제버튼 넣어주기
//                                    if comment.fields.userID.stringValue == Auth.auth().currentUser?.uid {
//                                        // 수정버튼
//                                        Button {
//                                            editComment.toggle()
//                                            editDocID = comment.fields.id.stringValue
//                                            editData = comment.fields
//
//                                        } label: {
//                                            Text("수정")
//                                        }
//
//                                        // 삭제버튼
//                                        Button {
//                                            deleteDocId = comment.fields.id.stringValue
//                                            deleteCommentAlertBool.toggle()
//                                        } label: {
//                                            Text("삭제")
//                                        }
//                                        .alert(isPresented: $deleteCommentAlertBool) {
//                                            Alert(title: Text("댓글을 삭제하시겠어요?"),
//                                                  primaryButton:  .cancel(Text("취소")),
//                                                  secondaryButton:.destructive(Text("삭제"),action: {
//                                                commentVM.deleteComment(collectionName: "Community", collectionDocId: collectionDocId, docID: deleteDocId)
//                                            }))
//                                        } // 댓글 삭제 alert
//                                    }
//                                } // 답글달기, 수정, 삭제 HStack
//                                .font(.caption2)
//                                .foregroundColor(.textGray)
//                                .padding(.top, 1)
//                                .padding(.bottom, -3)
//
//                            }// 닉네임 + 시간 / 댓글내용 / 답글달기 + 수정 + 삭제 버튼 Vstack
//                            Spacer()
//                        } // 최상단 hstack
//                        .padding(7)
//
//                        // 대댓글 view
////                        TestCommunityRecommentView(commentVM: commentVM, userVM: userVM, magazineVM: magazineVM, editRecomment: $editRecomment, editReDocID: $editReDocID, editReData: $editReData, commentCollectionDocId: commentCollectionDocId, collectionName: collectionName, collectionDocId: collectionDocId, recomments: commentVM.filterRecomment(commentID: comment.fields.id.stringValue))
//
//                        Divider()
//
//                    } // 최상단 VStack
//                } // ForEach
//            }
//        }.onAppear {
//            commentVM.fetchComment(collectionName: collectionName, collectionDocId: collectionDocId)
//        }
//    }
//
//}
//
