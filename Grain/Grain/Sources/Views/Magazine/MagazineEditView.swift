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
    @State var data : MagazineDocument
    @StateObject var magazineVM = MagazineViewModel()

    @State var editTitle : String = ""
    @State var editContent : String = ""
    @State var editCustomPlace : String = ""
    
    @State var clickedContent : Bool = false    // 텍스트 클릭 Bool
    @State var clickedCustomPlace : Bool = false    // 텍스트 클릭 Bool
    
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

                        //            Image("line")
                        //                .resizable()
                        //                .frame(width: Screen.maxWidth, height: 0.3)
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
//                                            data.fields.content.stringValue = editContent
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
                    Button {
                        var docId = String(data.name.suffix(20))
                        data.fields.title.stringValue = editTitle
                        data.fields.content.stringValue = editContent
                        magazineVM.updateMagazine(data: data, docID: docId)
                    } label: {
                        Text("수정완료")
                    }

                }
            }
        }
    }
}

struct MagazineEditHeader: View {
    @State var data : MagazineDocument
    @Binding var editTitle : String
    @State var clickedTitle : Bool = false  // 텍스트 클릭 Bool
    
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
