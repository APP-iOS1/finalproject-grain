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
    @StateObject var commentVm = CommentViewModel() //댓글 뷰 모델 사용
    
    let userVM: UserViewModel
    
    var currentUser : CurrentUserFields?  //현재 유저 받아오기
    
    @State var commentText: String = "" // 댓글 작성 텍스트 필드
    @State var editButtonShowing : Bool = false // 내가 쓴 댓글 수정/삭제 한번에 보여줄려고 만든 Bool
    @State var summitComment : Bool = false // 내가 쓴 댓글 수정/삭제 한번에 보여줄려고 만든 Bool
    @State var deleebuttonBool : Bool = false
    @State var replyComment : Bool = false  // 답글 표시 Bool값
    @State var replyCommentText : String = "" // 답글 표시 이름 값
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
                                        UserDetailView(userVM: userVM, user: user)
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
                                }
                            }
                            .frame(width: Screen.maxWidth * 0.1)
                            
                            VStack(alignment: .leading){
                                HStack{
                                    NavigationLink {
                                        //유저 프로필 뷰 입장
                                    } label: {
                                        // MARK: 유저 닉네임
                                        Text(commentVm.sortedRecentComment[index].fields.nickName.stringValue)
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
                                    } label: {
                                        Text("답글 더보기")
                                    }
                                    
                                    if commentVm.sortedRecentComment[index].fields.userID.stringValue == Auth.auth().currentUser?.uid{
                                        Button {
                                            //수정 하기 버튼
                                            commentVm.updateComment(collectionName: collectionName, collectionDocId: collectionDocId, docID: commentVm.sortedRecentComment[index].fields.id.stringValue, updateComment: commentText,data: commentVm.sortedRecentComment[index].fields)
                                            commentVm.fetchComment(collectionName: collectionName, collectionDocId: collectionDocId)
                                            commentText = ""
                                            
                                        } label: {
                                            Text("수정")
                                        }
                                        //  MARK: 삭제
                                        Button {
                                            commentVm.deleteComment(collectionName: collectionName, collectionDocId: collectionDocId, docID: commentVm.sortedRecentComment[index].fields.id.stringValue)
                                            deleebuttonBool.toggle()
                                        } label: {
                                            Text("삭제")
                                        }.onChange(of: deleebuttonBool) { _ in
                                            commentVm.fetchComment(collectionName: collectionName, collectionDocId: collectionDocId)
                                        }
                                    }
                                }
                                .font(.caption2)
                                .foregroundColor(.textGray)
                                .padding(.top, 1)
                                .padding(.bottom, -3)
                                
                                VStack{
                                    if readMoreComments && eachBool[index]{
                                        MagazineRecommentView(userVM: userVM, currentUser: currentUser, commentVm: commentVm, commentCollectionDocId: commentVm.sortedRecentComment[index].fields.id.stringValue, collectionName: collectionName, collectionDocId: collectionDocId, commentText: $commentText)
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
                                Text(replyCommentText + "님에게 답글 남기는 중")
                                    .foregroundColor(.textGray)
                                    .font(.subheadline)
                                Spacer()
                                Button {
                                    replyComment.toggle()
                                    commentText = ""
                                } label: {
                                    Image(systemName: "xmark")
                                }
                            }.padding(10)
                        }
                }
                // MARK: 댓글 구역
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
                    MagazineCommentTextField(commentText: $commentText, summitComment: $summitComment, replyComment: $replyComment, commentCollectionDocId: $commentCollectionDocId, reCommentCount: $reCommentCount, eachBool: $eachBool, currentUser: currentUser,collectionName: collectionName, collectionDocId: collectionDocId)
                        .onChange(of: summitComment) { _ in
                            commentVm.fetchComment(collectionName: collectionName, collectionDocId: collectionDocId)
                        }
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
    @Binding var commentText: String
    @Binding var summitComment: Bool
    @Binding var replyComment : Bool
    @Binding var commentCollectionDocId : String
    @Binding var reCommentCount : Int
    @Binding var eachBool : [Bool]
    
    var currentUser : CurrentUserFields?
    var collectionName : String
    var collectionDocId : String
    
    var trimComment: String {
        commentText.trimmingCharacters(in: .whitespaces)
    }
    
    @StateObject var commentVm = CommentViewModel()
    
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
                            commentVm.fetchComment(collectionName: collectionName, collectionDocId: collectionDocId)
                            self.summitComment.toggle()
                            replyComment = false
                            reCommentCount += 1
                            eachBool.insert(false, at: 0)
    
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

