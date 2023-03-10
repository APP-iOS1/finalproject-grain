//
//  CommunityView.swift
//  Grain
//
//  Created by 박희경 on 2023/01/18.
//

import SwiftUI

struct CommunityView: View {
    @StateObject var communityVM: CommunityViewModel
    let colors: [String] = ["", "#807EFC", "#6CD9B7", "E3F084", "FA98E0"]
    let titles: [String] = ["전체", "매칭", "마켓", "클래스", "정보"]
    @State private var selectedIndex: Int = 0
    @State private var isAddViewShown: Bool = false
    @State private var isSearchViewShown: Bool = false
    
    
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
                                    .transition(.slide)
                                    .animation(.easeInOut, value: selectedIndex)
                            }
                        })
                    
                    Spacer()
                } // hstack
                
                switch(selectedIndex) {
                case 0:
                    AllTabView(community: communityVM.sortedRecentCommunityData, communityVM: communityVM, isLoading: $communityVM.isLoading)
                case 1:
                    MatchingTabView(community: communityVM.returnCategoryCommunity(category: "매칭"), isLoading: $communityVM.isLoading, communityVM: communityVM)
                case 2:
                    ClassTabView(community: communityVM.returnCategoryCommunity(category: "마켓"), isLoading: $communityVM.isLoading, communityVM: communityVM)
                case 3:
                    MarketTabView(community: communityVM.returnCategoryCommunity(category: "클래스"), isLoading: $communityVM.isLoading, communityVM: communityVM)
                default:
                    InfoTabView(community: communityVM.returnCategoryCommunity(category: "정보"), isLoading: $communityVM.isLoading, communityVM: communityVM)
                }
            } // 최상단 vstack
        } // navi stack
        .navigationDestination(isPresented: $isSearchViewShown) {
            MainSearchView()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Text("GRAIN")
                    .font(.title)
                    .bold()
                    .kerning(7)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    self.isSearchViewShown.toggle()
                } label: {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.black)
//
                }
            }
        }
        .onAppear {
            // 커뮤니티 데이터 fetch
            communityVM.fetchCommunity()
            // MARK: 커뮤니티 업데이트 메서드 부분 필요시 확인하고 사용하기!
            /// isArray 업데이트 해야하는 값이 배열이면 true로 전달
//            Task{
//                await communityVM.updateCommunity(updateDocument: "PQGsHYXGjF8QkeQol8sz", updateKey: "name", updateValue: "123131", isArray: false)
//            }
            self.isSearchViewShown = false

        }
        
    }
}

//struct CommunityView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommunityView()
//    }
//}
