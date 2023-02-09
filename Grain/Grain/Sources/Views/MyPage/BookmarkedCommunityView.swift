//
//  BookmarkedCommunityView.swift
//  Grain
//
//  Created by 홍수만 on 2023/02/06.
//

import SwiftUI

struct BookmarkedCommunityView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var community: [CommunityDocument]

    var body: some View {
        VStack{
            ScrollView{
                ForEach(community, id: \.self) { data in
                    NavigationLink {
                        CommunityDetailView(community: data)
                    } label: {
                        CommunityRowView(community: data)

                    }
                }
            }
        }
        .navigationTitle("저장된 커뮤니티 글")
        .navigationBarTitleDisplayMode(.inline)
    }
}

//struct BookmarkedCommunityView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack{
//            BookmarkedCommunityView()
//        }
//    }
//}
