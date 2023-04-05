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
    
    @Binding var presented: Bool
    
    
    func defaultProfileImage() -> String{
        var https : String = "https://"
        if let infolist = Bundle.main.infoDictionary {
            if let url = infolist["FailProfileImage"] as? String {
                https += url
            }
        }
        return https
    }
    
    var body: some View {
        VStack{
            HStack{
                
                
                Image(systemName: "square.grid.2x2")
                    .foregroundColor(showGridOrList ? .black : .brightGray)
                    .onTapGesture {
                        showGridOrList = true
                        
                    }
                
                Image(systemName: "list.bullet")
                    .foregroundColor(showGridOrList ? .brightGray : .black)
                    .onTapGesture{
                        showGridOrList = false
                        
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
                        ForEach(magazineDocument.reversed(), id: \.self) { data in
                            NavigationLink {
                                MagazineDetailView(magazineVM: magazineVM, userVM: userVM, data: data, ObservingChangeValueLikeNum: $ObservingChangeValueLikeNum)
                            } label: {
                                KFImage(URL(string: data.fields.image.arrayValue.values[0].stringValue) ?? URL(string: defaultProfileImage()))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: Screen.maxWidth / 3 - 1, height: Screen.maxWidth / 3 - 1)
                                    .clipped()
                            }
                        }
                    }
                    .emptyPlaceholder(magazineDocument.reversed()) {
                            MyPagePlaceholderView(presented: $presented)
                   
                    }
                }
                .task(id: ObservingChangeValueLikeNum){
                    magazineVM.fetchMagazine()
                }
            } else {
                ScrollView{
                    LazyVStack{
                        ForEach(magazineDocument.reversed(), id: \.self) { data in
                            NavigationLink {
                                // MARK: 피드 뷰 디테일로 넘어가기 index -> fetch해온 데이터
                                MagazineDetailView(magazineVM: magazineVM, userVM: userVM, data: data, ObservingChangeValueLikeNum: $ObservingChangeValueLikeNum)
                            } label: {
                                // MARK: fetch해온 데이터 cell뷰로 보여주기
                                MagazineViewCell(data: data, userVM: userVM)
                            }
                        }
                    }
                    .emptyPlaceholder(magazineDocument.reversed()) {
                            MyPagePlaceholderView(presented: $presented)
                   
                    }
                }
                .task(id: ObservingChangeValueLikeNum){
                    magazineVM.fetchMagazine()
                }
            }
            
        }
    }
}
