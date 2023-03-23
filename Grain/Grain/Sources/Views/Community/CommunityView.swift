//
//  CommunityView.swift
//  Grain
//
//  Created by 박희경 on 2023/01/18.
//

import SwiftUI

struct CommunityView: View {
    
    @StateObject var commentVm = CommentViewModel()
    @ObservedObject var communityVM : CommunityViewModel
    @ObservedObject var userVM : UserViewModel
    @ObservedObject var magazineVM : MagazineViewModel
    
    @State private var selectedIndex: Int = 0
    @State private var isAddViewShown: Bool = false
    @State private var isSearchViewShown: Bool = false
    
    let colors: [String] = ["", "#807EFC", "#6CD9B7", "E3F084", "FA98E0"]
    let titles: [String] = ["전체", "매칭", "마켓", "클래스", "정보"]
        
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
                    AllTabView(commentVm: commentVm, communityVM : communityVM, userVM: userVM, magazineVM: magazineVM, isLoading: $communityVM.isLoading)
                case 1:
                    MatchingTabView(commentVm: commentVm, communityVM: communityVM, userVM: userVM, magazineVM: magazineVM, isLoading: $communityVM.isLoading)
                case 2:
                    ClassTabView(commentVm: commentVm, communityVM: communityVM, userVM: userVM, magazineVM: magazineVM, isLoading: $communityVM.isLoading )
                case 3:
                    MarketTabView(commentVm: commentVm, communityVM: communityVM, userVM: userVM, magazineVM: magazineVM, isLoading: $communityVM.isLoading )
                default:
                    InfoTabView(commentVm: commentVm, communityVM: communityVM, userVM: userVM, magazineVM: magazineVM, isLoading: $communityVM.isLoading )
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
                }
            }
        }
        .onAppear {
            // 커뮤니티 데이터 fetch
            communityVM.fetchCommunity()
            self.isSearchViewShown = false
        }
        
    }
}

//struct CommunityView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommunityView()
//    }
//}
