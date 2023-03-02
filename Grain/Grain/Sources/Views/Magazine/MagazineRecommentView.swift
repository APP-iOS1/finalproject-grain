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
    
    var currentUser : CurrentUserFields?  //현재 유저 받아오기
    
    @StateObject var commentVm = CommentViewModel() //댓글 뷰 모델 사용
    
    var commentCollectionDocId : String
    var collectionName : String     // 경로 받아오기 최초 컬렉션 받아오기 ex) Magazine
    var collectionDocId : String    // 경로 받아오기 최초 컬렌션 하위 문서ID 받아오기 ex) Magazine - 4ADB415C-871A-4FAF-86EA-D279D145CD37
    
    @Binding var eachBoolArray : [Bool]
    
    var body: some View {
        
        VStack(alignment: .leading){
            // TODO: 댓글 셀뷰 따로 만들기
            if commentVm.sortedRecentRecomment.count < 1 {
                
            }else{
                ForEach(commentVm.sortedRecentRecomment.indices, id: \.self){ index in
                    
                    // FIXME: 댓글 하나 셀로 만들기
                    Divider()
                    HStack(alignment: .top){
                        // MARK: -  유저 프로필 이미지
                        VStack{
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
                        VStack(alignment: .leading){
                            HStack{
                                NavigationLink {
                                    //유저 프로필 뷰 입장
                                } label: {
                                    // MARK: 유저 닉네임
                                    Text(commentVm.sortedRecentRecomment[index].fields.nickName.stringValue)
                                        .font(.footnote)
                                        .fontWeight(.bold)
                                }
                                HStack{
                                    Text("・")
                                        .padding(.trailing, -5)
                                    // MARK: 댓글 생성 날짜
                                    Text(commentVm.sortedRecentRecomment[index].createTime.toDate()?.renderTime() ?? "")
                                }
                                .font(.caption2)
                                Spacer()
                                //                                            // FIXME: 고쳐야함!
                                //                                           if item.fields.userID.stringValue == Auth.auth().currentUser?.uid{
                                
                            }
                            .padding(.bottom, -5)
                            //MARK: - 댓글 내용
                            Text(commentVm.sortedRecentRecomment[index].fields.comment.stringValue)
                                .font(.callout)
                            
                                .padding(.bottom, -1)
                            
                            // MARK: - 자기가 쓴 댓글일시 보여주는 수정/삭제
                            HStack{
                                Button {
                                    //수정 하기 버튼
                                } label: {
                                    //                                         item.fields.userID.stringValue == Auth.auth().currentUser?.uid{
                                    Text("수정")
                                }
                                Button {
                                } label: {
                                    Text("삭제")
                                }
                            }
                            .font(.caption)
                            .foregroundColor(.textGray)
                            .padding(.top, 1)
                            .padding(.bottom, -3)
                            
                            
                        }
                    }
                    .padding(.vertical, -7)
                }.padding(7)
            }
        }
        .onAppear{
            commentVm.fetchRecomment(collectionName: collectionName, collectionDocId: collectionDocId, commentCollectionName: "Comment", commentCollectionDocId: commentCollectionDocId)
        }
        .navigationTitle("댓글")
        .navigationBarTitleDisplayMode(.inline)
    }
}
