//
//  MarketTabView.swift
//  Grain
//
//  Created by 조형구 on 2023/01/19.
//

import SwiftUI

struct MarketTabView: View {
    
    var community: [CommunityDocument]
    @Binding var isLoading: Bool
    @StateObject var communityVM: CommunityViewModel
    var body: some View {
       
            VStack {
                ScrollView{
                    ForEach(community, id: \.self){ data in
                        NavigationLink {
                            CommunityDetailView(community: data)
                        } label: {
                            CommunityRowView(community: data, isLoading: $isLoading)
                        }
                    }
                }
            }// vstack
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
