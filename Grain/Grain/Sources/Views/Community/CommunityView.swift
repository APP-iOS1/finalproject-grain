//
//  CommunityView.swift
//  Grain
//
//  Created by 박희경 on 2023/01/18.
//

import SwiftUI

struct CommunityView: View {
//    @StateObject var communityStore: CommunityStore = CommunityStore()
    
    let titles: [String] = ["전체", "매칭", "마켓", "수업"]
    @State var selectedIndex: Int = 0
    
    var community: Community = Community(id: "123123", category: 0, userID: "12341234", image: ["camera"], title: "title입니다", profileImage: "person", nickName: "희경 센세", location: "방구석", content: "testing...", createdAt: Date())
    
    var body: some View {
        NavigationStack{
            VStack{
                SegmentedPicker(
                    titles,
                    selectedIndex: Binding(
                        get: { selectedIndex },
                        set: { selectedIndex = $0 ?? 0 }),
                    content: { item, isSelected in
                        Text(item)
                            .foregroundColor(isSelected ? Color.black : Color.gray )
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .font(.title)
                            .bold()
                    },
                    selection: {
                        VStack(spacing: 0) {
                            Spacer()
                            Rectangle()
                                .fill(Color.black)
                                .frame(height: 1)
                        }
                    })
                .animation(.easeInOut(duration: 0.3))
                
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
                //            .onAppear{
                //                communityStore.fetchCommunities()
                //            }
            }
            .navigationTitle("Grain")
        }
    }
}

struct CommunityView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityView()
    }
}
