//
//  CommunityView.swift
//  Grain
//
//  Created by 박희경 on 2023/01/18.
//

import SwiftUI

struct CommunityView: View {
    @StateObject var communityVM: CommunityViewModel
    
    let titles: [String] = ["전체", "매칭", "마켓", "클래스", "정보"]
    @State private var selectedIndex: Int = 0
    @State private var isAddViewShown: Bool = false
    
    var body: some View {
        NavigationStack{
            VStack{
                HStack {
                    Spacer()
                    SegmentedPicker(
                        titles,
                        selectedIndex: Binding(
                            get: { selectedIndex },
                            set: { selectedIndex = $0 ?? 0 }),
                        content: { item, isSelected in
                            Text(item)
                                .foregroundColor(isSelected ? Color.black : Color.gray )
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .font(.title3)
                                .bold()
                        },
                        selection: {
                            VStack(spacing: 0) {
                                Spacer()
                                Rectangle()
                                    .fill(Color.black)
                                    .frame(height: 1)
                            }
                        })
                    
                    Spacer()
                } // hstack
                
                //MARK: 소희님이 공유해주신 제스쳐 탭이동 없애기부분 (적용하면 툴바 사용할수없음)
//                switch(selectedIndex) {
//                case 0:
//                    AllTabView(community: communityVM.communities)
//                case 1:
//                    MatchingTabView(community: communityVM.returnCategoryCommunity(category: "매칭"))
//                case 2:
//                    ClassTabView(community: communityVM.returnCategoryCommunity(category: "마켓"))
//                case 3:
//                    MarketTabView(community: communityVM.returnCategoryCommunity(category: "클래스"))
//                case 4:
//                    InfoTabView(community: communityVM.returnCategoryCommunity(category: "정보"))
//                }
                TabView(selection: $selectedIndex) {
                    AllTabView(community: communityVM.communities)
                        .tag(0)
                    MatchingTabView(community: communityVM.returnCategoryCommunity(category: "매칭"))
                        .tag(1)
                    ClassTabView(community: communityVM.returnCategoryCommunity(category: "마켓"))
                        .tag(2)
                    MarketTabView(community: communityVM.returnCategoryCommunity(category: "클래스"))
                        .tag(3)
                    InfoTabView(community: communityVM.returnCategoryCommunity(category: "정보"))
                        .tag(4)
                }
                .tabViewStyle(.page)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Text("GRAIN")
                            .font(.title)
                            .bold()
                            .kerning(7)
                    }
    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: MainSearchView()) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.black)
                        }
                    }
                }
            } // 최상단 vstack
        } // navi stack
        .onAppear {
            // 커뮤니티 데이터 fetch
            communityVM.fetchCommunity()
        }
    }
}

//struct CommunityView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommunityView()
//    }
//}
