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
    @State var community : CommunityDocument
    @State var editTitle : String = ""
    @State private var editContent : String = ""
    @State var clickedTitle : Bool = false
    @State var clickedContent : Bool = false
    @State private var showAlert: Bool = false
    @State private var showSuccessAlert: Bool = false
    @FocusState private var focus: FocusableField?
    
    @Environment(\.presentationMode) var presentationMode
    
    let communityVM: CommunityViewModel
    
    @Binding var editFetch: Bool
    
    var body: some View {
        ScrollView {
            VStack{
                VStack {
                    // MARK: 텍스트 클릭시 텍스트 필드로 변환 onSubmit하면 수정한 텍스트 데이터에 저장
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
                    
                    HStack {
                        ProfileImage(imageName: community.fields.profileImage.stringValue)
                        VStack(alignment: .leading) {
                            Text(community.fields.nickName.stringValue)
                            //MARK: 옵셔널 처리 고민
                            Text(community.createTime.toDate()?.renderTime() ?? "")
                                .font(.caption)
                        }
                        Spacer()
                    }//HS
                    
                    Divider()
                        .frame(maxWidth: Screen.maxWidth * 0.94)
                        .background(Color.black)
                        .padding(.top, 5)
                        .padding(.bottom, 15)
                    
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
                    .padding(.bottom, 15)
                }
                
                // MARK: 텍스트 클릭시 텍스트 필드로 변환 onSubmit하면 수정한 텍스트 데이터에 저장
                HStack{
                    if clickedContent{
                        VStack{
                            TextField(community.fields.content.stringValue, text: $editContent, axis: .vertical)
                                .lineSpacing(4.0)
                                .padding(.vertical, -15)
                                .padding()
                                .foregroundColor(Color.textGray)
                                .onSubmit {
                                    community.fields.content.stringValue = editContent
                                    clickedContent.toggle()
                                }
                        }
                        .padding(.top, -5)
                        
                    }else{
                        Text(community.fields.content.stringValue)
                            .lineSpacing(4.0)
                            .padding(.vertical, -20)
                            .padding()
                            .onTapGesture {
                                clickedContent.toggle()
                            }
                    }
                    Spacer()
                }
                .padding(.top, 6)
            }
        }
        .onAppear {
            focus = .title
            editTitle = community.fields.title.stringValue
            editContent = community.fields.content.stringValue

        }
        .padding(.top, 1)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack{
                    if editTitle.isEmpty && editContent.isEmpty {
                        Button {
                            showAlert.toggle()
                            editFetch.toggle()
                        } label: {
                            Text("수정완료")
                        }//변경 안됐을때 Alert
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text("변경된 내용이 없습니다."),
                                  message: Text("수정하실 내용을 입력해주세요."),
                                  dismissButton: .destructive(
                                    Text("확인")
                                  ){
                                      
                                  })
                        }
                    }else{
                        Button {
                            if editTitle.count > 0 {
                                community.fields.title.stringValue = editTitle
                            }else{
                                community.fields.title.stringValue = community.fields.title.stringValue
                            }
                            //content가 바뀐게 있다면 바뀐거 넣어주고 없으면 그대로 전송하기
                            if editContent.count > 0 {
                                community.fields.content.stringValue = editContent
                            }else{
                                community.fields.content.stringValue = community.fields.content.stringValue
                            }
                            communityVM.updateCommunity(data: community, docID: community.fields.id.stringValue)
                            showSuccessAlert.toggle()
                        } label: {
                            Text("수정완료")
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
