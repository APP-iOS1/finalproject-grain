//
//  CommunityDetailView.swift
//  Grain
//
//  Created by 박희경 on 2023/01/18.
//

import SwiftUI
import UIKit

// image -> systemName image로 임시 처리
struct CommunityDetailView: View {
    let community: CommunityDocument
    @AppStorage("docID") private var docID : String?
    @StateObject var communityVM = CommunityViewModel()
    @StateObject var userVM = UserViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    @State private var isBookMarked: Bool = false
    @State private var isliked: Bool = false
    @State private var comment: String = ""
    @State private var isHiddenComment: Bool = true
    @FocusState private var textFieldFocused: Bool
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading){
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("커뮤니티")
                            }
                            .padding(.horizontal, 10)
                        })
                        .accentColor(.black)
                        
                    // MARK: 닉네임 헤더
                    HStack {
                        ProfileImage(imageName: "sampleImage", width: 40, height: 40)
                        VStack(alignment: .leading) {
                            Text(community.fields.nickName.stringValue)
                                .font(.title3)
                                .bold()
                            Text(community.createdDate?.renderTime() ?? "")
                                .font(.caption)
                        }
                        Spacer()
                    }
                    .padding()
                    .padding(.top, -15)
                    Divider()
                        .frame(maxWidth: Screen.maxWidth * 0.92)
                        .background(Color.black)
                        .padding(.top, -5)
                        .padding(.bottom, -10)
                        .padding(.leading, Screen.maxWidth * 0.04)
                    
                    //MARK: 사진
                    TabView {
                        //FIXME: 고치기
                        Image("sampleImage")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: Screen.maxWidth, height: Screen.maxHeight * 0.3)
                    } //이미지 뷰
                    .tabViewStyle(.page)
                    .frame(height: Screen.maxHeight * 0.27)
                    .padding()
                    HStack {
                        //MARK: 좋아요 버튼
                        Button{
                            isliked.toggle()
                        } label: {
                            Image(systemName: isliked ? "heart.fill" : "heart" )
                                .foregroundColor(.red)
                                .font(.title2)
                        }
                        //Text("50")
                        Button {
                            //댓글 입력 키보드 팝업
                            isHiddenComment.toggle()
                            textFieldFocused = true
                        } label: {
                            Image(systemName: "message")
                                .font(.title3)
                                .foregroundColor(.black)
                        }
                        
                        //MARK: 북마크 버튼
                        Button {
                            isBookMarked.toggle()
                        } label: {
                            Image(systemName: isBookMarked ? "bookmark.fill" : "bookmark")
                                .font(.title2)
                                .foregroundColor(.black)
                        }
                        
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 1)
                    //                    //MARK: 게시글(디테일뷰) 제목
                    // MARK: 스티키 헤더 제목과 건텐츠
                    LazyVStack(pinnedViews: [.sectionHeaders]) {
                        Section(header: CommunityDetailHeader(community: community) ){
                            VStack {
                                Text(community.fields.content.stringValue)
                                    .lineSpacing(4.0)
                                    .padding(.vertical, -9)
                                    .padding()
                                //                                    .foregroundColor(Color.textGray)
                            }
                        }
                    }
                    //FIXME: 고치기
                    CommentView(comment: Comment(id: "ddd", userID: "ddd", profileImage: "1", nickName: "악!", comment: "가나다라마바사아자차카타파하거너더러머버서어저처커터처허 가나다라마바사아자차카타파하아라", createdAt: Date()))
                        .padding(.horizontal, 10)

                    // top vstack
                }
            } //scroll view
            .padding(.top, 1)
            
            //MARK: 댓글입력 창
            if !isHiddenComment {
                HStack {
                    TextField("댓글을 입력해주세요", text: $comment)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .padding()
                        .focused($textFieldFocused)
                        .onSubmit {
                            self.hideKeyboard()
                            isHiddenComment = true
                            comment = ""
                        }
                    Spacer()
                    Button {
                        // 댓글추가 동작 함수
                        self.hideKeyboard()
                        isHiddenComment = true
                        comment = ""
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
        .onAppear{
            userVM.fetchCurrentUser(userID: docID ?? "")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){

                // 유저가 좋아요를 눌렀는지
//                if userVM.likedMagazineIdArr.contains(where: { item in
//                    item == community.fields.id?.stringValue})
//                {
//                    isliked = true
//                }else{
//                    isliked = false
//                }
                
                // 유저가 저장을 눌렀는지
                if userVM.userBookmarkedCommunity.contains(where: { item in
                    item == community.fields.id.stringValue})
                {
                    print(isBookMarked)
                    isBookMarked = true
                }else{
                    isBookMarked = false
                }
            }
            
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
                if isBookMarked {
                    await userVM.updateUserUsingSDK(updateDocument: docID ?? "", updateKey: "bookmarkedMagazineID", updateValue: community.fields.id.stringValue, isArray: true)
                }else{
                    await userVM.deleteUserUsingSDK(updateDocument: docID ?? "", deleteKey: "bookmarkedMagazineID", deleteIndex: community.fields.id.stringValue, isArray: true)
                }
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onTapGesture {
            self.hideKeyboard()
            isHiddenComment = true
            comment = ""
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

struct CommunityDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityDetailView(community: CommunityDocument(name: "승수", fields: CommunityFields(title: CommunityCategory(stringValue: "임시 제목"), category: CommunityCategory(stringValue: "클래스"), content: CommunityCategory(stringValue: "가나다라마바사아자차카타파하갸냐댜랴먀뱌샤야쟈챠캬탸퍄햐 거너더러머버서어저처커터퍼허 겨녀뎌려며벼셔여져쳐켜텨벼혀"), profileImage: CommunityCategory(stringValue: "test"), nickName: CommunityCategory(stringValue: "seungsoo"), image: CommunityImage(arrayValue: CommunityArrayValue(values: [CommunityCategory(stringValue: "abc")])), userID: CommunityCategory(stringValue: "클래스"), id: CommunityCategory(stringValue: "han")), createTime: "2023-02-03", updateTime: "지금"))
    }
}
