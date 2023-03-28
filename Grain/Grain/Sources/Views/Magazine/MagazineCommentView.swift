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
    
    @StateObject var commentVm = CommentViewModel()
    @ObservedObject var userVM : UserViewModel
    @ObservedObject var magazineVM : MagazineViewModel
    
    @State var commentText: String = "" // 댓글 작성 텍스트 필드
    @State var editButtonShowing : Bool = false // 내가 쓴 댓글 수정/삭제 한번에 보여줄려고 만든 Bool
    @State var summitComment : Bool = false // 내가 쓴 댓글 수정/삭제 한번에 보여줄려고 만든 Bool
    @State var replyComment : Bool = false  // 답글 표시 Bool값
    @State var replyCommentText : String = "" // 답글 표시 이름 값
    @State var editComment : Bool = false
    @State var editDocID : String = ""
    @State var editData : CommentFields = CommentFields(comment: CommentString(stringValue: ""), profileImage: CommentString(stringValue: ""), nickName: CommentString(stringValue: ""), userID: CommentString(stringValue: ""), id: CommentString(stringValue: ""))
    @State var editReDocID : String = ""
    @State var editReData : CommentFields = CommentFields(comment: CommentString(stringValue: ""), profileImage: CommentString(stringValue: ""), nickName: CommentString(stringValue: ""), userID: CommentString(stringValue: ""), id: CommentString(stringValue: ""))
    @State var editRecomment : Bool = false
    @State var commentCollectionDocId : String = "" // 답글 id
    @State var readMoreComments : Bool = false   //답글 더보기 Bool값
    @State var reCommentCount : Int = 0
    @State var eachBool : [Bool] = []
    
    var collectionName : String     // 경로 받아오기 최초 컬렉션 받아오기 ex) Magazine
    var collectionDocId : String    // 경로 받아오기 최초 컬렌션 하위 문서ID 받아오기 ex) Magazine - 4ADB415C-871A-4FAF-86EA-D279D145CD37
    
    func makeEachBool(count: Int){  // 댓글 갯수만큼 bool 배열을 만듬 예) 댓글 3개면 [ false, false, false ]
        eachBool = Array(repeating: false, count: count)
    }
    
    var body: some View {
        VStack() {
            Divider()
            ScrollView() {
                VStack(alignment: .leading){
                    ForEach(commentVm.sortedRecentComment.indices, id: \.self){ index in
                        HStack(alignment: .top){
                            // MARK: -  유저 프로필 이미지
                            VStack{
                                if let user = userVM.users.first(where: { $0.fields.id.stringValue == commentVm.sortedRecentComment[index].fields.userID.stringValue})
                                {
                                    NavigationLink {
                                        UserDetailView(userVM: userVM, magazineVM: magazineVM, user: user)
                                    } label: {
                                        KFImage(URL(string: commentVm.sortedRecentComment[index].fields.profileImage.stringValue) ?? URL(string:"https://cdn.travie.com/news/photo/202108/21951_11971_5847.jpg"))
                                            .resizable()
                                            .frame(width: 35, height: 35)
                                            .cornerRadius(30)
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
                                    if userVM.users.contains(where: { $0.fields.id.stringValue == commentVm.sortedRecentComment[index].fields.userID.stringValue })
                                    {
                                        NavigationLink {
                                            //유저 프로필 뷰 입장
                                        } label: {
                                            // MARK: 유저 닉네임
                                            Text(commentVm.sortedRecentComment[index].fields.nickName.stringValue)
                                                .font(.caption)
                                                .fontWeight(.bold)
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
                                        Text(commentVm.sortedRecentComment[index].createTime.toDate()?.renderTime() ?? "")
                                            .font(.caption2)
                                    }
                                    
                                    Spacer()
                                }
                                .padding(.bottom, -5)
                                //MARK: - 댓글 내용
                                Text(commentVm.sortedRecentComment[index].fields.comment.stringValue)
                                    .font(.footnote)
                                    .padding(.bottom, -1)
                                
                                // MARK: - 답글달기, 답글 더보기, 수정 , 삭제
                                HStack{
                                    Button {
                                        replyComment.toggle()
                                        replyCommentText = "@" + commentVm.sortedRecentComment[index].fields.nickName.stringValue
                                        commentCollectionDocId = commentVm.sortedRecentComment[index].fields.id.stringValue
                                    } label: {
                                        Text("답글달기")
                                    }
                                    // MARK: 답글 더보기
                                    Button {
                                        makeEachBool(count: reCommentCount)
                                        readMoreComments.toggle()
                                        eachBool[index] = true
                                        commentVm.sortedRecentRecomment.removeAll()
                                    } label: {
                                        Text("답글 더보기")
                                    }
                                    if commentVm.sortedRecentComment[index].fields.userID.stringValue == Auth.auth().currentUser?.uid{
                                        Button {
                                            editComment.toggle()
                                            editDocID = commentVm.sortedRecentComment[index].fields.id.stringValue
                                            editData = commentVm.sortedRecentComment[index].fields
                                        } label: {
                                            Text("수정")
                                        }
                                        //  MARK: 삭제
                                        Button {
                                            commentVm.deleteComment(collectionName: collectionName, collectionDocId: collectionDocId, docID: commentVm.sortedRecentComment[index].fields.id.stringValue)
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                                                commentVm.fetchComment(collectionName: collectionName, collectionDocId: collectionDocId)
                                            }
                                        } label: {
                                            Text("삭제")
                                        }
                                    }
                                }
                                .font(.caption2)
                                .foregroundColor(.textGray)
                                .padding(.top, 1)
                                .padding(.bottom, -3)
                                
                                VStack{
                                    if readMoreComments && eachBool[index]{
                                        MagazineRecommentView(userVM: userVM, commentVm: commentVm, magazineVM: magazineVM, editRecomment: $editRecomment, editReDocID: $editReDocID, editReData: $editReData, commentText: $commentText, commentCollectionDocId: commentVm.sortedRecentComment[index].fields.id.stringValue, collectionName: collectionName, collectionDocId: collectionDocId)
                                    }
                                }
                            }
                            .frame(width: Screen.maxWidth * 0.8)
                        }
                        Divider()
                    }
                    .onAppear{
                        reCommentCount = commentVm.sortedRecentComment.count
                        makeEachBool(count: reCommentCount)
                    }
                    .padding(7)
                }
                
            }.refreshable {
                commentVm.fetchComment(collectionName: collectionName, collectionDocId: collectionDocId)
                reCommentCount = commentVm.sortedRecentComment.count
                makeEachBool(count: reCommentCount)
            }
            VStack(alignment: .leading){
                // MARK: 답글달기 클릭시 활성화 되는 구역
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
                                    commentText = ""
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
                                    commentText = ""
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
                                    commentText = ""
                                } label: {
                                    Image(systemName: "xmark")
                                }
                            }.padding(10)
                        }.onAppear{
                            replyComment = false
                            editComment = false
                        }
                }
                // MARK: 댓글 구역
                HStack{
                    KFImage(URL(string: userVM.currentUsers?.profileImage.stringValue ?? "" ) ??  URL(string:"https://cdn.travie.com/news/photo/202108/21951_11971_5847.jpg") )
                        .resizable()
                        .frame(width: 35, height: 35)
                        .cornerRadius(30)
                        .overlay {
                            Circle()
                                .stroke(lineWidth: 0.5)
                        }
                        .padding(.leading)
                    MagazineCommentTextField(commentVm: commentVm, commentText: $commentText, summitComment: $summitComment, replyComment: $replyComment, editComment: $editComment, editDocID: $editDocID, editData: $editData,editReDocID: $editReDocID, editReData: $editReData, editRecomment: $editRecomment, commentCollectionDocId: $commentCollectionDocId, reCommentCount: $reCommentCount, eachBool: $eachBool, currentUser: userVM.currentUsers,collectionName: collectionName, collectionDocId: collectionDocId)

                }
            }
        }
        .onAppear{
            commentVm.fetchComment(collectionName: collectionName, collectionDocId: collectionDocId)    // 해당하는 매거진 댓글 정보 가져오기
        }
        .navigationTitle("댓글")
        .navigationBarTitleDisplayMode(.inline)
    }
}
struct MagazineCommentTextField: View {
    
    @ObservedObject var commentVm : CommentViewModel
    
    @Binding var commentText: String
    @Binding var summitComment: Bool
    @Binding var replyComment : Bool
    @Binding var editComment : Bool
    @Binding var editDocID : String
    @Binding var editData : CommentFields
    @Binding var editReDocID : String
    @Binding var editReData : CommentFields
    @Binding var editRecomment : Bool
    @Binding var commentCollectionDocId : String
    @Binding var reCommentCount : Int
    @Binding var eachBool : [Bool]
    var currentUser : CurrentUserFields?
    var collectionName : String
    var collectionDocId : String
    
    var trimComment: String {
        commentText.trimmingCharacters(in: .whitespaces)
    }
    
    var body: some View {
        VStack {
            HStack{
                TextField("댓글 달기...", text: $commentText)
                    .font(.subheadline)
                    .padding()
                    .overlay{
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(lineWidth: 1)
                            .foregroundColor(.textGray)
                            .frame(height: 35)
                    }
                Spacer()
                
                if trimComment.count > 0 {
                    
                    // MARK: 답글달기 활성화 True이면 대댓글 쓰기
                    if replyComment{
                        Button {
                            commentVm.insertRecomment(collectionName: collectionName
                                                      , collectionDocId: collectionDocId
                                                      , commentCollectionName: "Comment"
                                                      , commentCollectionDocId: commentCollectionDocId
                                                      , data: CommentFields(
                                                        comment: CommentString(stringValue: commentText),
                                                        profileImage: CommentString(stringValue: currentUser?.profileImage.stringValue ?? ""),
                                                        nickName: CommentString(stringValue: currentUser?.nickName.stringValue ?? ""),
                                                        userID: CommentString(stringValue: Auth.auth().currentUser?.uid ?? ""),
                                                        id: CommentString(stringValue: UUID().uuidString)
                                                      )
                            )
                            commentText = ""
                            self.summitComment.toggle()
                            replyComment = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                                commentVm.fetchComment(collectionName: collectionName, collectionDocId: collectionDocId)
                            }
                        } label: {
                            Text("등록")
                                .font(.subheadline)
                                .foregroundColor(.textGray)
                                .bold()
                                .padding(.trailing)
                        }
                    }
                    else if editComment{
                        Button {
                            commentVm.updateComment(collectionName: collectionName, collectionDocId: collectionDocId, docID: editDocID, updateComment: commentText ,data: editData)
                            commentText = ""
                            self.summitComment.toggle()
                            editComment = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                                commentVm.fetchComment(collectionName: collectionName, collectionDocId: collectionDocId)
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
                            commentVm.updateRecomment(collectionName: collectionName, collectionDocId: collectionDocId, commentCollectionName: "Comment", commentCollectionDocId: commentCollectionDocId, docID: editReDocID, updateComment: commentText, data: editReData)
                            commentText = ""
                            self.summitComment.toggle()
                            editRecomment = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                                commentVm.fetchRecomment(collectionName: collectionName, collectionDocId: collectionDocId, commentCollectionName: "Comment", commentCollectionDocId: commentCollectionDocId)
                            }
                        } label: {
                            Text("등록")
                                .font(.subheadline)
                                .foregroundColor(.textGray)
                                .bold()
                                .padding(.trailing)
                        }
                    }
                    // MARK: 답글달기 활성화 else이면 그냥 댓글 쓰기
                    else{
                        Button {
                            // MARK: 댓글 업로드 구현
                            commentVm.insertComment(
                                collectionName: collectionName,
                                collectionDocId: collectionDocId,
                                data: CommentFields(
                                    comment: CommentString(stringValue: commentText),
                                    profileImage: CommentString(stringValue: currentUser?.profileImage.stringValue ?? ""),
                                    nickName: CommentString(stringValue: currentUser?.nickName.stringValue ?? ""),
                                    userID: CommentString(stringValue: Auth.auth().currentUser?.uid ?? ""),
                                    id: CommentString(stringValue: UUID().uuidString)
                                )
                            )
                            commentText = ""
                            self.summitComment.toggle()
                            replyComment = false
                            reCommentCount += 1
                            eachBool.insert(false, at: 0)
                            commentVm.fetchComment(collectionName: collectionName, collectionDocId: collectionDocId)    // 해당하는 매거진 댓글 정보 가져오기
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
        .frame(minWidth: 0, maxWidth: .infinity)
        .frame(height: 56)
        
    }
}

