//
//  MarketTabView.swift
//  Grain
//
//  Created by 조형구 on 2023/01/19.
//

import SwiftUI

struct MarketTabView: View {

    @ObservedObject var communityVM : CommunityViewModel
    @ObservedObject var userVM : UserViewModel
    @ObservedObject var magazineVM : MagazineViewModel
    
    @Binding var isLoading: Bool
    
    var body: some View {
        VStack {
            ScrollView{
                ForEach(communityVM.returnCategoryCommunity(category: "클래스"), id: \.self){ data in
                    NavigationLink {
                        CommunityDetailView(communityVM: communityVM, userVM: userVM, magazineVM: magazineVM, community: data)
                    } label: {
                        CommunityRowView(community: data, isLoading: $isLoading)
                    }
                }
            }
        }// VStack
        .refreshable {
            communityVM.fetchCommunity()
        }
    }
}

//struct MarketTabView_Previews: PreviewProvider {
//    static var previews: some View {
//        MarketTabView()
//    }
//}
