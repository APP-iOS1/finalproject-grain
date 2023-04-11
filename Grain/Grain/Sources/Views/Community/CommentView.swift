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
    @ObservedObject var commentVm: CommentViewModel
    
    @ObservedObject var userVM : UserViewModel
    @ObservedObject var magazineVM : MagazineViewModel
    
    @State var readMoreComments : Bool = false   //답글 더보기 Bool값
    @State var deleteDocId : String = ""
    @State var nickName : String = "" // 닉네임 변경을 위해
    
    @State var recomments = [[String: CommentFields]]()
    @State var eachBool : [Bool] = []
    @State private var commentDeleteIndex: Int = 0
    @State private var deleteReComment: Bool = false

    var collectionName: String     // 경로 받아오기 최초 컬렉션 받아오기 ex) Magazine
    var collectionDocId: String    // 경로 받아오기 최초 컬렌션 하위 문서ID 받아오기 ex)
    
    @Binding var commentCollectionDocId: String // 댓글
    @Binding var replyCommentText: String // @nickName + 님에게
    @Binding var replyContent: String // 대댓글 내용
    @Binding var replyComment: Bool  // 답글 달기 표시 Bool값
    @Binding var editComment: Bool // 댓글 수정 Bool값
    @Binding var editDocID: String
    @Binding var editData: CommentFields
    @Binding var editRecomment: Bool // 대댓글 수정 Bool값
    @Binding var editReDocID: String
    @Binding var editReData: CommentFields
    @Binding var commentCount: Int // 댓글 갯수 디테일 뷰랑 바인딩 작업
    @Binding var editReColletionDocID: String
    @Binding var reommentUserID: String
    @Binding var isCommentDelete: Bool
    @Binding var deleteCommentAlertBool : Bool

    func makeEachBool(count: Int){  // 댓글 갯수만큼 bool 배열을 만듬 예) 댓글 3개면 [ false, false, false ]
        eachBool = Array(repeating: false, count: count)
       
    }
    
    func defaultProfileImage() -> String{
        var https : String = "https://"
        if let infolist = Bundle.main.infoDictionary {
            if let url = infolist["FailProfileImage"] as? String {
                https += url
            }
        }
        return https
    }
    func infolistCommunityString() -> String{
        var communityString : String = ""
        if let infolist = Bundle.main.infoDictionary {
            if let str = infolist["UuidCommmunity"] as? String {
                communityString = str
            }
        }
        return communityString
    }
    
    
    
    var body: some View {
        VStack(alignment: .leading){
                if !(commentVm.sortedRecentComment.count == 0) {
                    ForEach(Array(commentVm.sortedRecentComment.enumerated()), id:\.1.self){ (index, item) in
                        if let user = userVM.users.first(where: { $0.fields.id.stringValue == item.fields.userID.stringValue})
                        {
                            
                            HStack(alignment: .top) {
                                VStack(alignment: .leading){
                                    NavigationLink {
                                        UserDetailView(userVM: userVM, magazineVM: magazineVM, user: user)
                                    } label: {
                                        KFImage(URL(string: user.fields.profileImage.stringValue) ?? URL(string: defaultProfileImage()))
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
                                        CommunityCommentNickNameView(user: user)
                                        HStack{
                                            Text("・")
                                                .font(.caption2)
                                                .padding(.trailing, -5)
                                            Text(item.createTime.toDate()?.renderTime() ?? "")
                                                .font(.caption2)
                                        }
                                        Spacer()
                                    }
                                    .padding(.bottom, -5)
                                    
                                    Text(item.fields.comment.stringValue)
                                        .font(.footnote)
                                        .padding(.bottom, -1)
                                        .padding(.top, 3)
                                    //MARK: 댓글 에디트
                                    HStack {
                                        Button {
                                            replyComment.toggle()
                                            replyCommentText = "@" + item.fields.nickName.stringValue
                                            commentCollectionDocId = item.fields.id.stringValue
                                            reommentUserID = item.fields.userID.stringValue
                                        } label: {
                                            Text("답글달기")
                                                .font(.caption2)
                                                .foregroundColor(.textGray)
                                                .padding(.top, 1)
                                                .padding(.bottom, -3)
                                        }
                                        // MARK: 답글 더보기
                                        if let recommentCount = commentVm.sortedRecentRecommentCount[item.fields.id.stringValue]{
                                            if recommentCount > 5 {
                                                Text("답글 더보기 (\(recommentCount))")
                                                    .font(.caption2)
                                                    .foregroundColor(.textGray)
                                                    .padding(.top, 1)
                                                    .padding(.bottom, -3)
                                                    .onTapGesture {
                                                    makeEachBool(count: commentVm.sortedRecentComment.count)
                                                    readMoreComments = true
                                                    eachBool[index] = true
                                                }
                                                
                                            }
                                        }
                                        
                                        if item.fields.userID.stringValue == Auth.auth().currentUser?.uid{
                                            Button{
                                                editComment.toggle()
                                                editDocID = item.fields.id.stringValue
                                                editData = item.fields
                                            } label: {
                                                Text("수정")
                                                    .font(.caption2)
                                                    .foregroundColor(.textGray)
                                                    .padding(.top, 1)
                                                    .padding(.bottom, -3)
                                            }
                                            Button{
                                                self.deleteCommentAlertBool.toggle()
                                                self.deleteDocId = commentVm.sortedRecentComment[index].fields.id.stringValue
                                                self.commentDeleteIndex = index
                                            } label: {
                                                Text("삭제")
                                                    .font(.caption2)
                                                    .foregroundColor(.textGray)
                                                    .padding(.top, 1)
                                                    .padding(.bottom, -3)
                                            }
                                        }
                                    }
                                   
                                    // 리코멘트
                                    if let recommentCount = commentVm.sortedRecentRecommentCount[item.fields.id.stringValue]{
                                        if  readMoreComments && eachBool[index]{
                                            CommunityRecommentView(commentVm: commentVm, userVM: userVM, magazineVM: magazineVM, commentCollectionDocId: item.fields.id.stringValue, collectionName: collectionName, collectionDocId: collectionDocId, replyContent: $replyContent , editRecomment: $editRecomment ,editReDocID: $editReDocID , editReData : $editReData , editReColletionDocID: $editReColletionDocID)
                                        }else if recommentCount <= 5 {
                                            CommunityRecommentView(commentVm: commentVm, userVM: userVM, magazineVM: magazineVM, commentCollectionDocId: item.fields.id.stringValue, collectionName: collectionName, collectionDocId: collectionDocId, replyContent: $replyContent , editRecomment: $editRecomment , editReDocID: $editReDocID , editReData : $editReData , editReColletionDocID: $editReColletionDocID)
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
                                    Image("defaultUserImage")
                                        .resizable()
                                        .frame(width: 35, height: 35)
                                        .cornerRadius(30)
                                        .padding(.horizontal, 7)
                                        .overlay {
                                            Circle()
                                                .stroke(lineWidth: 0.5)
                                        }
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
                                            Text(item.createTime.toDate()?.renderTime() ?? "")
                                                .font(.caption2)
                                        }
                                        
                                        Spacer()
                                    }
                                    .padding(.bottom, -5)
                                    
                                    //MARK: - 댓글 내용
                                    Text("삭제된 댓글입니다.")
                                        .font(.footnote)
                                        .padding(.bottom, -1)
                                        .padding(.top, 3)
                                
                                    // MARK: 답글 더보기
                                    if let recommentCount = commentVm.sortedRecentRecommentCount[item.fields.id.stringValue]{
                                        if recommentCount > 5 {
                                            Text("답글 더보기 (\(recommentCount))")
                                                .font(.caption2)
                                                .foregroundColor(.textGray)
                                                .padding(.top, 1)
                                                .padding(.bottom, -3)
                                                .onTapGesture {
                                                makeEachBool(count: commentVm.sortedRecentRecommentCount.count)
                                                readMoreComments = true
                                                eachBool[index] = true
                                            }
                                        }
                                    }
                                    
                                    
                                    
                                    // 리코멘트
                                    if let recommentCount = commentVm.sortedRecentRecommentCount[item.fields.id.stringValue]{
                                        if  readMoreComments && eachBool[index]{
                                            CommunityRecommentView(commentVm: commentVm, userVM: userVM, magazineVM: magazineVM, commentCollectionDocId: item.fields.id.stringValue, collectionName: collectionName, collectionDocId: collectionDocId, replyContent: $replyContent , editRecomment: $editRecomment ,editReDocID: $editReDocID , editReData : $editReData , editReColletionDocID: $editReColletionDocID)
                                            
                                        }else if recommentCount <= 5 {
                                            CommunityRecommentView(commentVm: commentVm, userVM: userVM, magazineVM: magazineVM, commentCollectionDocId: item.fields.id.stringValue, collectionName: collectionName, collectionDocId: collectionDocId, replyContent: $replyContent , editRecomment: $editRecomment ,editReDocID: $editReDocID , editReData : $editReData , editReColletionDocID: $editReColletionDocID)
                                            
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
                    HStack{
                        Spacer()
                        Text("첫 번째 댓글을 남겨주세요.!")
                            .font(.footnote)
                            .foregroundColor(.middlebrightGray)
                        Image(systemName: "ellipsis.bubble")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 15, height: 15)
                            .foregroundColor(.middlebrightGray)
                            .offset(x: -3)
                        Spacer()
                    }
                }
       
            
        }
        .onAppear {
            commentVm.fetchComment(collectionName: infolistCommunityString(), collectionDocId: collectionDocId)

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                commentCount = commentVm.sortedRecentComment.count
                makeEachBool(count: commentVm.sortedRecentComment.count)
            }
        }
        .onChange(of: isCommentDelete) { newValue in
            if commentVm.sortedRecentComment.count == 1 {
                commentVm.sortedRecentComment.removeFirst()
                commentVm.deleteComment(collectionName: infolistCommunityString(), collectionDocId: collectionDocId, docID: deleteDocId)
            }else {
                commentVm.deleteComment(collectionName: infolistCommunityString(), collectionDocId: collectionDocId, docID: deleteDocId)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    commentVm.fetchComment(collectionName: collectionName, collectionDocId: collectionDocId)
                }
            }
            
        }
        .onChange(of: commentVm.sortedRecentComment) { newValue in
            commentCount = newValue.count
        }
    }
    
}
