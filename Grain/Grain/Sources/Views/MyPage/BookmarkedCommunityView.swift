//
//  BookmarkedCommunityView.swift
//  Grain
//
//  Created by 홍수만 on 2023/02/06.
//

import SwiftUI


struct BookmarkedCommunityView: View {
    
    @ObservedObject var commentVm =  CommentViewModel() // 임시
    @ObservedObject var communityVM : CommunityViewModel
    @ObservedObject var userVM : UserViewModel
    @ObservedObject var magazineVM : MagazineViewModel
    
    @Binding var isLoading: Bool
    
//    @Environment(\.presentationMode) var presentationMode
    
    
    @State private var bookmarkedCommunityDoument: [CommunityDocument] = []
    
    var body: some View {
        VStack{
            ScrollView{
                ForEach(bookmarkedCommunityDoument.reversed(), id: \.self) { data in
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
            bookmarkedCommunityDoument = communityVM.userBookmarkedCommunityFilter(communityData: communityVM.communities, userBookmarkedCommunityArr: userVM.bookmarkedCommunityID)
        }
        .refreshable {
            communityVM.fetchCommunity()
        }
    }
}

//struct BookmarkedCommunityView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack{
//            BookmarkedCommunityView()
//        }
//    }
//}
