//
//  InfoTabView.swift
//  Grain
//
//  Created by 조형구 on 2023/01/19.
//

import SwiftUI

struct InfoTabView: View {
    
    var community: [CommunityDTO]
    
    var body: some View {
        VStack {
            ScrollView{
                ForEach(community, id: \.self){ data in
                    NavigationLink {
                        CommunityDetailView(community: data)
                    } label: {
                        CommunityRowView2(community: data)
                    }
                }
            }
        }// vstack
    }
}

//struct InfoTabView_Previews: PreviewProvider {
//    static var previews: some View {
//        InfoTabView()
//    }
//}
