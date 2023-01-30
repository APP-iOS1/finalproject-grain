//
//  MagazineFeedView.swift
//  Grain
//
//  Created by 조형구 on 2023/01/20.
//

import SwiftUI

struct MagazineFeedView: View {
    @ObservedObject var communityVM = CommunityViewModel()
    var body: some View {
       
            ScrollView{
                LazyVStack{
//                    ForEach(0..<4) { i in
//                        NavigationLink {
//                            MagazineDetailView()
//                        } label: {
//                            MagazineViewCell()
//                        }
//    //                    Divider()
//                    }
                    
                    Button {
                        print(communityVM.communities)
                    } label: {
                        Text("테스투")
                    }

                }
            } .onAppear {
                print("onAppear 시작")
                communityVM.fetchCommunity()
            }
        
    }
}

struct MagazineFeedView_Previews: PreviewProvider {
    static var previews: some View {
        MagazineFeedView()
    }
}
