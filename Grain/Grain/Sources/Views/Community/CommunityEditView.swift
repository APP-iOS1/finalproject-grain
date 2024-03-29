//
//  CommunityEditView.swift
//  Grain
//
//  Created by 윤소희 on 2023/02/13.
//

import SwiftUI
import FirebaseAuth
import Kingfisher

// 텍스트 필드 포커스를 위한 열거형
private enum FocusableField: Hashable {
    case title
    case content
}

struct CommunityEditView: View {
    @ObservedObject var userVM : UserViewModel
    @Binding var community: CommunityDocument?
    
    @State var editTitle : String = ""
    @State private var editContent : String = ""
    @State var clickedTitle : Bool = false
    @State var clickedContent : Bool = false
    @State private var showSuccessAlert: Bool = false
    @State private var showEmptyTitleAlert: Bool = false
    @State private var showEmptyContentAlert: Bool = false
    
    @FocusState private var focus: FocusableField?
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var communityVM: CommunityViewModel
    
    @Binding var editFetch: Bool
    
    func errorImage() -> String{
        var https : String = "https://"
        if let infolist = Bundle.main.infoDictionary {
            if let url = infolist["DetailImageError"] as? String {
                https += url
            }
        }
        return https
    }
    
    var body: some View {
        ScrollView(showsIndicators: false){
            VStack{
                VStack {
                    if let community = self.community {
                        VStack{
                            TextField(community.fields.title.stringValue, text: $editTitle)
                                .font(.title2)
                                .padding(.horizontal)
                                .padding(.vertical, 3)
                                .padding(.bottom, 3)
                                .bold()
                                .focused($focus, equals: .title)
                                .disableAutocorrection(true)
                                .autocapitalization(.none)
                        }.padding(.top, 5)
                        
                        Divider()
                        
                        HStack {
                        if let user = userVM.users.first(where: { $0.fields.id.stringValue == community.fields.userID.stringValue })
                        {
                            ProfileImage(imageName: user.fields.profileImage.stringValue)
                        }
                        
                        VStack(alignment: .leading) {
                            if let user = userVM.users.first(where: { $0.fields.id.stringValue == community.fields.userID.stringValue })
                            {
                                Text(user.fields.nickName.stringValue)
                                    .font(.callout)
                                    .bold()
                                    .padding(.bottom, -5)

                            }

                            //MARK: 옵셔널 처리 고민
                            Text(community.createTime.toDate()?.renderTime() ?? "")
                                .font(.caption2)
                                .foregroundColor(.textGray)
                        }
                        .padding(.leading, -2)
                            
                        Spacer()
                            
                        }//HS
                        .padding(.leading, 7)
                        .padding([.top, .bottom], 2)
                        
                        //                    Divider()
                        //                        .frame(maxWidth: Screen.maxWidth * 0.94)
//                        .background(Color.black)
//                        .padding(.top, 5)
                        
                        //MARK: 사진
                        TabView{
                            ForEach(community.fields.image.arrayValue.values, id: \.self) { item in
                                Rectangle()
                                    .frame(width: Screen.maxWidth , height: Screen.maxWidth)
                                    .overlay{
                                        KFImage(URL(string: item.stringValue) ?? URL(string: errorImage()))
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                    }
                            }
                        } //이미지 뷰
                        .tabViewStyle(.page)
                        .frame(width: Screen.maxWidth , height: Screen.maxWidth)
                        .padding(.bottom, 15)
                    }
                } //VStack
                
                HStack{
                    if let community = self.community {
                        TextEditor(text: $editContent)
                            .frame(height: 400)
                            .lineSpacing(4.0)
                            .padding([.leading, .trailing])
                    }
                } //HStack
                .padding(.top, 6)
            }
        }
        .onAppear {
            if let community = self.community {
                focus = .title
                editTitle = community.fields.title.stringValue
                editContent = community.fields.content.stringValue
            }
        }
        .padding(.top, 1)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if var data = self.community {
                    HStack{
                        if editTitle.isEmpty {
                            Button {
                                print("게시물의 타이틀이 비었습니다. ")
                                showEmptyTitleAlert.toggle()
                            } label: {
                                Text("확인")
                            }.alert(isPresented: $showEmptyTitleAlert) {
                                Alert(title: Text("게시물의 제목을 입력해주세요."),
                                      message: Text("게시물의 제목이 비어있습니다."),
                                      dismissButton: .destructive(
                                        Text("확인")
                                      ){})
                            }
                        } else if editContent.isEmpty {
                            Button {
                                print("editContent 이 비었습니다 ")
                                showEmptyContentAlert.toggle()
                            } label: {
                                Text("확인")
                            }.alert(isPresented: $showEmptyContentAlert) {
                                Alert(title: Text("게시물의 내용을 입력해주세요."),
                                      message: Text("게시물의 내용이 비어있습니다."),
                                      dismissButton: .destructive(
                                        Text("확인")
                                      ){})
                            }
                        } else if editTitle != data.fields.title.stringValue || editContent != data.fields.content.stringValue {
                            Button {
                                print("수정됨")
                                data.fields.title.stringValue = editTitle
                                data.fields.content.stringValue = editContent
                                communityVM.updateCommunity(data: data, docID: data.fields.id.stringValue)
                                showSuccessAlert.toggle()
                            } label: {
                                Text("확인")
                            }.alert(isPresented: $showSuccessAlert) {
                                Alert(title: Text("수정이 완료되었습니다."),
                                      message: Text(""),
                                      dismissButton: .destructive(
                                        Text("확인")
                                      ){
                                          DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                              communityVM.fetchCommunity(nextPageToken: "")
                                          }
                                          presentationMode.wrappedValue.dismiss()
                                      })
                            }
                        } else {
                            Button {
                                print("수정된 사항 없음")
                                showSuccessAlert.toggle()
                            } label: {
                                Text("확인")
                            }.alert(isPresented: $showSuccessAlert) {
                                Alert(title: Text("수정이 완료되었습니다."),
                                      message: Text(""),
                                      dismissButton: .destructive(
                                        Text("확인")
                                      ){
                                          presentationMode.wrappedValue.dismiss()
                                      })
                            }
                        }
                    }
                }
            }
        }
    }
}

struct CommunityEditHeader: View {
    @State var community : CommunityDocument
    @State var clickedTitle : Bool = false  // 텍스트 클릭 Bool
    
    @Binding var editTitle : String
    
    var body: some View {
        HStack {
            // MARK: 텍스트 클릭시 텍스트 필드로 변환 onSubmit하면 수정한 텍스트 데이터에 저장
            if clickedTitle{
                TextField(community.fields.title.stringValue, text: $editTitle)
                    .font(.title2)
                    .bold()
                    .padding(.horizontal)
                    .onSubmit {
                        community.fields.title.stringValue = editTitle
                        clickedTitle.toggle()
                    }
            }else{
                Text(community.fields.title.stringValue)
                    .font(.title2)
                    .bold()
                    .padding(.horizontal)
                    .onTapGesture {
                        clickedTitle.toggle()
                    }
            }
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .frame(height: 40)
        .background(Rectangle().foregroundColor(.white))
    }
}
//struct MagazineEditView_Previews: PreviewProvider {
//    static var previews: some View {
//        MagazineEditView()
//    }
//}
