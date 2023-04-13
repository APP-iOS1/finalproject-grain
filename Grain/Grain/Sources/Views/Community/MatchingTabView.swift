//
//  MatchingTabView.swift
//  Grain
//
//  Created by 조형구 on 2023/01/19.
//

import SwiftUI

struct MatchingTabView: View {
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
                        ForEach(communityVM.returnCategoryCommunity(category: "매칭"), id: \.self){ data in
                            NavigationLink {
                                CommunityDetailView(communityVM: communityVM, userVM: userVM, magazineVM: magazineVM, community: data)
                            } label: {
                                CommunityRowView(communityVM: communityVM, community: data)
                            }
                        }
                    }// vstack
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

//struct MatchingTabView_Previews: PreviewProvider {
//    static var previews: some View {
//        MatchingTabView()
//    }
//}
