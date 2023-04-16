//
//  ClassTabView .swift
//  Grain
//
//  Created by 조형구 on 2023/01/19.
//

import SwiftUI

struct ClassTabView: View {
    @ObservedObject var communityVM : CommunityViewModel
    @ObservedObject var userVM : UserViewModel
    @ObservedObject var magazineVM : MagazineViewModel
    @State private var scrollViewOffset: CGFloat = 0
    @State private var startOffset: CGFloat = 0
    
    @Binding var scrollToTop: Bool
    
    var body: some View {
        VStack{
            ScrollViewReader { proxyReader in
                ScrollView(showsIndicators: false){
                    VStack {
                        ForEach(communityVM.returnCategoryCommunity(category: "마켓", blockingUsers: userVM.blockingList, blockedUsers: userVM.blockedList), id: \.self){ data in
                            NavigationLink {
                                CommunityDetailView(communityVM: communityVM, userVM: userVM, magazineVM: magazineVM, community: data)
                            } label: {
                                CommunityRowView(communityVM: communityVM, community: data)
                            }
                        }
                        .emptyPlaceholder(communityVM.returnCategoryCommunity(category: "마켓", blockingUsers: userVM.blockingList, blockedUsers: userVM.blockedList)) {
                           CommunityPlaceHolderView()
                        }
                    }// VStack
                    .id("SCROLL_TO_TOP")
                    .overlay(
                        GeometryReader { proxy -> Color in
                            DispatchQueue.main.async {
                                if startOffset == 0 {
                                    self.startOffset = proxy.frame(in: .global).minY
                                }
                                let offset = proxy.frame(in: .global).minY
                                self.scrollViewOffset = offset - startOffset
                                
                            }
                            return Color.clear
                        }
                            .frame(width: 0, height: 0)
                        ,alignment: .top
                    )
                }
                .refreshable {
                    do {
                        try await Task.sleep(nanoseconds: UInt64(1.6) * 1_000_000_000)
                      } catch {}
                    communityVM.fetchCommunity(nextPageToken: "")
                }
                .onChange(of: scrollToTop, perform: { newValue in
                    withAnimation(.default) {
                        proxyReader.scrollTo("SCROLL_TO_TOP", anchor: .top)
                    }
                })
            }
        }
    }
}

//struct ClassTabView_Previews: PreviewProvider {
//    static var previews: some View {
//        ClassTabView(community: Community(id: "123123", category: 0, userID: "12341234", image: ["sampleImage","1"], title: "피고 놀이 꽃 것은 피가 못할 힘있다", profileImage: "sampleImage", nickName: "희경 센세", location: "방구석TEST", content: "피고 놀이 꽃 것은 피가 못할 힘있다. 풀밭에 장식하는 풀이 새 충분히 운다. 속에서 굳세게 되는 싶이 그들에게 천고에 바이며, 황금시대다. 끝에 이상, 소리다.이것은 그러므로 소금이라 것이다.보라, 봄바람을 역사를 끓는 황금시대다. 할지라도 인생을 끝에 광야에서 것이다. 있을 사라지지 인생의 일월과 철환하였는가? 없으면 그들에게 천자만홍이 이상은 바이며, 같은 두기 봄바람이다. 속에서 청춘은 튼튼하며, 그들의 있을 사라지지 피부가 이것이다. 이상의 천지는 황금시대의 지혜는 있을 것이다", createdAt: Date()))
//    }
//}
