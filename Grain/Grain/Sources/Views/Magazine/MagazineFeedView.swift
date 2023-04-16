//
//  MagazineFeedView.swift
//  Grain
//
//  Created by 조형구 on 2023/01/20.
//

import SwiftUI
import FirebaseAuth

struct MagazineFeedView: View {
    @ObservedObject var magazineVM: MagazineViewModel
    @ObservedObject var userVM: UserViewModel
    
    @State var ObservingChangeValueLikeNum : String = ""
    @State private var isMagazineRealtimeViewShown: Bool = false
    @State private var isMagazineSubscribeViewShown: Bool = false
    @State private var scrollViewOffset: CGFloat = 0
    @State private var startOffset: CGFloat = 0
    
    @Binding var scrollToTop: Bool
    @Binding var selectedFilter : Int
 
    var body: some View {
        VStack{
            ScrollViewReader { proxyReader in
                ScrollView(showsIndicators: false){
                    VStack{
                        
                        // magazine fetch 된 시간 알려주는 부분
                        HStack{
                            Text("\(Image(systemName: "info.circle")) 기준 시간: \(magazineVM.currentTime.getFormattedTime(from: magazineVM.currentTime))")
                                .font(.footnote)
                                .foregroundColor(.middlebrightGray)
                            Spacer()
                            
                        }
                        .padding(.horizontal)
                        .padding(.top, 13)
                        .padding(.bottom, -8)
                        
                        // MARK: 전체보기
                        if selectedFilter == 0 {
                            ForEach(Array(magazineVM.sortedRecentMagazineData.enumerated()), id: \.1.self){ (index, data) in
                                // MARK: fetch해온 데이터 cell뷰로 보여주기
                                NavigationLink {
                                    MagazineDetailView(magazineVM: magazineVM, userVM: userVM,  data: data, ObservingChangeValueLikeNum: $ObservingChangeValueLikeNum)

                                } label: {
                                    LazyVStack{
                                        MagazineViewCell(data: data, userVM: userVM)
                                    }
                                }
                            }
                            .emptyPlaceholder(Array(magazineVM.sortedRecentMagazineData.enumerated())) {
                                MagazinePlaceHolderView()
                            }
                        }else{
                            // MARK: 구독자
                            ForEach(Array(userVM.subscriptionFeed(magazineData: magazineVM.sortedRecentMagazineData).enumerated()), id: \.1.self){ (index, data) in
                                // MARK: fetch해온 데이터 cell뷰로 보여주기
                                NavigationLink {
                                    MagazineDetailView(magazineVM: magazineVM, userVM: userVM,  data: data, ObservingChangeValueLikeNum: $ObservingChangeValueLikeNum)
                                } label: {
                                    LazyVStack{
                                        MagazineViewCell(data: data, userVM: userVM)
                                    }
                                }
                            }
                            .emptyPlaceholder(Array(userVM.subscriptionFeed(magazineData: magazineVM.sortedRecentMagazineData).enumerated())) {
                                MagazinePlaceHolderView()
                            }
                        }
                        
                    }
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
                .onAppear{
                    UITableView.appearance().separatorStyle = .none
                }
                .onChange(of: scrollToTop, perform: { newValue in
                    withAnimation(.default) {
                        proxyReader.scrollTo("SCROLL_TO_TOP", anchor: .top)
                    }
                })
                .onChange(of: ObservingChangeValueLikeNum, perform: { newValue in
                    magazineVM.fetchMagazine(nextPageToken: "")
                })
                .onReceive(magazineVM.fetchMagazineSuccess, perform: { _ in
                    magazineVM.filteringBlockUserCommunity(blockingUsers: userVM.blockingList, blockedUsers: userVM.blockedList)
                })
                .refreshable {
                    do {
                        try await Task.sleep(nanoseconds: UInt64(1.6) * 1_000_000_000)
                      } catch {}
                    magazineVM.fetchMagazine(nextPageToken: "")
                }
               
            }
            Spacer()
        }
        
    }
}
//
//struct MagazineFeedView_Previews: PreviewProvider {
//    static var previews: some View {
//        MagazineFeedView()
//    }
//}

