//
//  MagazineEditView.swift
//  Grain
//
//  Created by 지정훈 on 2023/02/07.
//
import SwiftUI
import FirebaseAuth

struct MagazineEditView: View {
    @State var data : MagazineDocument
    @StateObject var magazineVM = MagazineViewModel()

    @State var editTitle : String = ""
    @State var editContent : String = ""
    @State var editCustomPlace : String = ""


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
                                    Text("1분전")
                                    Spacer()
                                    TextField(data.fields.customPlaceName.stringValue, text: $editCustomPlace)
                                        .onSubmit {
                                            data.fields.customPlaceName.stringValue = editCustomPlace
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
                            ForEach(1..<4, id: \.self) { i in
                                Image("\(i)")
                                    .resizable()
                                    .frame(width: Screen.maxWidth, height: Screen.maxWidth * 0.6)
                                    .aspectRatio(contentMode: .fit)
                            }
                        }
                        .tabViewStyle(.page)
                        .frame(maxHeight: Screen.maxHeight * 0.27)
                        .padding()
                    }
                    .frame(minHeight: 350)

                    LazyVStack(pinnedViews: [.sectionHeaders]) {
                        Section(header: MagazineEditHeader(data: data, editTitle: $editTitle) ){
                            VStack {
                                TextField(data.fields.content.stringValue, text: $editContent)
                                    .lineSpacing(4.0)
                                    .padding(.vertical, -9)
                                    .padding()
                                    .foregroundColor(Color.textGray)
                                    .onSubmit {
                                        data.fields.content.stringValue = editContent
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
                        //수정
//                        magazineVM
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

    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            TextField(data.fields.title.stringValue, text: $editTitle)
                .font(.title2)
                .bold()
                .padding(.horizontal)
                .onSubmit {
                    data.fields.title.stringValue = editTitle
                }
            Spacer()
            Divider()
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .frame(height: 56)
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
