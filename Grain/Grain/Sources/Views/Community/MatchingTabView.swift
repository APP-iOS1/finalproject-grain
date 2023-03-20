//
//  MatchingTabView.swift
//  Grain
//
//  Created by 조형구 on 2023/01/19.
//

import SwiftUI

struct MatchingTabView: View {
    
    @ObservedObject var communityVM : CommunityViewModel
    @ObservedObject var userVM : UserViewModel
    @Binding var isLoading: Bool
    
    var community: [CommunityDocument]

    var body: some View {
        
        VStack {
            ScrollView{
                ForEach(community, id: \.self){ data in
                    NavigationLink {
                        CommunityDetailView(communityVM: communityVM, userVM: userVM, community: data)
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

//struct MatchingTabView_Previews: PreviewProvider {
//    static var previews: some View {
//        MatchingTabView()
//    }
//}
