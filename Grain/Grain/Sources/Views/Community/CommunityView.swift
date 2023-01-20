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
    
    
    private var community: Community = Community(id: "123123", category: 0, userID: "12341234", image: ["sampleImage","1"], title: "피고 놀이 꽃 것은 피가 못할 힘있다", profileImage: "sampleImage", nickName: "희경 센세", location: "방구석TEST", content: "피고 놀이 꽃 것은 피가 못할 힘있다. 풀밭에 장식하는 풀이 새 충분히 운다. 속에서 굳세게 되는 싶이 그들에게 천고에 바이며, 황금시대다. 끝에 이상, 소리다.이것은 그러므로 소금이라 것이다.보라, 봄바람을 역사를 끓는 황금시대다. 할지라도 인생을 끝에 광야에서 것이다. 있을 사라지지 인생의 일월과 철환하였는가? 없으면 그들에게 천자만홍이 이상은 바이며, 같은 두기 봄바람이다. 속에서 청춘은 튼튼하며, 그들의 있을 사라지지 피부가 이것이다. 이상의 천지는 황금시대의 지혜는 있을 것이다", createdAt: Date())
    
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
                        AllTabView(community: community)
                    }
                    
                case .매칭:
                    NavigationStack{
                        MatchingTabView()
                    }
                    
                case .클래스:
                    NavigationStack{
                        ClassTabView(community: community)
                    }
                    
                case .마켓:
                    NavigationStack{
                        MarketTabView(community: community)
                    }
                case .정보:
                    NavigationStack{
                        InfoTabView(community: community)
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
                
                ToolbarItem(placement: .navigationBarTrailing) {

                    NavigationLink(destination: CommunitySearchView()) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.black)
                    }

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
