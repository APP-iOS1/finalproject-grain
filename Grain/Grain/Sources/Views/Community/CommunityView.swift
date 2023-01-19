//
//  CommunityView.swift
//  Grain
//
//  Created by 박희경 on 2023/01/18.
//

import SwiftUI
// TODO
// [x] detail view
// [x] homeview 1 2
// [x] homeview detail
// [x] chatting view / chatting
// [x]

struct CommunityView: View {
    enum SelectCategory: String, CaseIterable {
        case 전체
        case 매칭
        case 마켓
        case 클래스
        case 정보
    }
    
    @State private var isSelectedCategory: SelectCategory = .전체
    
    
    private var community: Community = Community(id: "123123", category: 0, userID: "12341234", image: ["camera"], title: "title입니다", profileImage: "person", nickName: "희경 센세", location: "광화문", content: "testing...", createdAt: Date())
    
    var body: some View {
        NavigationStack{
            VStack{
                HStack{
                    ForEach(SelectCategory.allCases, id: \.rawValue) { category in
                        Text("\(category.rawValue)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(isSelectedCategory == category ? .black : .gray)
                            .onTapGesture {
                                self.isSelectedCategory = category
                            }
                            .padding(.horizontal, 10 )
                    }
                }.padding(.top, 15)
                
                
                switch isSelectedCategory {
                case .전체:
                    NavigationStack{
                        AllTabView()
                    }
                    
                case .매칭:
                    NavigationStack{
                        MatchingTabView()
                    }
                    
                case .클래스:
                    NavigationStack{
                        ClassTabView()
                    }
                    
                case .마켓:
                    NavigationStack{
                        MarketTabView()
                    }
                case .정보:
                    NavigationStack{
                        InfoTabView()
                    }
                }
                
                //                ScrollView{
                //                    ForEach(0...5, id: \.self) {idx in
                //                        NavigationLink(value: community){
                //                            CommunityRowView(community: community)
                //                        }
                //                    }
                //                }
                //                .navigationDestination(for: Community.self) { Community in
                //                    CommunityDetailView(community: Community)
                //                }
                //                //            .onAppear{
                //                //                communityStore.fetchCommunities()
                //                //            }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("GRAIN")
                        .font(.title)
                        .bold()
                        .kerning(7)
                }
            }
        }
    }
}

struct CommunityView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityView()
    }
}
