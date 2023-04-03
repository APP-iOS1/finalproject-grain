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
    @State var eachBool : [Bool] = []
    
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
    @Binding var commentCount : Int // 댓글 갯수 디테일 뷰랑 바인딩 작업
    @Binding var editReColletionDocID: String
    
    func makeEachBool(count: Int){  // 댓글 갯수만큼 bool 배열을 만듬 예) 댓글 3개면 [ false, false, false ]
        eachBool = Array(repeating: false, count: count)
       
    }
    
    var body: some View {
        VStack(alignment: .leading){
            ScrollView() {
                if !(commentVm.sortedRecentComment.count == 0) {
                    ForEach(commentVm.sortedRecentComment.indices, id:\.self){ index in
                        if let user = userVM.users.first(where: { $0.fields.id.stringValue == commentVm.sortedRecentComment[index].fields.userID.stringValue})
                        {
                            HStack(alignment: .top) {
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
                                }
                                .frame(width: Screen.maxWidth * 0.1)
                                
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
                                            Text(commentVm.sortedRecentComment[index].createTime.toDate()?.renderTime() ?? "")
                                                .font(.caption2)
                                        }
                                        Spacer()
                                    }
                                    .padding(.bottom, -5)
                                    
                                    Text(commentVm.sortedRecentComment[index].fields.comment.stringValue)
                                        .font(.footnote)
                                        .padding(.bottom, -1)
                                    
                                    //MARK: 댓글 에디트
                                    HStack {
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
                                                    makeEachBool(count: commentVm.sortedRecentComment.count)
                                                    readMoreComments = true
                                                    eachBool[index] = true
                                                }
                                                
                                            }
                                        }
                                        
                                        if commentVm.sortedRecentComment[index].fields.userID.stringValue == Auth.auth().currentUser?.uid{
                                            Button{
                                                editComment.toggle()
                                                editDocID = commentVm.sortedRecentComment[index].fields.id.stringValue
                                                editData = commentVm.sortedRecentComment[index].fields
                                            } label: {
                                                Text("수정")
                                            }
                                            Button{
                                                deleteDocId = commentVm.sortedRecentComment[index].fields.id.stringValue
                                                deleteCommentAlertBool.toggle()
                                            } label: {
                                                Text("삭제")
                                                    .alert(isPresented: $deleteCommentAlertBool) {
                                                        Alert(title: Text("댓글을 삭제하시겠어요?"),
                                                              primaryButton:  .cancel(Text("취소")),
                                                              secondaryButton:.destructive(Text("삭제"),action: {
                                                            commentVm.deleteComment(collectionName: "Community", collectionDocId: collectionDocId, docID: deleteDocId)
                                                            
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
                                    .padding(.bottom, 5)
                                    
                                    VStack{
                                        // 리코멘트
                                        if let recommentCount = commentVm.sortedRecentRecommentCount[commentVm.sortedRecentComment[index].fields.id.stringValue]{
                                            if  readMoreComments && eachBool[index]{
                                                CommunityRecommentView(commentVm: commentVm, userVM: userVM, magazineVM: magazineVM, commentCollectionDocId: commentVm.sortedRecentComment[index].fields.id.stringValue, collectionName: collectionName, collectionDocId: collectionDocId, replyContent: $replyContent , editRecomment: $editRecomment ,editReDocID: $editReDocID , editReData : $editReData , editReColletionDocID: $editReColletionDocID)
                                            }else if recommentCount <= 5 {
                                                CommunityRecommentView(commentVm: commentVm, userVM: userVM, magazineVM: magazineVM, commentCollectionDocId: commentVm.sortedRecentComment[index].fields.id.stringValue, collectionName: collectionName, collectionDocId: collectionDocId, replyContent: $replyContent , editRecomment: $editRecomment ,editReDocID: $editReDocID , editReData : $editReData , editReColletionDocID: $editReColletionDocID)
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
                                    .padding(.bottom, 5)
                                    
                                    VStack{
                                        // 리코멘트
                                        if let recommentCount = commentVm.sortedRecentRecommentCount[commentVm.sortedRecentComment[index].fields.id.stringValue]{
                                            if  readMoreComments && eachBool[index]{
                                                CommunityRecommentView(commentVm: commentVm, userVM: userVM, magazineVM: magazineVM, commentCollectionDocId: commentVm.sortedRecentComment[index].fields.id.stringValue, collectionName: collectionName, collectionDocId: collectionDocId, replyContent: $replyContent , editRecomment: $editRecomment ,editReDocID: $editReDocID , editReData : $editReData , editReColletionDocID: $editReColletionDocID)
                                                
                                            }else if recommentCount <= 5 {
                                                CommunityRecommentView(commentVm: commentVm, userVM: userVM, magazineVM: magazineVM, commentCollectionDocId: commentVm.sortedRecentComment[index].fields.id.stringValue, collectionName: collectionName, collectionDocId: collectionDocId, replyContent: $replyContent , editRecomment: $editRecomment ,editReDocID: $editReDocID , editReData : $editReData , editReColletionDocID: $editReColletionDocID)
                                                
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
                    VStack{
                        HStack{
                            Spacer()
                            Image("cameraComment")
                                .resizable()
                                .frame(width: 70, height: 70)
                            Spacer()
                        }
                        Text("첫 번째 댓글을 남겨주세요~!")
                            .font(.subheadline)
                            .fontWeight(.bold)
                    }

                }
            }
            
        }
        .onAppear {
            commentVm.fetchComment(collectionName: "Community", collectionDocId: collectionDocId)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                commentCount = commentVm.sortedRecentComment.count
                makeEachBool(count: commentVm.sortedRecentComment.count)
            }
            
        }
       
    }
    
}
