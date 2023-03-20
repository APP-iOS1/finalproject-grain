//
//  CommunityAllTabView.swift
//  Grain
//
//  Created by 조형구 on 2023/01/19.
//

import SwiftUI

struct AllTabView: View {
    
    var community: [CommunityDocument]
    @StateObject var communityVM: CommunityViewModel
    @Binding var isLoading: Bool
    
    var body: some View {
        NavigationView{
            VStack {
                ScrollView{
                    ForEach(community, id: \.self) { data in
                        NavigationLink {
                            CommunityDetailView(community: data)
                        } label: {
                            CommunityRowView(community: data, isLoading: $isLoading)
                        }
                    }
                }
            }// VStack
        }
        .refreshable {
            communityVM.fetchCommunity()
        }
    }
}

