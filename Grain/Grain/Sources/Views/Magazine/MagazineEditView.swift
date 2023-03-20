//
//  MagazineEditView.swift
//  Grain
//
//  Created by 지정훈 on 2023/02/07.
//
import SwiftUI
import FirebaseAuth
import Kingfisher

struct MagazineEditView: View {
    @StateObject var magazineVM = MagazineViewModel()
    
    @State var data : MagazineDocument
    @State var editTitle : String = ""
    @State var editContent : String = ""
    @State var editCustomPlace : String = ""
    @State var clickedContent : Bool = false    // 텍스트 클릭 Bool
    @State var clickedCustomPlace : Bool = false    // 텍스트 클릭 Bool
    @State private var showSuccessAlert: Bool = false
    @State private var showAlert: Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView{
            ScrollView {
                VStack{
                    VStack {
                        HStack {
                            Circle()
                                .frame(width: 40)
                            VStack(alignment: .leading) {
                                Text(data.fields.nickName.stringValue)
                                    .bold()
                                HStack {
                                    Text(data.createTime.toDate()?.renderTime() ?? "")
                                    Spacer()
                                    if clickedCustomPlace{
                                        TextField(data.fields.customPlaceName.stringValue, text: $editCustomPlace)
                                            .onSubmit {
                                                data.fields.customPlaceName.stringValue = editCustomPlace
                                                clickedCustomPlace.toggle()
                                            }
                                    }else{
                                        Text(data.fields.customPlaceName.stringValue)
                                            .onTapGesture {
                                                clickedCustomPlace.toggle()
                                            }
                                    }
                                    
                                }
                                .font(.caption)
                            }
                            Spacer()
                        }
                        .padding()
                        .padding(.top, -15)
                        Divider()
                            .frame(maxWidth: Screen.maxWidth * 0.9)
                            .background(Color.black)
                            .padding(.top, -5)
                            .padding(.bottom, -10)
                        
                        TabView{
                            ForEach(data.fields.image.arrayValue.values, id: \.self) { item in
                                Rectangle()
                                    .frame(width: Screen.maxWidth , height: Screen.maxWidth)
                                    .overlay{
                                        KFImage(URL(string: item.stringValue) ?? URL(string:"https://cdn.travie.com/news/photo/202108/21951_11971_5847.jpg"))
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                    }
                                
                            }
                        }
                        .frame(width: Screen.maxWidth , height: Screen.maxWidth)
                        .tabViewStyle(.page)
                    }
                    .frame(minHeight: 350)
                    
                    LazyVStack(pinnedViews: [.sectionHeaders]) {
                        Section(header: MagazineEditHeader(data: data, editTitle: $editTitle) ){
                            VStack {
                                
                                // MARK: 텍스트 클릭시 텍스트 필드로 변환 onSubmit하면 수정한 텍스트 데이터에 저장
                                if clickedContent{
                                    TextField(data.fields.content.stringValue, text: $editContent)
                                        .lineSpacing(4.0)
                                        .padding(.vertical, -9)
                                        .padding()
                                        .foregroundColor(Color.textGray)
                                        .onSubmit {
                                            clickedContent.toggle()
                                        }
                                }else{
                                    Text(data.fields.content.stringValue)
                                        .lineSpacing(4.0)
                                        .padding(.vertical, -9)
                                        .padding()
                                        .foregroundColor(Color.textGray)
                                        .onTapGesture {
                                            clickedContent.toggle()
                                        }
                                }
                                
                            }
                        }
                    }
                    Spacer()
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
                                data.fields.title.stringValue = editTitle
                            }else{
                                data.fields.title.stringValue = data.fields.title.stringValue
                            }
                            //content가 바뀐게 있다면 바뀐거 넣어주고 없으면 그대로 전송하기
                            if editContent.count > 0 {
                                data.fields.content.stringValue = editContent
                            }else{
                                data.fields.content.stringValue = data.fields.content.stringValue
                            }
                            magazineVM.updateMagazine(data: data, docID: data.fields.id.stringValue)
                            
                            showSuccessAlert.toggle()
                        }  label: {
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
struct MagazineEditHeader: View {
    @State var data : MagazineDocument
    @State var clickedTitle : Bool = false  // 텍스트 클릭 Bool
    
    @Binding var editTitle : String
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            
            // MARK: 텍스트 클릭시 텍스트 필드로 변환 onSubmit하면 수정한 텍스트 데이터에 저장
            if clickedTitle{
                TextField(data.fields.title.stringValue, text: $editTitle)
                    .font(.title2)
                    .bold()
                    .padding(.horizontal)
                    .onSubmit {
                        data.fields.title.stringValue = editTitle
                        clickedTitle.toggle()
                    }
            }else{
                Text(data.fields.title.stringValue)
                    .font(.title2)
                    .bold()
                    .padding(.horizontal)
                    .onTapGesture {
                        clickedTitle.toggle()
                    }
            }
            
            Spacer()
            Divider()
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .frame(height: 56)
        .background(Rectangle().foregroundColor(.white))
    }
}
