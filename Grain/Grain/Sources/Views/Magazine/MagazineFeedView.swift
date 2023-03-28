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
    
    @Binding var selectedFilter : Int
    
    var body: some View {
        VStack {
            ScrollView{
                // MARK: 전체보기
                if selectedFilter == 0{
                    ForEach(magazineVM.sortedRecentMagazineData, id: \.self){ data in
                        NavigationLink {
                            // MARK: 피드 뷰 디테일로 넘어가기 index -> fetch해온 데이터
                            MagazineDetailView(magazineVM: magazineVM, userVM: userVM,  data: data, ObservingChangeValueLikeNum: $ObservingChangeValueLikeNum)
                        } label: {
                            // MARK: fetch해온 데이터 cell뷰로 보여주기
                            LazyVStack{
                                MagazineViewCell(data: data, userVM: userVM)
                            }
                        }
                    }
                }else{
                    // MARK: 구독자
                    ForEach(userVM.subscriptionFeed(magazineData: magazineVM.sortedRecentMagazineData), id: \.self){ data in
                        NavigationLink {
                            // MARK: 피드 뷰 디테일로 넘어가기 index -> fetch해온 데이터
                            MagazineDetailView(magazineVM: magazineVM, userVM: userVM,  data: data, ObservingChangeValueLikeNum: $ObservingChangeValueLikeNum)
                        } label: {
                            // MARK: fetch해온 데이터 cell뷰로 보여주기
                            LazyVStack{
                                MagazineViewCell(data: data, userVM: userVM)
                            }
                        }
                    }
                }
            
            }
            .task(id: ObservingChangeValueLikeNum){
                 magazineVM.fetchMagazine()
            }
        }

    }
}
//
//struct MagazineFeedView_Previews: PreviewProvider {
//    static var previews: some View {
//        MagazineFeedView()
//    }
//}
