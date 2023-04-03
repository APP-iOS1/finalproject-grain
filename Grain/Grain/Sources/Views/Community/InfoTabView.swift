//
//  InfoTabView.swift
//  Grain
//
//  Created by 조형구 on 2023/01/19.
//

import SwiftUI

struct InfoTabView: View {

    @ObservedObject var communityVM : CommunityViewModel
    @ObservedObject var userVM : UserViewModel
    @ObservedObject var magazineVM : MagazineViewModel
    
    @Binding var isLoading: Bool
    
    
    var body: some View {
        VStack {
            ScrollView{
                ForEach(communityVM.returnCategoryCommunity(category: "정보"), id: \.self){ data in
                    NavigationLink {
                        CommunityDetailView(communityVM: communityVM, userVM: userVM, magazineVM: magazineVM, community: data)
                    } label: {
                        CommunityRowView(communityVM: communityVM, community: data, isLoading: $isLoading)
                    }
                }
            }
        }.onAppear{
         
        }
        .refreshable {
            communityVM.fetchCommunity()
        }
        
    }
}

//struct InfoTabView_Previews: PreviewProvider {
//    static var previews: some View {
//        InfoTabView()
//    }
//}
