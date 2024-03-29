//
//  MyPageMyFeedView.swift
//  Grain
//
//  Created by 홍수만 on 2023/02/03.
//

import SwiftUI
import Kingfisher
import FirebaseAuth
 
struct MyPageMyFeedView: View {
    @ObservedObject var userVM : UserViewModel
    @ObservedObject var magazineVM: MagazineViewModel
    // 나의 피드를 그리드로 보여줄지 리스트로 보여줄지 선택하는 변수
    @State private var showGridOrList: Bool = true
    @State var ObservingChangeValueLikeNum : String = ""
    @State private var selectedIndex: Int?
    @State private var scrollViewOffset: CGFloat = 0
    @State private var startOffset: CGFloat = 0
    
    let columns = [
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1)
    ]
    
    @Binding var presented: Bool
    @Binding var scrollToTop: Bool
    
    
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
            .font(.title3)
            .padding(.horizontal)
            .padding(.leading, 12)
            .padding(.vertical, 3)
            
            if showGridOrList {
                
                ScrollViewReader { proxyReader in
                    ScrollView(showsIndicators: false){
                        VStack {
                            LazyVGrid(columns: columns, spacing: 1) {
                                
                                ForEach(magazineVM.sortedRecentMagazineData.filter{ $0.fields.userID.stringValue == Auth.auth().currentUser?.uid }.reversed(), id: \.self) { data in
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
                            .emptyPlaceholder(magazineVM.sortedRecentMagazineData.filter{ $0.fields.userID.stringValue == Auth.auth().currentUser?.uid }.reversed()) {
                                MyPagePlaceholderView(presented: $presented)
                                
                            }
                        }
                        .id("SCROLL_TO_TOP")
                        .overlay(
                            GeometryReader { proxy -> Color in
                                DispatchQueue.main.async {
                                    if startOffset == 0 {
                                        self.startOffset = proxy.frame(in: .global).minY
                                    }
                                    let offset = proxy.frame(in: .global).minY
                                    self.scrollViewOffset = offset - startOffset
                                    
                                }
                                return Color.clear
                            }
                                .frame(width: 0, height: 0)
                            ,alignment: .top
                        )
                    }
                    .onChange(of: ObservingChangeValueLikeNum, perform: { newValue in
                        magazineVM.fetchMagazine(nextPageToken: "")
                    })
                    .onChange(of: scrollToTop, perform: { newValue in
                        withAnimation(.default) {
                            proxyReader.scrollTo("SCROLL_TO_TOP", anchor: .top)
                        }
                    })
                }
            } else {
                ScrollViewReader { proxyReader in
                    ScrollView(showsIndicators: false){
                        VStack {
                            LazyVStack{
                                ForEach(magazineVM.sortedRecentMagazineData.filter{ $0.fields.userID.stringValue == Auth.auth().currentUser?.uid }.reversed(), id: \.self) { data in
                                    NavigationLink {
                                        // MARK: 피드 뷰 디테일로 넘어가기 index -> fetch해온 데이터
                                        MagazineDetailView(magazineVM: magazineVM, userVM: userVM, data: data, ObservingChangeValueLikeNum: $ObservingChangeValueLikeNum)
                                    } label: {
                                        // MARK: fetch해온 데이터 cell뷰로 보여주기
                                        MagazineViewCell(data: data, userVM: userVM)
                                    }
                                }
                            }
                            .emptyPlaceholder(magazineVM.sortedRecentMagazineData.filter{ $0.fields.userID.stringValue == Auth.auth().currentUser?.uid }.reversed()) {
                                MyPagePlaceholderView(presented: $presented)
                                
                            }
                        }
                        .id("SCROLL_TO_TOP")
                        .overlay(
                            GeometryReader { proxy -> Color in
                                DispatchQueue.main.async {
                                    if startOffset == 0 {
                                        self.startOffset = proxy.frame(in: .global).minY
                                    }
                                    let offset = proxy.frame(in: .global).minY
                                    self.scrollViewOffset = offset - startOffset
                                    
                                }
                                return Color.clear
                            }
                                .frame(width: 0, height: 0)
                            ,alignment: .top
                        )
                    }
                    .onChange(of: ObservingChangeValueLikeNum, perform: { newValue in
                        magazineVM.fetchMagazine(nextPageToken: "")
                    })
                    .onChange(of: scrollToTop, perform: { newValue in
                        withAnimation(.default) {
                            proxyReader.scrollTo("SCROLL_TO_TOP", anchor: .top)
                        }
                    })
                }
            }
            
        }
        .onAppear{
            magazineVM.fetchMagazine(nextPageToken: "")
        }
    }
}
