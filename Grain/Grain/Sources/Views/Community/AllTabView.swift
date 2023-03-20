//
//  CommunityAllTabView.swift
//  Grain
//
//  Created by 조형구 on 2023/01/19.
//

import SwiftUI

struct AllTabView: View {
    
    @ObservedObject var communityVM: CommunityViewModel
    @ObservedObject var userVM : UserViewModel
    @Binding var isLoading: Bool
    
    var community: [CommunityDocument]

    var body: some View {
        NavigationView{
            VStack {
                ScrollView{
                    ForEach(community, id: \.self) { data in
                        NavigationLink {
                            CommunityDetailView(communityVM: communityVM, userVM: userVM, community: data)
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

