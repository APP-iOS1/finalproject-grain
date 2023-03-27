//
//  MagazineEditView.swift
//  Grain
//
//  Created by 지정훈 on 2023/02/07.
//
import SwiftUI
import FirebaseAuth
import Kingfisher

// 텍스트 필드 포커스를 위한 열거형
private enum FocusableField: Hashable {
    case title
    case content
}

struct MagazineEditView: View {
    @ObservedObject var magazineVM : MagazineViewModel
    @Binding var data : MagazineDocument?
    @State var editTitle : String = ""
    @State var editContent : String = ""
    @State var editCustomPlace : String = ""
    @State var clickedContent : Bool = false   // 텍스트 클릭 Bool
    @State var clickedCustomPlace : Bool = false    // 텍스트 클릭 Bool 
    @State private var showSuccessAlert: Bool = false
    @State private var showEmptyContentAlert: Bool = false
    @State private var showEmptyTitleAlert: Bool = false
    @FocusState private var focus: FocusableField?
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView{
            ScrollView {
                VStack{
                    VStack {
                        HStack {
                            Circle()
                                .frame(width: 40)
                            if let data = self.data {
                                VStack(alignment: .leading) {
                                    Text(data.fields.nickName.stringValue)
                                        .bold()
                                    HStack {
                                        Text(data.createTime.toDate()?.renderTime() ?? "")
                                        Spacer()
                                        // 커스텀 플레이스 이름 변경 불가능하게 수정
                                        Text(data.fields.customPlaceName.stringValue)
                                    }
                                    .font(.caption)
                                }
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
                            if let data = self.data {
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
                        }
                        .frame(width: Screen.maxWidth , height: Screen.maxWidth)
                        .tabViewStyle(.page)
                    }
                    .frame(minHeight: 350)
                    
                    LazyVStack(pinnedViews: [.sectionHeaders]) {
                        if let data = self.data {
                            Section(header: MagazineEditHeader(data: data, editTitle: $editTitle)){
                                VStack {
                                    TextField(data.fields.content.stringValue, text: $editContent)
                                        .lineSpacing(4.0)
                                        .padding(.vertical, -9)
                                        .padding()
                                        .foregroundColor(Color.textGray)
                                        .focused($focus, equals: .content)
                                        .disableAutocorrection(true)
                                        .autocapitalization(.none)
                                }
                            }
                        }
                    }
                    Spacer()
                }
            }
            .padding(.top, 1)
        }
        .onAppear {
            if let data = self.data {
                editTitle = data.fields.title.stringValue
                editContent = data.fields.content.stringValue
                editCustomPlace = data.fields.customPlaceName.stringValue
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if var data = self.data {
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
                                magazineVM.updateMagazine(data: data, docID: data.fields.id.stringValue)
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
struct MagazineEditHeader: View {
    @State var data : MagazineDocument
    @State var clickedTitle : Bool = true  // 텍스트 클릭 Bool
    
    @Binding var editTitle : String
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            // MARK: 텍스트 클릭시 텍스트 필드로 변환 onSubmit하면 수정한 텍스트 데이터에 저장
            if clickedTitle {
                TextField(data.fields.title.stringValue, text: $editTitle)
                    .font(.title2)
                    .bold()
                    .padding(.horizontal)
                    .onSubmit {
                        data.fields.title.stringValue = editTitle
                        clickedTitle.toggle()
                    }
            }
            else {
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

