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
    @State var eachBool : [Bool] = []   // 댓글 각각 [Bool] 배열 -> 판별을 위해
    @State var commentLoading : Bool = false    //첫 번째 댓글 혹시 모를 로딩
    @State var reommentUserID : String = "" // 대댓글 유저ID -> 알림 기능을 위해
    
    @Binding var magazineData: MagazineDocument?
    
    
    var collectionName : String     // 경로 받아오기 최초 컬렉션 받아오기 ex) Magazine
    var collectionDocId : String    // 경로 받아오기 최초 컬렌션 하위 문서ID 받아오기 ex) Magazine - 4ADB415C-871A-4FAF-86EA-D279D145CD37
    
    
        
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
        
    var body: some View {
        VStack() {
            ScrollView{
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
                                            KFImage(URL(string: commentVm.sortedRecentComment[index].fields.profileImage.stringValue) ?? URL(string: defaultProfileImage()))
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
                                            MagazineCommentNickNameView(user: user)
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
                                            .padding(.top, 3)
                                        // MARK: - 답글달기, 답글 더보기, 수정 , 삭제
                                        HStack{
                                            Button {
                                                replyComment.toggle()
                                                replyCommentText = "@" + commentVm.sortedRecentComment[index].fields.nickName.stringValue
                                                commentCollectionDocId = commentVm.sortedRecentComment[index].fields.id.stringValue
                                                reommentUserID = commentVm.sortedRecentComment[index].fields.userID.stringValue
                                            } label: {
                                                Text("답글달기")
                                                    .font(.caption2)
                                                    .foregroundColor(.textGray)
                                                    .padding(.top, 1)
                                                    .padding(.bottom, -3)
                                            }
                                            // MARK: 답글 더보기
                                            
                                            if let recommentCount = commentVm.sortedRecentRecommentCount[commentVm.sortedRecentComment[index].fields.id.stringValue]{
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
                                            if commentVm.sortedRecentComment[index].fields.userID.stringValue == Auth.auth().currentUser?.uid{
                                                Button {
                                                    editComment.toggle()
                                                    editDocID = commentVm.sortedRecentComment[index].fields.id.stringValue
                                                    editData = commentVm.sortedRecentComment[index].fields
                                                } label: {
                                                    Text("수정")
                                                        .font(.caption2)
                                                        .foregroundColor(.textGray)
                                                        .padding(.top, 1)
                                                        .padding(.bottom, -3)
                                                }
                                                //  MARK: 삭제
                                                Button{
                                                    deleteDocId = commentVm.sortedRecentComment[index].fields.id.stringValue
                                                    deleteCommentAlertBool.toggle()
                                                } label: {
                                                    Text("삭제")
                                                        .font(.caption2)
                                                        .foregroundColor(.textGray)
                                                        .padding(.top, 1)
                                                        .padding(.bottom, -3)
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
                                       
                                        if let recommentCount = commentVm.sortedRecentRecommentCount[commentVm.sortedRecentComment[index].fields.id.stringValue]{
                                            if  readMoreComments && eachBool[index]{
                                                MagazineRecommentView(userVM: userVM, commentVm: commentVm, magazineVM: magazineVM, editRecomment: $editRecomment, editReDocID: $editReDocID, editReColletionDocID: $editReColletionDocID, editReData: $editReData, commentText: $commentText, commentCollectionDocId: commentVm.sortedRecentComment[index].fields.id.stringValue, collectionName: collectionName, collectionDocId: collectionDocId)
                                            }else if recommentCount <= 5 {
                                                MagazineRecommentView(userVM: userVM, commentVm: commentVm, magazineVM: magazineVM, editRecomment: $editRecomment, editReDocID: $editReDocID, editReColletionDocID: $editReColletionDocID, editReData: $editReData, commentText: $commentText, commentCollectionDocId: commentVm.sortedRecentComment[index].fields.id.stringValue, collectionName: collectionName, collectionDocId: collectionDocId)
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
                                            .padding(.top, 3)
                                        
                                        
                                        // MARK: 답글 더보기
                                        if let recommentCount = commentVm.sortedRecentRecommentCount[commentVm.sortedRecentComment[index].fields.id.stringValue]{
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

                                        if let recommentCount = commentVm.sortedRecentRecommentCount[commentVm.sortedRecentComment[index].fields.id.stringValue]{
                                            if  readMoreComments && eachBool[index]{
                                                MagazineRecommentView(userVM: userVM, commentVm: commentVm, magazineVM: magazineVM, editRecomment: $editRecomment, editReDocID: $editReDocID, editReColletionDocID: $editReColletionDocID, editReData: $editReData, commentText: $commentText, commentCollectionDocId: commentVm.sortedRecentComment[index].fields.id.stringValue, collectionName: collectionName, collectionDocId: collectionDocId)
                                            }else if recommentCount <= 5 {
                                                MagazineRecommentView(userVM: userVM, commentVm: commentVm, magazineVM: magazineVM, editRecomment: $editRecomment, editReDocID: $editReDocID, editReColletionDocID: $editReColletionDocID, editReData: $editReData, commentText: $commentText, commentCollectionDocId: commentVm.sortedRecentComment[index].fields.id.stringValue, collectionName: collectionName, collectionDocId: collectionDocId)
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
                                    Image(systemName: "ellipsis.bubble")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 60, height: 60)
                                        .foregroundColor(.middlebrightGray)
                                    Spacer()
                                }
                                .padding(20)
                                Text("첫 번째 댓글을 남겨주세요~!")
                                    .font(.headline)
                                    .foregroundColor(.middlebrightGray)
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
                    KFImage(URL(string: userVM.currentUsers?.profileImage.stringValue ?? "" ) ??  URL(string: defaultProfileImage()) )
                        .resizable()
                        .frame(width: 35, height: 35)
                        .cornerRadius(30)
                        .overlay {
                            Circle()
                                .stroke(lineWidth: 0.5)
                        }
                        .padding(.leading)
                    MagazineCommentTextField(commentVm: commentVm, userVM: userVM, commentText: $commentText, summitComment: $summitComment, replyComment: $replyComment, editComment: $editComment, editDocID: $editDocID, editData: $editData,editReDocID: $editReDocID, editReColletionDocID: $editReColletionDocID, editReData: $editReData, editRecomment: $editRecomment, commentCollectionDocId: $commentCollectionDocId, magazineData: $magazineData, reommentUserID: $reommentUserID, currentUser: userVM.currentUsers,collectionName: collectionName, collectionDocId: collectionDocId)
                    
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
    @ObservedObject var userVM : UserViewModel
    
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
    @Binding var magazineData: MagazineDocument?
    @Binding var reommentUserID : String
    
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
                    
                    // MARK: 대댓글 업로드
                    if replyComment{
                        Button {

                            replyComment = false
                            
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
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                                commentVm.fetchComment(collectionName: collectionName, collectionDocId: collectionDocId)
                            }
                            
                            // MARK: 대댓글 유저한테 알림보내기 기능
                            let sender = PushNotificationSender(serverKeyString: "")
                            if let user = userVM.users.first(where: { $0.fields.id.stringValue == reommentUserID })
                            {
                                for i in user.fields.fcmToken.arrayValue.values {

<<<<<<< Updated upstream
                                    sender.sendPushNotification(to: i.stringValue, title: "대댓글", message: "\(userVM.currentUsers?.nickName.stringValue ?? "")님이 회원님의 댓글에 대댓글을 남겼습니다", image: magazineData?.fields.image.arrayValue.values[0].stringValue ?? "")
=======
                                    sender.sendPushNotification(to: i.stringValue, title: "바로 지금! 대댓글이 도착했습니다. 🎉", message: "\(userVM.currentUsers?.nickName.stringValue ?? "")님이 회원님의 댓글에 대댓글을 남겼어요 💬", image: "")
>>>>>>> Stashed changes

                                }
                            }
                            
                        } label: {
                            Text("등록")
                                .font(.subheadline)
                                .foregroundColor(.textGray)
                                .bold()
                                .padding(.trailing)
                        }
                    }
                    // MARK: 대댓글 수정
                    else if editRecomment{
                        Button {
                            editRecomment = false
                            
                            commentVm.updateRecomment(collectionName: collectionName, collectionDocId: collectionDocId, commentCollectionName: "Comment", commentCollectionDocId: editReColletionDocID, docID: editReDocID, updateComment: commentText, data: editReData)
                            
                            commentText = ""
                            self.summitComment.toggle()
                            
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
                    // MARK: 댓글 수정
                    else if editComment{
                        Button {
                            
                            editComment = false
                            commentVm.updateComment(collectionName: collectionName, collectionDocId: collectionDocId, docID: editDocID, updateComment: commentText ,data: editData)
                            commentText = ""
                            self.summitComment.toggle()
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
                    
                    // MARK: 댓글 업로드
                    else{
                        Button {
                            // MARK: 댓글 업로드 구현
                        
                            replyComment = false
                            
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
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                                commentVm.fetchComment(collectionName: collectionName, collectionDocId: collectionDocId)
                            }
                            
                            // MARK: 매거진 게시글 유저한테 알림보내기 기능
                            if let magazineData = self.magazineData {
                                
                                if let user = userVM.users.first(where: { $0.fields.id.stringValue == magazineData.fields.userID.stringValue })
                                {
                                    let sender = PushNotificationSender(serverKeyString: "")
                                    for i in user.fields.fcmToken.arrayValue.values {
<<<<<<< Updated upstream
                                        sender.sendPushNotification(to: i.stringValue, title:  "댓글", message: "\(userVM.currentUsers?.nickName.stringValue ?? "")님이 회원님의 \(magazineData.fields.title.stringValue) 매거진 에 댓글을 남겼습니다", image: magazineData.fields.image.arrayValue.values[0].stringValue )
=======
                                        sender.sendPushNotification(to: i.stringValue, title:  "게시글에 새로운 댓글이 달렸습니다! 📨", message: "\(userVM.currentUsers?.nickName.stringValue ?? "")님이 회원님의 \(magazineData.fields.title.stringValue) 매거진 게시글에 댓글을 남겼어요, 지금 확인하고 댓글 작성자와 함께 대화해 보세요. 💬 ", image: "")
>>>>>>> Stashed changes

                                    }
                                }
                            }
                            
                        } label: {
                            Text("등록")
                                .font(.subheadline)
                                .foregroundColor(.textGray)
                                .bold()
                                .padding(.trailing)
                        }
                    }
                }
                // MARK: 등록 활성화 전
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



