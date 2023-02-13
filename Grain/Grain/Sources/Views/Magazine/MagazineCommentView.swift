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
    
    var currentUser : CurrentUserFields?  //현재 유저 받아오기
    @State var commentText: String = "" // 댓글 작성 텍스트 필드
    @StateObject var commentVm = CommentViewModel() //댓글 뷰 모델 사용
    @State var editButtonShowing : Bool = false // 내가 쓴 댓글 수정/삭제 한번에 보여줄려고 만든 Bool
    var collectionName : String     // 경로 받아오기 최초 컬렉션 받아오기 ex) Magazine
    var collectionDocId : String    // 경로 받아오기 최초 컬렌션 하위 문서ID 받아오기 ex) Magazine - 4ADB415C-871A-4FAF-86EA-D279D145CD37
    var body: some View {
        VStack() {
            Divider()
            ScrollView() {
                // 댓글이 들어갈 자리
                VStack(alignment: .leading){
                    // TODO: 댓글 셀뷰 따로 만들기
                    ForEach(commentVm.comment, id: \.self){ item in
                        // FIXME: 댓글 하나 셀로 만들기
                        HStack{
                            // MARK: -  유저 프로필 이미지
                            VStack{
                                KFImage(URL(string: item.fields.profileImage.stringValue) ?? URL(string:"https://cdn.travie.com/news/photo/202108/21951_11971_5847.jpg"))
                                    .resizable()
                                    .frame(width: 35, height: 35)
                                    .cornerRadius(15)
                                    .overlay {
                                        Circle()
                                            .stroke(lineWidth: 0.5)
                                    }
                                    .padding(.leading)
                            }
                            VStack(alignment: .leading){
                                HStack{
                                    NavigationLink {
                                        //유저 프로필 뷰 입장
                                    } label: {
                                        // MARK: 유저 닉네임
                                        Text("@" + item.fields.nickName.stringValue)
                                            .font(.caption2)
                                            .fontWeight(.bold)
                                    }
                                    Text("-")
                                    // MARK: 댓글 생성 날짜
                                    Text(item.createdDate?.renderTime() ?? "")
                                        .font(.caption2)
                                        .fontWeight(.bold)
                                    Spacer()
                                    // MARK: - 자기가 쓴 댓글일시 보여주는 수정/삭제
                                        //  MARK: 수정
                                        Button {
                                            //수정 하기 버튼
                                            commentVm.updateComment(collectionName: collectionName, collectionDocId: collectionDocId, docID: item.fields.id.stringValue, updateComment: commentText,data: item.fields)
                                            commentText = ""
                                        } label: {
                                            // 이 부분 빼면 빌드 빨라지는거 같음
                                            // FIXME: 셀 단위면 좋아요, 구독 처럼 하나씩 판별해서 true, false 할수 있을거 같은데
                                            // FIXME: 고쳐야함!
//                                            if item.fields.userID.stringValue == Auth.auth().currentUser?.uid{
                                                Text("수정")
                                                    .font(.caption2)
                                                    .fontWeight(.bold)
                                                    .foregroundColor(.blue)
//                                            }
                                        }.padding(.trailing, 5)
                                        //  MARK: 삭제
                                        Button {
                                            commentVm.deleteComment(collectionName: collectionName, collectionDocId: collectionDocId, docID: item.fields.id.stringValue)
                                        } label: {
                                            // FIXME: 고쳐야함!
//                                            if item.fields.userID.stringValue == Auth.auth().currentUser?.uid{
                                                Text("삭제")
                                                    .font(.caption2)
                                                    .fontWeight(.bold)
                                                    .foregroundColor(.blue)
//                                            }
                                        }.padding(.trailing, 5)
                                }
                                //MARK: - 댓글 내용
                                Text(item.fields.comment.stringValue)
                                    .font(.system(size: 17))
                                    .fontWeight(.bold)
                            }
                            
                        }
                        Divider()
                    }.padding(7)
                }
                
            }
            // 댓글 구역
            HStack{
                //                 유저 프로필 이미지
                KFImage(URL(string: currentUser?.profileImage.stringValue ?? "") ?? URL(string:"https://cdn.travie.com/news/photo/202108/21951_11971_5847.jpg"))
                    .resizable()
                    .frame(width: 40, height: 40)
                    .cornerRadius(30)
                    .overlay {
                        Circle()
                            .stroke(lineWidth: 1)
                    }
                    .padding(.leading)
                MagazineCommentTextField(commentText: $commentText, currentUser: currentUser,collectionName: collectionName, collectionDocId: collectionDocId)
            }.onAppear{

            }
        }
        .onAppear{
            // 해당하는 매거진 댓글 정보 가져오기
            commentVm.fetchComment(collectionName: collectionName, collectionDocId: collectionDocId)
        }
        .navigationTitle("댓글")
        .navigationBarTitleDisplayMode(.inline)
    }
}
struct MagazineCommentTextField: View {
    @Binding var commentText: String
    @State var uploadButtonShowing : Bool = false
    var currentUser : CurrentUserFields?
    var collectionName : String
    var collectionDocId : String
    
    @StateObject var commentVm = CommentViewModel()
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 30)
                .stroke(Color.brightGray)
                .padding(7)
                .overlay{
                    TextField("댓글 달기...", text: $commentText)
                        .padding()
                    Spacer()
                    if uploadButtonShowing{
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
                            
                            uploadButtonShowing.toggle()
                            commentText = ""        //댓글 텍스트 필드 초기화
                        } label: {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }.offset(x: 130)
                    }
                    
                }
                .onTapGesture {
                    uploadButtonShowing.toggle()
                }
            
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .frame(height: 56)
        
    }
}

//struct MagazineCommentView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack {
//            MagazineCommentView()
//        }
//    }
//}




