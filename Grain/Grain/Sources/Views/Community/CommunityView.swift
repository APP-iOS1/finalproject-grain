//
//  CommunityView.swift
//  Grain
//
//  Created by 박희경 on 2023/01/18.
//

import SwiftUI

struct CommunityView: View {
    
    @ObservedObject var communityVM : CommunityViewModel
    @ObservedObject var userVM : UserViewModel
    @ObservedObject var magazineVM : MagazineViewModel
    
    @State private var communitySelectedIndex: Int = 0
    @State private var isAddViewShown: Bool = false
    
    @Binding var scrollToTop: Bool

    let colors: [String] = ["", "#807EFC", "#6CD9B7", "E3F084", "FA98E0"]
    let titles: [String] = ["전체", "매칭", "마켓", "클래스", "정보"]
        
    var body: some View {
            VStack{
                HStack {
                    Spacer()
                    SegmentedPicker(
                        titles,
                        selectedIndex: Binding(
                            get: { communitySelectedIndex },
                            set: { communitySelectedIndex = $0 ?? 0 }),
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
                                    .frame(height: 2)
                                    .animation(.easeInOut.speed(1.5), value: communitySelectedIndex)
                            }
                        })
                    
                    Spacer()
                } // hstack
                switch(communitySelectedIndex) {
                case 0:
                    AllTabView(communityVM : communityVM, userVM: userVM, magazineVM: magazineVM, isLoading: $communityVM.isLoading, scrollToTop: $scrollToTop)
                case 1:
                    MatchingTabView(communityVM : communityVM, userVM: userVM, magazineVM: magazineVM, isLoading: $communityVM.isLoading, scrollToTop: $scrollToTop)
                case 2:
                    ClassTabView(communityVM : communityVM, userVM: userVM, magazineVM: magazineVM, isLoading: $communityVM.isLoading, scrollToTop: $scrollToTop)
                case 3:
                    MarketTabView(communityVM : communityVM, userVM: userVM, magazineVM: magazineVM, isLoading: $communityVM.isLoading, scrollToTop: $scrollToTop)
                default:
                    InfoTabView(communityVM : communityVM, userVM: userVM, magazineVM: magazineVM, isLoading: $communityVM.isLoading, scrollToTop: $scrollToTop)
                }
            }
            .onAppear{
                communityVM.fetchCommunityCellComment()
            }
      
    }
}

//struct CommunityView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommunityView()
//    }
//}
