//
//  CommunityEditView.swift
//  Grain
//
//  Created by 윤소희 on 2023/02/13.
//

import SwiftUI
import FirebaseAuth
import Kingfisher
//import Introspect

struct CommunityEditView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var communityVM = CommunityViewModel()
    
    @State var community : CommunityDocument
    @State var editTitle : String = ""
    @State private var editContent : String = ""
    
    @State var clickedTitle : Bool = false
    @State var clickedContent : Bool = false
    @State private var showAlert: Bool = false
    @State private var showSuccessAlert: Bool = false
 
    var body: some View {
        NavigationView{
            ScrollView {
                VStack{
                    VStack {
                        HStack {
                            // MARK: 텍스트 클릭시 텍스트 필드로 변환 onSubmit하면 수정한 텍스트 데이터에 저장
                            if clickedTitle{
                                VStack{
                                    TextField(community.fields.title.stringValue, text: $editTitle)
                                        .font(.title2)
                                        .padding(.horizontal)
                                        .padding(.vertical, 3)
                                        .padding(.bottom, 3)
                                        .bold()
                                        .onSubmit {
                                            community.fields.title.stringValue = editTitle
                                            clickedTitle.toggle()
                                        }
                                }
                                .padding(.top, 1)
                                
                            }else{
                                Text(community.fields.title.stringValue)
                                    .font(.title2)
                                    .padding(.horizontal)
                                    .padding(.top, 5)
                                    .bold()
                                   // .border(.blue)
                                    .onTapGesture {
                                        clickedTitle.toggle()
                                    }
                            }
                            Spacer()
                        }
                        .padding(.top, 5)
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
                            //.padding(.leading, Screen.maxWidth * 0.03)
                        
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
//                        .padding()
//                        .padding(.top, -15)
                        //.padding()
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
                    
                       
                    //Spacer()
                }
            }
            .padding(.top, 1)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack{
                    if editTitle.isEmpty && editContent.isEmpty {
                        Button {
                            showAlert.toggle()
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
    @Binding var editTitle : String
    @State var clickedTitle : Bool = false  // 텍스트 클릭 Bool
    
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

//----------------여기까지 디테일 수정 update 로쥑
//1. 메거진 데이터 올리고 response data로 자동으로 생성된 매거진 id 받아서 magazine put(update) 바로 다시 request 보냄 . -> 이거슨 바로 수정, 삭제하기 위한 큰그림(왜냐하면 "해당" 게시물 만 접근해야되기 때문입니다! )
//-------------------------- 여기까지 완성되면 수정, 삭제 가능합니다 ^^* "해줘"
