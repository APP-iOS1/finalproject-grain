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
    @ObservedObject var commentVm: CommentViewModel
    @ObservedObject var userVM : UserViewModel
    @ObservedObject var magazineVM : MagazineViewModel
    
    @State var readMoreComments : Bool = false   //답글 더보기 Bool값
    var collectionName : String     // 경로 받아오기 최초 컬렉션 받아오기 ex) Magazine
    var collectionDocId : String    // 경로 받아오기 최초 컬렌션 하위 문서ID 받아오기 ex)
    
    @Binding var commentCollectionDocId: String
    @Binding var replyCommentText: String
    @Binding var replyContent: String
    @Binding var replyComment : Bool  // 답글 표시 Bool값
    @Binding var editComment : Bool
    @Binding var editDocID : String
    @Binding var editData : CommentFields
    @Binding var editRecomment : Bool
    @Binding var editReDocID : String
    @Binding var editReData : CommentFields
    @Binding var eachBool : [Bool]
    @Binding var reCommentCount : Int
    
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
                                    UserDetailView(userVM: userVM, magazineVM: magazineVM, user: user)
                                } label: {
                                    ProfileImage(imageName: commentVm.sortedRecentComment[index].fields.profileImage.stringValue)
                                }
                            } else {
                                ProfileImage(imageName: "https://firebasestorage.googleapis.com/v0/b/grain-final.appspot.com/o/G5KvQmuPEehYVxvO7bHWkpBoY0f2%2FCD8C78A7-C100-42BC-8481-17E7BBC2E962%2F2C7635E2-6C57-493F-83CB-3E4B3D862132?alt=media&token=58695683-ecf8-4109-afe9-c5084580907a")
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            HStack{
                                if userVM.users.contains(where: { $0.fields.id.stringValue == commentVm.sortedRecentComment[index].fields.userID.stringValue }) {
                                    Text(commentVm.sortedRecentComment[index].fields.nickName.stringValue)
                                        .font(.caption)
                                        .fontWeight(.bold)
                                } else {
                                    Text("Unkown_User")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                }
                                
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
                                    commentVm.sortedRecentRecomment.removeAll()
                                } label: {
                                    Text("답글 더보기")
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
                                        commentVm.deleteComment(collectionName: "Community", collectionDocId: collectionDocId, docID: commentVm.sortedRecentComment[index].fields.id.stringValue)
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                                            commentVm.fetchComment(collectionName: "Community", collectionDocId: collectionDocId)
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
                            
                            if readMoreComments && eachBool[index]{
                                VStack{
                                    CommunityRecommentView(commentVm: commentVm, userVM: userVM, magazineVM: magazineVM, commentCollectionDocId: commentVm.sortedRecentComment[index].fields.id.stringValue, collectionName: collectionName, collectionDocId: collectionDocId, replyContent: $replyContent , editRecomment: $editRecomment ,editReDocID: $editReDocID , editReData : $editReData)
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

