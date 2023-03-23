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
    @ObservedObject var magazineVM : MagazineViewModel
    
    @Binding var isLoading: Bool
    
    var body: some View {
        NavigationView{
            VStack {
                ScrollView{
                    ForEach(communityVM.sortedRecentCommunityData, id: \.self) { data in
                        NavigationLink {
                            CommunityDetailView(communityVM: communityVM, userVM: userVM, magazineVM: magazineVM, community: data)
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

