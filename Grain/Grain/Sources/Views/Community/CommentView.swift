//
//  CommentView.swift
//  Grain
//
//  Created by 홍수만 on 2023/01/20.
//

import SwiftUI
import FirebaseAuth

//MARK: 입력된 댓글 레이아웃
struct CommentView: View {

    
    let userVM: UserViewModel
    @StateObject var commentVm = CommentViewModel()

    var collectionName : String     // 경로 받아오기 최초 컬렉션 받아오기 ex) Magazine
    var collectionDocId : String    // 경로 받아오기 최초 컬렌션 하위 문서ID 받아오기 ex)
    
    var currentUser : CurrentUserFields?  //현재 유저 받아오기
    
    @Binding var commentCollectionDocId: String
    @Binding var replyCommentText: String
    @Binding var replyContent: String
    @Binding var replyComment : Bool  // 답글 표시 Bool값
    @State var readMoreComments : Bool = false   //답글 더보기 Bool값
    @State var reCommentCount : Int = 0
    @State var eachBool : [Bool] = []
    func makeEachBool(count: Int){  // 댓글 갯수만큼 bool 배열을 만듬 예) 댓글 3개면 [ false, false, false ]
        eachBool = Array(repeating: false, count: count)
    }

    var body: some View {
        VStack(alignment: .leading){
            ScrollView() {
                ForEach(commentVm.sortedRecentComment.indices, id: \.self){ index in
                    HStack(alignment: .top) {
                        VStack(alignment: .leading){
                            if let user = userVM.users.first(where: { $0.fields.id.stringValue == commentVm.sortedRecentComment[index].fields.userID.stringValue})
                            {
                                NavigationLink {
                                    UserDetailView(user: user, userVM: userVM)
                                } label: {
                                    ProfileImage(imageName: commentVm.sortedRecentComment[index].fields.profileImage.stringValue)
                                }
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            HStack{
                                Text(commentVm.sortedRecentComment[index].fields.nickName.stringValue)
                                    .font(.caption)
                                    .fontWeight(.bold)
                                HStack{
                                    Text("・")
                                        .font(.caption2)
                                        .padding(.trailing, -5)
                                    Text(commentVm.sortedRecentComment[index].createTime.toDate()?.renderTime() ?? "")
                                        .font(.caption2)
                                }
                            }.padding(.bottom, -5)
                            Text(commentVm.sortedRecentComment[index].fields.comment.stringValue)
                                .font(.footnote)
                                .padding(.bottom, -1)
                            
                            //MARK: 댓글 에디트
                            HStack {
                                
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
                                    Button{
                                        //                                    commentVm.updateComment(collectionName: "Community", collectionDocId: collectionDocId, docID: comment.id.stringValue, updateComment: commentText,data: comment)
                                    } label: {
                                        Text("수정")
                                    }
                                    Button{
                                        //                                    commentVm.deleteComment(collectionName: "Community", collectionDocId: collectionDocId, docID: comment.id.stringValue)
                                    } label: {
                                        Text("삭제")
                                    }
                                }
                            }
                            .font(.caption2)
                            .foregroundColor(.textGray)
                            .padding(.top, 1)
                            .padding(.bottom, -3)
                            
                            if readMoreComments && eachBool[index]{
                                VStack{
                                    CommunityRecommentView(userVM: userVM, currentUser: currentUser, commentCollectionDocId: commentVm.sortedRecentComment[index].fields.id.stringValue, collectionName: collectionName, collectionDocId: collectionDocId)

                                }
                            }
                        }
                        Spacer()
                    }
                    .padding(7)
                    Divider()
                }
            }
            .refreshable {
                
            }

        }.onAppear{
            commentVm.fetchComment(collectionName: "Community", collectionDocId: collectionDocId)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                reCommentCount = commentVm.sortedRecentComment.count
                makeEachBool(count: reCommentCount)
            }
            
            
        }
    }
}

