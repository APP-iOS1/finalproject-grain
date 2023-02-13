//
//  CommunityDetailView.swift
//  Grain
//
//  Created by 박희경 on 2023/01/18.
//

import SwiftUI
import UIKit
import FirebaseAuth
import Kingfisher

// image -> systemName image로 임시 처리
struct CommunityDetailView: View {
    let community: CommunityDocument
    
    @StateObject var communityVM = CommunityViewModel()
    @StateObject var userVM = UserViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    // 댓글 관련
    @StateObject var commentVm = CommentViewModel()
    
    @State private var isBookMarked: Bool = false
    @State private var isliked: Bool = false
    @State private var commentText: String = ""
    @State private var isHiddenComment: Bool = true
    
    @FocusState private var textFieldFocused: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(alignment: .leading){
                        // MARK: 닉네임 헤더
                        HStack {
                            ProfileImage(imageName: community.fields.profileImage.stringValue)
                            VStack(alignment: .leading) {
                                Text(community.fields.nickName.stringValue)
                                    .font(.title3)
                                    .bold()
                                // FIXME: - 아래 코드가 고장 난거 같아 이 코드 적용했더니 되는 거 같음
                                Text(community.createTime.toDate()?.renderTime() ?? "")
                                    .font(.caption)
                                //MARK: 옵셔널 처리 고민
//                                Text(community.createdDate?.renderTime() ?? "")
//                                    .font(.caption)
                            }
                            Spacer()
                        }//HS
                        .padding(.vertical, 5)
                        Divider()
                            .frame(maxWidth: Screen.maxWidth * 0.92)
                            .background(Color.black)
                            .padding(.top, -5)
                            .padding(.bottom, -10)
                            .padding(.leading, Screen.maxWidth * 0.04)
//                        TabView{
//                            ForEach(community.fields.image.arrayValue.values, id: \.self) { item in
//                                KFImage(URL(string: item.stringValue) ?? URL(string:"https://cdn.travie.com/news/photo/202108/21951_11971_5847.jpg"))
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fill)
//                                    .frame(width: Screen.maxWidth, height: Screen.maxHeight * 0.3)
//                            }
//                        }
                        //MARK: 사진
                        TabView{
                            ForEach(community.fields.image.arrayValue.values, id: \.self) { item in
                                KFImage(URL(string: item.stringValue) ?? URL(string:"https://cdn.travie.com/news/photo/202108/21951_11971_5847.jpg"))
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: Screen.maxWidth, height: Screen.maxHeight * 0.3)
                     
                            }
                        } //이미지 뷰
                        .tabViewStyle(.page)
                        .frame(height: Screen.maxHeight * 0.27)
                        .padding()
                        .padding(.top, -10)
                        
                        //MARK: 댓글
                        Button {
                            //댓글 입력 키보드 팝업
                            isHiddenComment.toggle()
                            textFieldFocused = true
                        } label: {
                            Image(systemName: "message")
                                .font(.title3)
                                .foregroundColor(.black)
                        }
                        .padding(.leading, Screen.maxWidth * 0.04)
                        .padding(.top, -10)
                        // MARK: 게시글(디테일뷰) 제목
                        // MARK: 스티키 헤더 제목과 건텐츠
                        LazyVStack(pinnedViews: [.sectionHeaders]) {
                            Section(header: CommunityDetailHeader(community: community) ){
                                HStack {
                                    Text(community.fields.content.stringValue)
                                        .lineSpacing(4.0)
                                        .padding(.vertical, -20)
                                        .padding()
                                    Spacer()
                                }
                            }
                        }
                        .padding(.top, 10)
                        Divider()
                        // MARK: - 커뮤니티 댓글 뷰
                        VStack{
                            ForEach(commentVm.comment,id: \.self){ item in
                                // FIXME: Comment 어디서 만든건지 찾아야함
                                CommentView(comment: item.fields, commentText: commentText,collectionDocId: community.fields.id.stringValue)
                            }
                            
                        }.padding(.vertical)
                        
                        // top vstack
                    }
                } //scroll view
                .padding(.top, 1)
                
                //MARK: 댓글입력 창
                if !isHiddenComment {
                    HStack {
                        TextField("댓글을 입력해주세요", text: $commentText)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .padding()
                            .focused($textFieldFocused)
                            .onSubmit {
                                self.hideKeyboard()
                                isHiddenComment = true
                                commentText = ""
                            }
                        Spacer()
                        Button {
                            // MARK: 댓글 업로드 긴 ㅇ
                            commentVm.insertComment(collectionName: "Community", collectionDocId: community.fields.id.stringValue, data: CommentFields(comment: CommentString(stringValue: commentText), profileImage: CommentString(stringValue: community.fields.profileImage.stringValue), nickName: CommentString(stringValue: community.fields.nickName.stringValue), userID: CommentString(stringValue: Auth.auth().currentUser?.uid ?? ""), id: CommentString(stringValue: UUID().uuidString)))
                            self.hideKeyboard()
                            isHiddenComment = true
                            commentText = ""
                        } label: {
                            Image(systemName: "paperplane")
                                .foregroundColor(.blue)
                                .font(.title3)
                                .padding()
                        }
                    }
                }
                //.isHidden(isHiddenComment)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("커뮤니티")
                        }
                    })
                    .accentColor(.black)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    // MARK: 현재 유저 Uid 값과 magazineDB userId가 같으면 수정 삭제 보여주기
                    if community.fields.userID.stringValue == Auth.auth().currentUser?.uid{
                    Menu {
                        Button {
                            //저장시 코드
                        } label: {
                            Text("저장")
                        }
                        NavigationLink {
                            CommunityEditView(community: community)
                        }label: {
                            Text("수정")
                        }
                        Button {
                            communityVM.deleteCommunity(docID: community.fields.id.stringValue)
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("삭제")
                        }
                        
                    } label: {
                        Label("더보기", systemImage: "ellipsis")
                        
                    }
                    .accentColor(.black)
                    .padding(.trailing, Screen.maxWidth * 0.04)
                    } else {
                        Menu {
                            Button {
                             //저장시 코드
                            } label: {
                                Text("저장")
                            }
                        } label: {
                            Label("더보기", systemImage: "ellipsis")
                        }
                        .accentColor(.black)
                        .padding(.trailing, Screen.maxWidth * 0.04)
                    }
                }
            }
        }
        .onAppear{
            userVM.fetchCurrentUser(userID: Auth.auth().currentUser?.uid ?? "")
            commentVm.fetchComment(collectionName: "Community",
                                   collectionDocId: community.fields.id.stringValue)
            //            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            // 유저가 좋아요를 눌렀는지
            //                if userVM.likedMagazineIdArr.contains(where: { item in
            //                    item == community.fields.id?.stringValue})
            //                {
            //                    isliked = true
            //                }else{
            //                    isliked = false
            //                }
            
            // 유저가 저장을 눌렀는지
            //                if userVM.userBookmarkedCommunity.contains(where: { item in
            //                    item == community.fields.id.stringValue})
            //                {
            //                    print(isBookMarked)
            //                    isBookMarked = true
            //                }else{
            //                    isBookMarked = false
            //                }
            //            }
            
        }
        .onDisappear{
            Task{
                
                //                if isliked {
                //                    /// 추가 부분
                //                    await userVM.updateUserUsingSDK(updateDocument: docID ?? "", updateKey: "bookmarkedCommunityID", updateValue: community.fields.id?.stringValue ?? "", isArray: true)
                //                }else{
                //                    /// 삭제부분
                //                    await userVM.deleteUserSDK(updateDocument: docID ?? "", deleteKey: "bookmarkedCommunityID", deleteIndex: community.fields.id?.stringValue ?? "", isArray: true)
                //                }
                
                //                 유저 DB에 북마크 상태 저장/삭제
                //                if isBookMarked {
                //                    await userVM.updateUserUsingSDK(updateDocument: Auth.auth().currentUser?.uid ?? "", updateKey: "bookmarkedMagazineID", updateValue: community.fields.id.stringValue, isArray: true)
                //                }else{
                //                    await userVM.deleteUserUsingSDK(updateDocument: Auth.auth().currentUser?.uid ?? "", deleteKey: "bookmarkedMagazineID", deleteIndex: community.fields.id.stringValue, isArray: true)
                //                }
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onTapGesture {
            self.hideKeyboard()
            isHiddenComment = true
            commentText = ""
        }
    }
}

struct CommunityDetailHeader: View {
    let community: CommunityDocument
    var body: some View {
        HStack {
            Text(community.fields.title.stringValue)
                .font(.title2)
                .bold()
                .padding(.horizontal)
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .frame(height: 40)
        .background(Rectangle().foregroundColor(.white))
    }
}

//struct CommunityDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommunityDetailView(community: CommunityDocument(name: "승수", fields: CommunityFields(title: CommunityCategory(stringValue: "임시 제목"), category: CommunityCategory(stringValue: "클래스"), content: CommunityCategory(stringValue: "가나다라마바사아자차카타파하갸냐댜랴먀뱌샤야쟈챠캬탸퍄햐 거너더러머버서어저처커터퍼허 겨녀뎌려며벼셔여져쳐켜텨벼혀"), profileImage: CommunityCategory(stringValue: "test"), nickName: CommunityCategory(stringValue: "seungsoo"), image: CommunityImage(arrayValue: CommunityArrayValue(values: [CommunityCategory(stringValue: "abc")])), userID: CommunityCategory(stringValue: "클래스"), id: CommunityCategory(stringValue: "han")), createTime: "2023-02-03", updateTime: "지금"))
//    }
//}
