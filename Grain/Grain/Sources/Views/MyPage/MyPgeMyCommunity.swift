//
//  MyPgeMyCommunity.swift
//  Grain
//
//  Created by 홍수만 on 2023/04/04.
//

import SwiftUI

struct MyPgeMyCommunity: View {
    @ObservedObject var commentVm =  CommentViewModel() // 임시
    @ObservedObject var communityVM : CommunityViewModel
    @ObservedObject var userVM : UserViewModel
    @ObservedObject var magazineVM : MagazineViewModel
    
    @Binding var isLoading: Bool
    
    @State private var communityDoument: [CommunityDocument] = []
    
    var body: some View {
        VStack{
            ScrollView{
                ForEach(communityDoument.reversed(), id: \.self) { data in
                    NavigationLink {
                        CommunityDetailView(communityVM: communityVM, userVM: userVM, magazineVM: magazineVM, community: data)
                    } label: {
                        CommunityRowView(communityVM: communityVM, community: data, isLoading: $isLoading)
                    }
                }
            }
        }
        .navigationTitle("저장된 커뮤니티 글")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear{
            communityDoument = communityVM.userPostsFilter(communityData: communityVM.communities, userPostedArr: userVM.postedCommunityID)
        }
        .refreshable {
            communityVM.fetchCommunity()
        }
    }
}

//struct MyPgeMyCommunity_Previews: PreviewProvider {
//    static var previews: some View {
//        MyPgeMyCommunity(communityVM: <#CommunityViewModel#>, userVM: <#UserViewModel#>, magazineVM: <#MagazineViewModel#>, isLoading: <#Binding<Bool>#>)
//    }
//}