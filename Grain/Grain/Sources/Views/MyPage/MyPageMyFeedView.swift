//
//  MyPageMyFeedView.swift
//  Grain
//
//  Created by 홍수만 on 2023/02/03.
//

import SwiftUI
import Kingfisher

struct MyPageMyFeedView: View {

    // 나의 피드를 그리드로 보여줄지 리스트로 보여줄지 선택하는 변수
    @State private var showGridOrList: Bool = true
    @StateObject var userVM = UserViewModel()
    var magazineDocument: [MagazineDocument]
    
    let columns = [
        GridItem(.adaptive(minimum: 100))
    ]
    
    var body: some View {
        VStack{
            HStack{
                Button{
                    showGridOrList.toggle()
                } label: {
                    Image(systemName: "square.grid.2x2")
                }
                Button{
                    showGridOrList.toggle()
                } label:{
                    Image(systemName: "list.bullet")
                }
                Spacer()
                
            }
            .foregroundColor(.black)
            .font(.title3)
            .padding()
            .padding(.leading, 22)
            
            if showGridOrList {
                ScrollView{
                    LazyVGrid(columns: columns, spacing: 1) {
                        ForEach(magazineDocument, id: \.self) { data in
                            NavigationLink {
                                MagazineDetailView(userVM: userVM, isHeartToggle: userVM.isLikedMagazine(magazine: data), isBookMarked: userVM.isLikedMagazine(magazine: data), data: data)
                            } label: {
                                KFImage(URL(string: data.fields.image.arrayValue.values[0].stringValue) ?? URL(string:"https://cdn.travie.com/news/photo/202108/21951_11971_5847.jpg"))
                                   .resizable()
                                   .aspectRatio(contentMode: .fit)
                                   .frame(width: 100)
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
                                MagazineDetailView(userVM: userVM, isHeartToggle: userVM.isLikedMagazine(magazine: data), isBookMarked: userVM.isLikedMagazine(magazine: data), data: data)
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
