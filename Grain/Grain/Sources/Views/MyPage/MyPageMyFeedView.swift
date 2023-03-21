//
//  MyPageMyFeedView.swift
//  Grain
//
//  Created by 홍수만 on 2023/02/03.
//

import SwiftUI
import Kingfisher

struct MyPageMyFeedView: View {
    @ObservedObject var userVM : UserViewModel
    @ObservedObject var magazineVM: MagazineViewModel
    // 나의 피드를 그리드로 보여줄지 리스트로 보여줄지 선택하는 변수
    @State private var showGridOrList: Bool = true
    @State var ObservingChangeValueLikeNum : String = ""
    @State private var selectedIndex: Int?
    
    var magazineDocument: [MagazineDocument]
    
    let columns = [
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1)
    ]
    
    var body: some View {
        VStack{
            HStack{
                Button{
                    showGridOrList.toggle()
                } label: {
                    if showGridOrList {
                        Image(systemName: "square.grid.2x2")
                    } else {
                        Image(systemName: "square.grid.2x2")
                            .foregroundColor(.brightGray)
                    }
                }
                Button{
                    showGridOrList.toggle()
                } label:{
                    if showGridOrList {
                        Image(systemName: "list.bullet")
                            .foregroundColor(.brightGray)
                    } else {
                        Image(systemName: "list.bullet")
                    }
                }
                Spacer()
                
            }
            .foregroundColor(.black)
            .font(.title3)
            .padding()
            .padding(.leading, 12)
            
            if showGridOrList {
                ScrollView{
                    LazyVGrid(columns: columns, spacing: 1) {
                        ForEach(magazineDocument, id: \.self) { data in
                            NavigationLink {
                                MagazineDetailView(magazineVM: magazineVM, userVM: userVM, data: data, ObservingChangeValueLikeNum: $ObservingChangeValueLikeNum)
                            } label: {
                                KFImage(URL(string: data.fields.image.arrayValue.values[0].stringValue) ?? URL(string:"https://cdn.travie.com/news/photo/202108/21951_11971_5847.jpg"))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: Screen.maxWidth / 3 - 1, height: Screen.maxWidth / 3 - 1)
                                    .clipped()
                            }
                        }
                    }
                }
                .task(id: ObservingChangeValueLikeNum){
                    Task{
                        await magazineVM.fetchMagazine()
                    }
                }
            } else {
                ScrollView{
                    LazyVStack{
                        ForEach(magazineDocument, id: \.self) { data in
                            NavigationLink {
                                // MARK: 피드 뷰 디테일로 넘어가기 index -> fetch해온 데이터
                                MagazineDetailView(magazineVM: magazineVM, userVM: userVM, data: data, ObservingChangeValueLikeNum: $ObservingChangeValueLikeNum)
                            } label: {
                                // MARK: fetch해온 데이터 cell뷰로 보여주기
                                MagazineViewCell(data: data)
                            }
                        }
                    }
                }
                .task(id: ObservingChangeValueLikeNum){
                    Task{
                        await magazineVM.fetchMagazine()
                    }
                }
            }
            
        }
    }
}
