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
    
    let userVM: UserViewModel
    var currentUser : CurrentUserFields?  //현재 유저 받아오기
    
    @StateObject var commentVm = CommentViewModel() //댓글 뷰 모델 사용
    
    var commentCollectionDocId : String
    var collectionName : String     // 경로 받아오기 최초 컬렉션 받아오기 ex) Magazine
    var collectionDocId : String    // 경로 받아오기 최초 컬렌션 하위 문서ID 받아오기 ex) Magazine - 4ADB415C-871A-4FAF-86EA-D279D145CD37
    
    @Binding var commentText: String // 답글 입력 텍스트 필드 값
    
    var body: some View {
        
        VStack(alignment: .leading){
            
            // 댓글이 없으면 빈칸
            if commentVm.sortedRecentRecomment.count < 1 {
                
            }
            // 댓글이 한개 이상 존재하면 Foreach 구문 실행
            else{
                ForEach(commentVm.sortedRecentRecomment.indices, id: \.self){ index in
                    Divider()
                    HStack(alignment: .top){
                        // MARK: -  유저 프로필 이미지
                        VStack{
                            if let user = userVM.users.first(where: { $0.fields.id.stringValue == commentVm.sortedRecentComment[index].fields.userID.stringValue})
                            {
                                NavigationLink {
                                    UserDetailView(user: user, userVM: userVM)
                                } label: {
                                    KFImage(URL(string: commentVm.sortedRecentRecomment[index].fields.profileImage.stringValue) ?? URL(string:"https://cdn.travie.com/news/photo/202108/21951_11971_5847.jpg"))
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                        .cornerRadius(15)
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
                                    Text(commentVm.sortedRecentRecomment[index].fields.nickName.stringValue)
                                        .font(.caption)
                                        .fontWeight(.bold)
                                }
                                HStack{
                                    Text("・")
                                        .font(.caption2)
                                        .padding(.trailing, -5)
                                    // MARK: 댓글 생성 날짜
                                    Text(commentVm.sortedRecentRecomment[index].createTime.toDate()?.renderTime() ?? "")
                                        .font(.caption2)
                                }
                                Spacer()
                            
                            }
                            .padding(.bottom, -5)
                            
                            //MARK: - 댓글 내용
                            Text(commentVm.sortedRecentRecomment[index].fields.comment.stringValue)
                                .font(.caption)
                                .padding(.bottom, -1)
                            
                            // MARK: - 자기가 쓴 댓글일시 보여주는 수정/삭제
                            HStack{
                                if commentVm.sortedRecentRecomment[index].fields.userID.stringValue == Auth.auth().currentUser?.uid{
                                    Button {
                                        commentVm.updateRecomment(collectionName: collectionName, collectionDocId: collectionDocId, commentCollectionName: "Comment", commentCollectionDocId: commentCollectionDocId, docID: commentVm.sortedRecentRecomment[index].fields.id.stringValue, updateComment: commentText, data: commentVm.sortedRecentRecomment[index].fields)
                                        
                                        commentVm.fetchRecomment(collectionName: collectionName, collectionDocId: collectionDocId, commentCollectionName: "Comment", commentCollectionDocId: commentCollectionDocId)
                                        commentText = ""
                                    } label: {
                                        Text("수정")
                                    }
                                    Button {
                                        commentVm.deleteRecomment(collectionName: collectionName, collectionDocId: collectionDocId, commentCollectionName: "Comment", commentCollectionDocId: commentCollectionDocId, docID: commentVm.sortedRecentRecomment[index].fields.id.stringValue)
                                    } label: {
                                        Text("삭제")
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
        }
        .padding(.leading , -8)
        .onAppear{
            commentVm.fetchRecomment(collectionName: collectionName, collectionDocId: collectionDocId, commentCollectionName: "Comment", commentCollectionDocId: commentCollectionDocId)
        }
    }
}
