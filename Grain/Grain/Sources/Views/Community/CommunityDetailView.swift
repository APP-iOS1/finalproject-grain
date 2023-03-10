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
    @State var community: CommunityDocument
    
    @StateObject var communityVM = CommunityViewModel()
    @StateObject var userVM = UserViewModel()
    
    @Environment(\.presentationMode) var presentationMode
    
    // 댓글 관련
    @StateObject var commentVm = CommentViewModel()
    
    @State private var isBookMarked: Bool = false
    @State private var isliked: Bool = false
    @State private var commentText: String = ""
    @State private var isHiddenComment: Bool = true
    @State private var editFetch: Bool = false
    
    @State private var postStatus : String = "" // 게시글 상태 값
    @State private var postStatusString : String = "" // 게시글 상태 변경 표시글
    @FocusState private var textFieldFocused: Bool
    
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(alignment: .leading){
                        HStack{
                            Text(community.fields.title.stringValue)
                                .font(.title2)
                                .bold()
                                .padding(.horizontal)
                                .padding(.top, 5)
                            Spacer()
                        }
                        .padding(.top, 5)
                        // MARK: 닉네임 헤더
                        HStack {
                            // item = userData
                            NavigationLink {
                                if let user = userVM.users.first(where: { $0.fields.id.stringValue == community.fields.userID.stringValue
                                }) {
                                    UserDetailView(user: user, userVM: userVM)
                                }
                            } label: {
                                ProfileImage(imageName: community.fields.profileImage.stringValue)
                            }
                            
                            VStack(alignment: .leading) {
                                Text(community.fields.nickName.stringValue)
                                    .font(.subheadline)
                                //MARK: 옵셔널 처리 고민
                                Text(community.createTime.toDate()?.renderTime() ?? "")
                                    .font(.caption)
                            }
                            Spacer()
                        }//HS
                        //.padding(.vertical, 5)
                        Divider()
                            .frame(maxWidth: Screen.maxWidth * 0.94)
                            .background(Color.black)
                            .padding(.top, 5)
                            .padding(.bottom, 15)
                            .padding(.horizontal, Screen.maxWidth * 0.04)
                                                
                        //MARK: 사진
                        TabView{
                            ForEach(community.fields.image.arrayValue.values, id: \.self) { item in
                                Rectangle()
                                    .frame(width: Screen.maxWidth , height: Screen.maxWidth)
                                    .overlay{
                                        KFImage(URL(string: item.stringValue) ?? URL(string:"https://cdn.travie.com/news/photo/202108/21951_11971_5847.jpg"))
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                    }
                            }
                        } //이미지 뷰
                        .tabViewStyle(.page)
                        .frame(width: Screen.maxWidth , height: Screen.maxWidth)
                        .padding(.bottom, 10)
   
                        // MARK: 게시글(디테일뷰) 내용
                                HStack {
                                    Text(community.fields.content.stringValue)
                                        .lineSpacing(4.0)
                                        .padding(.vertical, -20)
                                        .padding()
                                    Spacer()
                                }
                        .padding(.top, 10)
                        Divider()
                            .frame(maxWidth: Screen.maxWidth * 0.94)
                            .background(Color.black)
                            .padding(.top, 5)
                            .padding(.bottom, 15)
                            .padding(.horizontal, Screen.maxWidth * 0.04)
                        // MARK: - 커뮤니티 댓글 뷰
                        VStack(alignment: .leading ){
                            ForEach(commentVm.sortedRecentComment ,id: \.self){ item in
                                // FIXME: Comment 어디서 만든건지 찾아야함
                                CommentView(comment: item.fields, commentTime: item.updateTime, commentText: commentText, collectionDocId: community.fields.id.stringValue)
                                Divider()
                            }
                        }
                    }
                }
                .refreshable {
                    communityVM.fetchCommunity()
                    commentVm.fetchComment(collectionName: "Community", collectionDocId: community.fields.id.stringValue)
                }
                .padding(.top, 1)
                // MARK: 댓글 달기
                CommunityCommentView(currentUser: userVM.currentUsers,community: community)
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
                        if !(postStatus == ""){
                            Button{
                                community.fields.state.stringValue = postStatus
                                communityVM.updateCommunity(data: community, docID: community.fields.id.stringValue)
                            }label: {
                                Text(postStatusString)
                            }
                        }
                        Button {
                            //저장시 코드
                        } label: {
                            Text("저장")
                        }
                        NavigationLink {
                            CommunityEditView(communityVM: communityVM, community: community, editFetch: $editFetch)
                        }label: {
                            Text("수정")
                        }
                        .onChange(of: editFetch) { _ in
                            communityVM.fetchCommunity()
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
                    .onAppear{
                        switch community.fields.state.stringValue{
                        case "모집중":
                            postStatusString = "모집완료 으로 변경"
                            postStatus = "모집완료"
                        case "판매중":
                            postStatusString = "판매완료 으로 변경"
                            postStatus = "판매완료"
                        case "모집완료":
                            postStatusString = "모집중 으로 변경"
                            postStatus = "모집중"
                        case "판매완료":
                            postStatusString = "판매중 으로 변경"
                            postStatus = "판매중"
                        default:
                            postStatus = ""
                        }
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
            userVM.fetchUser()
            commentVm.fetchComment(collectionName: "Community",
                                   collectionDocId: community.fields.id.stringValue)
            communityVM.fetchCommunity()
            
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
        .onChange(of: commentVm.comment, perform: { value in
            commentVm.fetchComment(collectionName: "Community",
                                   collectionDocId: community.fields.id.stringValue)
            print("실행?")
        })
                  
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
