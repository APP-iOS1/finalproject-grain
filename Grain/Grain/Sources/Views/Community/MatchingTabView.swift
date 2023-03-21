//
//  MatchingTabView.swift
//  Grain
//
//  Created by 조형구 on 2023/01/19.
//

import SwiftUI

struct MatchingTabView: View {
    
    @ObservedObject var commentVm: CommentViewModel
    @ObservedObject var communityVM : CommunityViewModel
    @ObservedObject var userVM : UserViewModel
    @ObservedObject var magazineVM : MagazineViewModel
    
    @Binding var isLoading: Bool
    
    var community: [CommunityDocument]

    var body: some View {
        
        VStack {
            ScrollView{
                ForEach(community, id: \.self){ data in
                    NavigationLink {
                        CommunityDetailView(commentVm: commentVm, communityVM: communityVM, userVM: userVM, magazineVM: magazineVM, community: data)
                    } label: {
                        CommunityRowView(commentVm: commentVm, community: data, isLoading: $isLoading)
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
