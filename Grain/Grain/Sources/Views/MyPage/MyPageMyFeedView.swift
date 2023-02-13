//
//  MyPageMyFeedView.swift
//  Grain
//
//  Created by 홍수만 on 2023/02/03.
//

import SwiftUI
import Kingfisher

struct MyPageMyFeedView: View {
    @StateObject var userVM = UserViewModel()

    // 나의 피드를 그리드로 보여줄지 리스트로 보여줄지 선택하는 변수
    @State private var showGridOrList: Bool = true
    
    var magazineDocument: [MagazineDocument]
    
    let columns = [
//        GridItem(.adaptive(minimum: 100), spacing: 1)
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1)
    ]
    
    @State private var selectedIndex: Int?

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
//                ScrollView{
//                    LazyVGrid(columns: columns, spacing: 1) {
//                        ForEach(magazineDocument, id: \.self) { data in
//                            NavigationLink {
//                                MagazineDetailView(userVM: userVM, currentUsers: userVM.currentUsers, data: data)
//                            } label: {
//                                KFImage(URL(string: data.fields.image.arrayValue.values[0].stringValue) ?? URL(string:"https://cdn.travie.com/news/photo/202108/21951_11971_5847.jpg"))
//                                   .resizable()
////                                   .aspectRatio(contentMode: .fit)
////                                   .frame(width: 100)
//                                   .scaledToFill()
//                                   .frame(width: Screen.maxWidth / 3 - 1, height: Screen.maxWidth / 3 - 1)
//                                   .clipped()
//                            }
//
//                        }
//                    }
//                }
                ScrollView{
                    LazyVGrid(columns: columns, spacing: 1) {
                        ForEach(magazineDocument, id: \.self) { data in
                            NavigationLink {
//                                MagazineDetailView(userVM: userVM, currentUsers: userVM.currentUsers, data: data)
                                TestScrollView(magazineDocument: magazineDocument, userVM: userVM, selectedIndex: selectedIndex)
                            } label: {
                                Button{
                                    selectedIndex = magazineDocument.firstIndex(of: data)
                                } label: {
                                    KFImage(URL(string: data.fields.image.arrayValue.values[0].stringValue) ?? URL(string:"https://cdn.travie.com/news/photo/202108/21951_11971_5847.jpg"))
                                       .resizable()
    //                                   .aspectRatio(contentMode: .fit)
    //                                   .frame(width: 100)
                                       .scaledToFill()
                                       .frame(width: Screen.maxWidth / 3 - 1, height: Screen.maxWidth / 3 - 1)
                                       .clipped()
                                }
                            
                            }
                            
                        }
                    }
                }
            } else {
                ScrollView{
                    LazyVStack{
                        ForEach(magazineDocument, id: \.self) { data in
                            NavigationLink {
                                // MARK: 피드 뷰 디테일로 넘어가기 index -> fetch해온 데이터
                                MagazineDetailView(userVM: userVM, currentUsers: userVM.currentUsers, data: data)
                            } label: {
                                // MARK: fetch해온 데이터 cell뷰로 보여주기
                                MagazineViewCell(data: data)
                            }
                        }
                    }
                }
            }
            
        }
    }
}

struct TestScrollView: View {
    var magazineDocument: [MagazineDocument]
    var userVM : UserViewModel
    var selectedIndex: Int?
    
    var body: some View {
        ScrollView{
            ScrollViewReader { proxy in
                LazyVStack{
                    ForEach(Array(zip(magazineDocument.indices, magazineDocument)), id: \.1) { index, data in
                        NavigationLink {
                            // MARK: 피드 뷰 디테일로 넘어가기 index -> fetch해온 데이터
                            MagazineDetailView(userVM: userVM, currentUsers: userVM.currentUsers, data: data)
                        } label: {
                            // MARK: fetch해온 데이터 cell뷰로 보여주기
                            MagazineViewCell(data: data)
                        }
                    }
                }
                .onAppear{
//                    proxy.scrollTo()
                }
            }

        }
    }
}

