//
//  MagazineFeedView.swift
//  Grain
//
//  Created by 조형구 on 2023/01/20.
//

import SwiftUI

struct MagazineFeedView: View {
//    @ObservedObject var magazineVM: MagazineViewModel = MagazineViewModel()
    
    let currentUsers : CurrentUserFields?
    let userVM: UserViewModel
    let magazineVM: MagazineViewModel
    
    var recentMagazines: [MagazineDocument] = []
    
    var body: some View {
        VStack {
            ScrollView{
             
                ForEach(magazineVM.sortedRecentMagazineData, id: \.self){ data in
                    NavigationLink {
                        // MARK: 피드 뷰 디테일로 넘어가기 index -> fetch해온 데이터
                        MagazineDetailView(userVM: userVM, currentUsers: currentUsers, data: data)
                    } label: {
                        // MARK: fetch해온 데이터 cell뷰로 보여주기
                        MagazineViewCell(data: data)
                    }
                    
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
