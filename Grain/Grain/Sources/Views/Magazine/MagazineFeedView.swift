//
//  MagazineFeedView.swift
//  Grain
//
//  Created by 조형구 on 2023/01/20.
//

import SwiftUI

struct MagazineFeedView: View {
    var currentUsers : CurrentUserFields?
    @ObservedObject var magazineVM = MagazineViewModel()
    var userVM: UserViewModel
    
    var body: some View {
        ScrollView{
            LazyVStack{
                ForEach(magazineVM.magazines, id: \.self){ data in
                    NavigationLink {
                        // MARK: 피드 뷰 디테일로 넘어가기 index -> fetch해온 데이터
                        MagazineDetailView(isHeartToggle: userVM.isLikedMagazine(magazine: data), isBookMarked: userVM.isBookMarkedMagazine(magazine: data), data: data)
                    } label: {
                        // MARK: fetch해온 데이터 cell뷰로 보여주기
                        MagazineViewCell(data: data)
                    }

                }
            
            }
        }.onAppear{
            // MARK: fetch 데이터 시작
            magazineVM.fetchMagazine()
            
        }
    }
}
//
//struct MagazineFeedView_Previews: PreviewProvider {
//    static var previews: some View {
//        MagazineFeedView()
//    }
//}
