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
    @State private var selectIndexNum: Int = 0
    
    @Binding var selectedFilter : Int
 
    var body: some View {
        VStack {
            ScrollView{
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
                if selectedFilter == 0{
                    ForEach(Array(magazineVM.sortedRecentMagazineData.enumerated()), id: \.1.self){ (index, data) in
                        // MARK: fetch해온 데이터 cell뷰로 보여주기
                        LazyVStack{
                            MagazineViewCell(data: data, userVM: userVM)
                        }
                        .onTapGesture {
                            selectIndexNum = index
                            isMagazineRealtimeViewShown.toggle()
                        }
                    }
                }else{
                    // MARK: 구독자
                    ForEach(Array(userVM.subscriptionFeed(magazineData: magazineVM.sortedRecentMagazineData).enumerated()), id: \.1.self){ (index, data) in
                        // MARK: fetch해온 데이터 cell뷰로 보여주기
                        LazyVStack{
                            MagazineViewCell(data: data, userVM: userVM)
                        }
                    }
                }
                
            }
            .task(id: ObservingChangeValueLikeNum){
                magazineVM.fetchMagazine()
            }
        }
        .navigationDestination(isPresented: $isMagazineRealtimeViewShown){
            ForEach(Array(magazineVM.sortedRecentMagazineData.enumerated()), id: \.1.self){ (index, data) in
                if selectIndexNum == index{
                    MagazineDetailView(magazineVM: magazineVM, userVM: userVM,  data: data, ObservingChangeValueLikeNum: $ObservingChangeValueLikeNum)
                }
            }
        }
        .navigationDestination(isPresented: $isMagazineSubscribeViewShown){
            ForEach(Array(userVM.subscriptionFeed(magazineData: magazineVM.sortedRecentMagazineData).enumerated()), id: \.1.self){ (index, data) in
                if selectIndexNum == index{
                    MagazineDetailView(magazineVM: magazineVM, userVM: userVM,  data: data, ObservingChangeValueLikeNum: $ObservingChangeValueLikeNum)
                }
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
