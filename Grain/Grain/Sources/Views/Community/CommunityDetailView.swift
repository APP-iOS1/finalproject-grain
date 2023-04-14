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
    
    @StateObject var commentVm = CommentViewModel()
    
    @ObservedObject var communityVM : CommunityViewModel
    @ObservedObject var userVM : UserViewModel
    @ObservedObject var magazineVM : MagazineViewModel
    
    var community: CommunityDocument
    @State var communityData: CommunityDocument?
    
    @State private var isBookMarked: Bool = false
    @State private var isliked: Bool = false
    @State private var commentText: String = ""
    @State private var isHiddenComment: Bool = true
    @State private var editFetch: Bool = false
    @State private var postStatus : String = "" // 게시글 상태 값
    @State private var postStatusString : String = "" // 게시글 상태 변경 표시글
    @State var commentCollectionDocId: String = ""
    @State var replyCommentText : String = "" // 답글 표시 이름 값
    @State var replyContent: String = ""
    @State var replyComment : Bool = false  // 답글 표시 Bool값
    
    @State var editComment : Bool = false
    @State var editDocID : String = ""
    @State var editData : CommentFields = CommentFields(comment: CommentString(stringValue: ""), profileImage: CommentString(stringValue: ""), nickName: CommentString(stringValue: ""), userID: CommentString(stringValue: ""), id: CommentString(stringValue: ""))
    @State var editRecomment : Bool = false
    @State var editReDocID : String = ""
    @State var editReData : CommentFields = CommentFields(comment: CommentString(stringValue: ""), profileImage: CommentString(stringValue: ""), nickName: CommentString(stringValue: ""), userID: CommentString(stringValue: ""), id: CommentString(stringValue: ""))
    @State var commentCount : Int = 0
    @State var editReColletionDocID: String = ""
    @State var reommentUserID : String = ""
    @State private var isDeleteAlertShown:Bool = false
    @State private var deleteDocId: String = ""
    @State private var deleteCommentAlertBool: Bool = false
    @State private var isCommentDelete: Bool = false
    @State private var scrollViewOffset: CGFloat = 0
    @State private var startOffset: CGFloat = 0
    @State private var scrollToBottom: Bool = false
    @State private var isReportAlertShown: Bool = false
    
    @FocusState private var textFieldFocused: Bool
    
    @Environment(\.presentationMode) var presentationMode
    
    @SceneStorage("isZooming") var isZooming: Bool = false
    @SceneStorage("index") var selectedIndex: Int = 0
    
    func errorImage() -> String{
        var https : String = "https://"
        if let infolist = Bundle.main.infoDictionary {
            if let url = infolist["DetailImageError"] as? String {
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
        VStack {
            ScrollViewReader { proxyReader in
                ScrollView {
                    VStack{
                        VStack(alignment: .leading){
                            HStack{
                                if let community = self.communityData {
                                    Text(community.fields.title.stringValue)
                                        .font(.title2)
                                        .bold()
                                        .padding(.horizontal)
                                        .padding(.top, 5)
                                }
                                Spacer()
                            }
                            .padding(.top, 5)
                            .alert(isPresented: $isDeleteAlertShown) {
                                Alert(title: Text("게시물을 삭제하시겠어요?"),
                                      message: Text("게시물을 삭제하면 영구히 삭제되고 복원할 수 없습니다."),
                                      primaryButton:  .cancel(Text("취소")),
                                      secondaryButton:.destructive(Text("삭제"),
                                                                   action: {
                                    if let communityData = self.communityData {
                                        communityVM.deleteCommunity(docID: communityData.fields.id.stringValue)
                                        var postCommunitArr : [String]  = userVM.postedCommunityID
                                        postCommunitArr.removeAll { $0 == communityData.fields.id.stringValue }
                                        userVM.updateCurrentUserArray(type: "postedCommunityID", arr: postCommunitArr, docID: Auth.auth().currentUser?.uid ?? "")
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                            communityVM.fetchCommunity(nextPageToken: "")
                                                    }
                                        presentationMode.wrappedValue.dismiss()
                                    }
                                }))
                            }
                          
                            Divider()
                                .alert(isPresented: $deleteCommentAlertBool) {
                                    Alert(title: Text("댓글을 삭제하시겠어요?"),
                                          primaryButton:  .cancel(Text("취소")),
                                          secondaryButton:.destructive(Text("삭제"),action: {
                                        self.isCommentDelete.toggle()
                                        self.replyComment = false
                                        self.editComment = false
                                        self.editRecomment = false
                                        
                                    }))
                                }
                             
                            // MARK: 닉네임 헤더
                            HStack {
                                if let user = userVM.users.first(where: { $0.fields.id.stringValue == community.fields.userID.stringValue}){
                                    NavigationLink {
                                        UserDetailView(userVM: userVM, magazineVM: magazineVM, user: user)
                                    } label: {
                                        ProfileImage(imageName: user.fields.profileImage.stringValue)
                                            .padding(.leading, 9)
                                    }
                                    
                                    VStack(alignment: .leading) {
                                        Text(user.fields.nickName.stringValue)
                                            .font(.callout)
                                            .bold()
                                            .padding(.bottom, -3)
                                        //MARK: 옵셔널 처리 고민
                                        Text(community.createTime.toDate()?.renderTime() ?? "")
                                            .font(.caption2)
                                            .foregroundColor(.textGray)
                                    }.padding(.leading, -2)
                                }
                                Spacer()
                            }//HS
                            .padding([.top, .bottom], 2)
                            .alert(isPresented: $commentVm.isDeleteReCommentAlertshown) {
                                Alert(title: Text("댓글을 삭제하시겠어요?"),
                                      primaryButton:  .cancel(Text("취소")),
                                      secondaryButton:.destructive(Text("삭제"),action: {
                                    self.commentVm.isDeleteReComment.toggle()
                                    self.replyComment = false
                                    self.editComment = false
                                    self.editRecomment = false
                                }))
                            }
                      
                            // MARK: 사진
                            ForEach(Array(community.fields.image.arrayValue.values.enumerated()), id: \.1.self) { (index, item) in
                                Rectangle()
                                    .frame(width: Screen.maxWidth, height: Screen.maxWidth)
                                    .overlay {
                                        KFImage(URL(string: item.stringValue) ?? URL(string:  errorImage()))
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                    }
                                    .tag(index)
                            }
                            .addPinchZoom()
                            .frame(width: Screen.maxWidth , height: Screen.maxWidth)
                            .padding(.bottom, 10)
                            .zIndex(.infinity)
                            
                            // MARK: 게시글(디테일뷰) 내용
                            HStack {
                                if let community = self.communityData {
                                    Text(community.fields.content.stringValue)
                                        .lineSpacing(4.0)
                                        .padding(.vertical, -20)
                                        .padding()
                                }
                                Spacer()
                            }
                            .padding(.top, 10)
                            Divider()

                                .sheet(isPresented: $isReportAlertShown) {
                                    ReportMainView()
                                }
                            
                            HStack {
                                Image(systemName: "bubble.right")
                                    .padding(.top, 2)
                                Text("\(commentCount)")
                                    .padding(.leading, -3)
                            }
                            .padding(.top, 20)
                            .padding(.leading)
                            .font(.callout)
                            .foregroundColor(.gray)
                            
                            Divider()
                            
                            // MARK: - 커뮤니티 댓글 뷰
                            
                            CommentView(commentVm: commentVm, userVM: userVM, magazineVM: magazineVM, collectionName: infolistCommunityString(), collectionDocId: community.fields.id.stringValue, commentCollectionDocId: $commentCollectionDocId, replyCommentText: $replyCommentText, replyContent: $replyContent, replyComment: $replyComment, editComment: $editComment, editDocID: $editDocID, editData: $editData , editRecomment: $editRecomment ,editReDocID: $editReDocID , editReData : $editReData ,commentCount : $commentCount, editReColletionDocID: $editReColletionDocID, reommentUserID: $reommentUserID , isCommentDelete: $isCommentDelete, deleteCommentAlertBool: $deleteCommentAlertBool)
                                .padding(.top, 1)
                                .padding(.trailing, 20)
                            
                        }
                    }
                    .id("SCROLL_TO_BOTTOM")
              
                }
                .refreshable {
                    do {
                        try await Task.sleep(nanoseconds: UInt64(1.6) * 1_000_000_000)
                      } catch {}
                    magazineVM.fetchMagazine(nextPageToken: "")
                }
                .onChange(of: scrollToBottom, perform: { newValue in
                    withAnimation(.default) {
                        proxyReader.scrollTo("SCROLL_TO_BOTTOM", anchor: .bottom)
                    }
                })
                .onDisappear{
                    selectedIndex = 0
                }
                .padding(.top, 1)
                // MARK: 댓글 달기
                if isZooming == false {
                    CommunityCommentView(commentVm: commentVm, userVM : userVM ,community: community, commentCollectionDocId: $commentCollectionDocId, replyCommentText: $replyCommentText, replyContent: $replyContent, replyComment: $replyComment, editComment: $editComment, editDocID: $editDocID, editData: $editData , editRecomment: $editRecomment, editReDocID: $editReDocID, editReData: $editReData, editReColletionDocID: $editReColletionDocID, reommentUserID: $reommentUserID, communityData: $communityData, scrollToBottom: $scrollToBottom)
                        .transition(.move(edge: .bottom))
                        .animation(.default , value: isZooming)
                }
            }
        }
        .onAppear {
            self.communityData = self.community
        }
        .task(id: communityVM.sortedRecentCommunityData, {
            if let communityData = communityVM.sortedRecentCommunityData.first(where: { $0.fields.id.stringValue == self.community.fields.id.stringValue
            }) {
                self.communityData = communityData
            }
        })
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
                                communityData?.fields.state.stringValue = postStatus
                                communityVM.updateCommunity(data: communityData!, docID: community.fields.id.stringValue)
                            }label: {
                                Text(postStatusString)
                            }
                        }
                        
                        if !userVM.bookmarkedCommunityID.contains(community.fields.id.stringValue) {
                            Button {
                                userVM.bookmarkedCommunityID.append(community.fields.id.stringValue)
                                if let user = userVM.currentUsers {
                                    let arr = userVM.bookmarkedCommunityID
                                    let docID = user.id.stringValue
                                    userVM.updateCurrentUserArray(type: "bookmarkedCommunityID", arr: arr, docID: docID)
                                }
                            } label: {
                                HStack{
                                    Text("저장")
                                    Spacer()
                                    Image(systemName: "bookmark.fill")
                                }
                                
                            }
                        } else {
                            Button {
                                if let user = userVM.currentUsers {
                                    let index = userVM.bookmarkedCommunityID.firstIndex(of: community.fields.id.stringValue)
                                    userVM.bookmarkedCommunityID.remove(at: index!)
                                    let arr = userVM.bookmarkedCommunityID
                                    let docID = user.id.stringValue
                                    userVM.updateCurrentUserArray(type: "bookmarkedCommunityID", arr: arr, docID: docID)
                                }
                            } label: {
                                HStack{
                                    Text("저장취소")
                                    Spacer()
                                    Image(systemName: "bookmark.slash.fill" )
                                }
                            }
                        }
                        NavigationLink {
                            CommunityEditView(userVM: userVM, community: $communityData, communityVM: communityVM, editFetch: $editFetch)
                        }label: {
                            Text("수정")
                            Spacer()
                            Image(systemName: "square.and.pencil")
                        }
                        Button {
                            self.isDeleteAlertShown.toggle()
                            
                        } label: {
                            Text("삭제")
                            Spacer()
                            Image(systemName: "trash")
                        }
                        
                        
                    } label: {
                        Label("더보기", systemImage: "ellipsis")
                        
                    }
                    .onAppear{
                        switch community.fields.state.stringValue{
                        case "모집중":
                            postStatusString = "모집완료 (으)로 변경"
                            postStatus = "모집완료"
                        case "판매중":
                            postStatusString = "판매완료 (으)로 변경"
                            postStatus = "판매완료"
                        case "모집완료":
                            postStatusString = "모집중 (으)로 변경"
                            postStatus = "모집중"
                        case "판매완료":
                            postStatusString = "판매중 (으)로 변경"
                            postStatus = "판매중"
                        default:
                            postStatus = ""
                        }
                        selectedIndex = 0
                    }
                    .accentColor(.black)
//                    .padding(.trailing, Screen.maxWidth * 0.04)
                } else {
                    Menu {
                        if !userVM.bookmarkedCommunityID.contains(community.fields.id.stringValue) {
                            Button {
                                userVM.bookmarkedCommunityID.append(community.fields.id.stringValue)
                                if let user = userVM.currentUsers {
                                    let arr = userVM.bookmarkedCommunityID
                                    let docID = user.id.stringValue
                                    userVM.updateCurrentUserArray(type: "bookmarkedCommunityID", arr: arr, docID: docID)
                                }
                            } label: {
                                HStack{
                                    Text("저장")
                                    Spacer()
                                    Image(systemName: "bookmark.fill")
                                }
                            }
                        } else {
                            Button {
                                if let user = userVM.currentUsers {
                                    let index = userVM.bookmarkedCommunityID.firstIndex(of: community.fields.id.stringValue)
                                    userVM.bookmarkedCommunityID.remove(at: index!)
                                    let arr = userVM.bookmarkedCommunityID
                                    let docID = user.id.stringValue
                                    userVM.updateCurrentUserArray(type: "bookmarkedCommunityID", arr: arr, docID: docID)
                                }
                            } label: {
                                HStack{
                                    Text("저장취소")
                                    Spacer()
                                    Image(systemName: "bookmark.slash.fill" )
                                }
                            }
                        }
                        if community.fields.userID.stringValue != Auth.auth().currentUser?.uid{
                            Button(role: .destructive, action: { self.isReportAlertShown.toggle()}) {
                                   Label("신고", systemImage: "exclamationmark.bubble")
                               }

                        }

                    } label: {
                        Label("더보기", systemImage: "ellipsis")
                    }
                    .accentColor(.black)
                }
            }
        }
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
