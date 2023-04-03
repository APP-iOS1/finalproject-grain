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
    @State var deleteCommentAlertBool : Bool = false
    @State var deleteDocId : String = ""
    @State var nickName : String = "" // 닉네임 변경을 위해
    @State var editReColletionDocID: String = "" // 리코멘트에서 값을 중간에서 받기 위해
    @State var eachBool : [Bool] = []
    @State var commentLoading : Bool = false
    
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
                    if !(commentVm.sortedRecentComment.count == 0){
                        ForEach(commentVm.sortedRecentComment.indices, id:\.self){ index in
                            if let user = userVM.users.first(where: { $0.fields.id.stringValue == commentVm.sortedRecentComment[index].fields.userID.stringValue})
                            {
                                HStack(alignment: .top){
                                    // MARK: -  유저 프로필 이미지
                                    VStack(alignment: .leading){
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
                                        //
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
                                                replyCommentText = "@" + nickName
                                                commentCollectionDocId = commentVm.sortedRecentComment[index].fields.id.stringValue
                                            } label: {
                                                Text("답글달기")
                                            }
                                            // MARK: 답글 더보기
                                            
                                            if let recommentCount = commentVm.sortedRecentRecommentCount[commentVm.sortedRecentComment[index].fields.id.stringValue]{
                                                if recommentCount > 5 {
                                                    Text("답글 더보기 (\(recommentCount))").onTapGesture {
                                                        makeEachBool(count: commentVm.sortedRecentRecommentCount.count)
                                                        readMoreComments = true
                                                        eachBool[index] = true
                                                    }
                                                }
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
                                                Button{
                                                    deleteDocId = commentVm.sortedRecentComment[index].fields.id.stringValue
                                                    deleteCommentAlertBool.toggle()
                                                } label: {
                                                    Text("삭제")
                                                        .alert(isPresented: $deleteCommentAlertBool) {
                                                            Alert(title: Text("댓글을 삭제하시겠어요?"),
                                                                  primaryButton:  .cancel(Text("취소")),
                                                                  secondaryButton:.destructive(Text("삭제"),action: {
                                                                commentVm.deleteComment(collectionName: collectionName, collectionDocId: collectionDocId, docID: deleteDocId)
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
                                        // 정훈 작업 중
                                        VStack{
                                            if let recommentCount = commentVm.sortedRecentRecommentCount[commentVm.sortedRecentComment[index].fields.id.stringValue]{
                                                if  readMoreComments && eachBool[index]{
                                                    MagazineRecommentView(userVM: userVM, commentVm: commentVm, magazineVM: magazineVM, editRecomment: $editRecomment, editReDocID: $editReDocID, editReColletionDocID: $editReColletionDocID, editReData: $editReData, commentText: $commentText, commentCollectionDocId: commentVm.sortedRecentComment[index].fields.id.stringValue, collectionName: collectionName, collectionDocId: collectionDocId)
                                                }else if recommentCount <= 5 {
                                                    MagazineRecommentView(userVM: userVM, commentVm: commentVm, magazineVM: magazineVM, editRecomment: $editRecomment, editReDocID: $editReDocID, editReColletionDocID: $editReColletionDocID, editReData: $editReData, commentText: $commentText, commentCollectionDocId: commentVm.sortedRecentComment[index].fields.id.stringValue, collectionName: collectionName, collectionDocId: collectionDocId)
                                                }
                                            }
                                        }
                                        
                                    }
                                    .frame(width: Screen.maxWidth * 0.8)
                                }
                                Divider()
                            }
                            else
                            { //MARK: 탈퇴 유저
                                HStack(alignment: .top){
                                    // MARK: -  유저 프로필 이미지
                                    VStack{
                                        KFImage(URL(string:"https://firebasestorage.googleapis.com/v0/b/grain-final.appspot.com/o/EditorFolder%2FdefaultImage%2Fdefault-user-icon-8.jpg?alt=media&token=1a514506-df59-484f-affb-b000ad1f348d"))
                                            .resizable()
                                            .frame(width: 35, height: 35)
                                            .cornerRadius(30)
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
                                                Text(commentVm.sortedRecentComment[index].createTime.toDate()?.renderTime() ?? "")
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
                                            if let recommentCount = commentVm.sortedRecentRecommentCount[commentVm.sortedRecentComment[index].fields.id.stringValue]{
                                                if recommentCount > 5 {
                                                    Text("답글 더보기 (\(recommentCount))").onTapGesture {
                                                        makeEachBool(count: commentVm.sortedRecentRecommentCount.count)
                                                        readMoreComments = true
                                                        eachBool[index] = true
                                                    }
                                                }
                                            }
                                        }
                                        .font(.caption2)
                                        .foregroundColor(.textGray)
                                        .padding(.top, 1)
                                        .padding(.bottom, -3)
                                        VStack{
                                            if let recommentCount = commentVm.sortedRecentRecommentCount[commentVm.sortedRecentComment[index].fields.id.stringValue]{
                                                if  readMoreComments && eachBool[index]{
                                                    MagazineRecommentView(userVM: userVM, commentVm: commentVm, magazineVM: magazineVM, editRecomment: $editRecomment, editReDocID: $editReDocID, editReColletionDocID: $editReColletionDocID, editReData: $editReData, commentText: $commentText, commentCollectionDocId: commentVm.sortedRecentComment[index].fields.id.stringValue, collectionName: collectionName, collectionDocId: collectionDocId)
                                                }else if recommentCount <= 5 {
                                                    MagazineRecommentView(userVM: userVM, commentVm: commentVm, magazineVM: magazineVM, editRecomment: $editRecomment, editReDocID: $editReDocID, editReColletionDocID: $editReColletionDocID, editReData: $editReData, commentText: $commentText, commentCollectionDocId: commentVm.sortedRecentComment[index].fields.id.stringValue, collectionName: collectionName, collectionDocId: collectionDocId)
                                                }
                                            }
                                            
                                        }
                                        
                                        
                                    }
                                    .frame(width: Screen.maxWidth * 0.8)
                                }
                                Divider()
                            }
                        }
                        .padding(.leading , 7)
                        .padding(.bottom , 4)
                    }else{
                        // MARK: -  댓글이 없을때
                        if commentLoading{
                            VStack{
                                HStack{
                                    Spacer()
                                    Image("cameraComment")
                                        .resizable()
                                        .frame(width: 100, height: 100)
                                    Spacer()
                                }
                                .padding(20)
                                Text("첫 번째 댓글을 남겨주세요~!")
                                    .font(.headline)
                                    .fontWeight(.bold)
                            }.position(x: Screen.maxWidth * 0.5 , y: Screen.maxHeight * 0.3)
                        }else{
                            VStack{
                                ProgressView()
                                    .onAppear{
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                                            commentLoading = true
                                        }
                                    }
                            }.position(x: Screen.maxWidth * 0.5 , y: Screen.maxHeight * 0.3)

                        }
   
                    }
                }
                
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
                    MagazineCommentTextField(commentVm: commentVm, commentText: $commentText, summitComment: $summitComment, replyComment: $replyComment, editComment: $editComment, editDocID: $editDocID, editData: $editData,editReDocID: $editReDocID, editReColletionDocID: $editReColletionDocID, editReData: $editReData, editRecomment: $editRecomment, commentCollectionDocId: $commentCollectionDocId, currentUser: userVM.currentUsers,collectionName: collectionName, collectionDocId: collectionDocId)
                    
                }
            }
        }
        .onAppear{
            commentVm.fetchComment(collectionName: collectionName, collectionDocId: collectionDocId)    // 해당하는 매거진 댓글 정보 가져오기
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                makeEachBool(count: commentVm.sortedRecentComment.count)
            }
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
    @Binding var editReColletionDocID: String // commentCollectionDocId 이 값을 받기 위해
    @Binding var editReData : CommentFields
    @Binding var editRecomment : Bool
    @Binding var commentCollectionDocId : String
    
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
                    else if editRecomment{
                        Button {
                            commentVm.updateRecomment(collectionName: collectionName, collectionDocId: collectionDocId, commentCollectionName: "Comment", commentCollectionDocId: editReColletionDocID, docID: editReDocID, updateComment: commentText, data: editReData)
                            commentText = ""
                            self.summitComment.toggle()
                            editRecomment = false
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
