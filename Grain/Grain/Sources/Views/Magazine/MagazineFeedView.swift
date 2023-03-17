//
//  MagazineFeedView.swift
//  Grain
//
//  Created by 조형구 on 2023/01/20.
//

import SwiftUI

struct MagazineFeedView: View {

    @ObservedObject var magazineVM: MagazineViewModel

    let currentUsers : CurrentUserFields?
    let userVM: UserViewModel

    @State var updateNum : String = ""
    var body: some View {
        VStack {
            ScrollView{
                ForEach(magazineVM.sortedRecentMagazineData, id: \.self){ data in
                    NavigationLink {
                        // MARK: 피드 뷰 디테일로 넘어가기 index -> fetch해온 데이터
                        MagazineDetailView(magazineVM: magazineVM, userVM: userVM, currentUsers: currentUsers, data: data, updateNum: $updateNum)
                    } label: {
                        // MARK: fetch해온 데이터 cell뷰로 보여주기
                        LazyVStack{
                            MagazineViewCell(data: data)
                        }
                    }
                    .task(id: updateNum){
                        Task{
                            await magazineVM.fetchMagazine()
                            print(data.fields.likedNum.integerValue)
                        }
                    }
                }

            }
            .onAppear{
                print("ScrollView 실행")
                magazineVM.fetchMagazine()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    for i in magazineVM.sortedRecentMagazineData{
                        print(i.fields.likedNum.integerValue)
                    }
                    print("--------------------")
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
