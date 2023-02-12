//
//  CommunityEditView.swift
//  Grain
//
//  Created by 윤소희 on 2023/02/13.
//

import SwiftUI
import FirebaseAuth

struct CommunityEditView: View {
    @State var community : CommunityDocument
    @StateObject var communityVM = CommunityViewModel()

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
                                Text(community.fields.nickName.stringValue)
                                    .bold()
                                //MARK: 옵셔널 처리 고민
                                HStack {
                                    Text(community.createdDate?.renderTime() ?? "")
                                    Spacer()
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
                        Section(header: CommunityEditHeader(community: community, editTitle: $editTitle) ){
                            VStack {
                                
                                // MARK: 텍스트 클릭시 텍스트 필드로 변환 onSubmit하면 수정한 텍스트 데이터에 저장
                                if clickedContent{
                                    TextField(community.fields.content.stringValue, text: $editContent)
                                        .lineSpacing(4.0)
                                        .padding(.vertical, -9)
                                        .padding()
                                        .foregroundColor(Color.textGray)
                                        .onSubmit {
                                            community.fields.content.stringValue = editContent
                                            clickedContent.toggle()
                                        }
                                }else{
                                    Text(community.fields.content.stringValue)
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
                        var docId = String(community.name.suffix(20))
                        community.fields.title.stringValue = editTitle
                        community.fields.content.stringValue = editContent
                        communityVM.updateCommunity(data: community, docID: docId)
                    } label: {
                        Text("수정완료")
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
        VStack(alignment: .leading) {
            Spacer()
            
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
