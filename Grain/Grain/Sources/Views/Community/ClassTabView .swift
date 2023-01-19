//
//  ClassTabView .swift
//  Grain
//
//  Created by 조형구 on 2023/01/19.
//

import SwiftUI

struct ClassTabView: View {
    private var community: Community = Community(id: "123123", category: 0, userID: "12341234", image: ["camera"], title: "title입니다", profileImage: "person", nickName: "희경 센세", location: "방구석", content: "testing...", createdAt: Date())
    
    var body: some View {
        VStack {
            ScrollView{
                ForEach(0...5, id: \.self) {idx in
                    NavigationLink(value: community){
                        CommunityRowView(community: community)
                    }
                }
            }
            .navigationDestination(for: Community.self) { Community in
                CommunityDetailView(community: Community)
            }
        }
    }
}

struct ClassTabView_Previews: PreviewProvider {
    static var previews: some View {
        ClassTabView()
    }
}
