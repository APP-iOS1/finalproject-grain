//
//  MagazineFeedView.swift
//  Grain
//
//  Created by 조형구 on 2023/01/20.
//

import SwiftUI

struct MagazineFeedView: View {
    @ObservedObject var communityVM = CommunityViewModel()
    @ObservedObject var magazineVM = MagazineViewModel()
    var body: some View {
       
            ScrollView{
                LazyVStack{
//                    ForEach(magazineVM.fetchMagazine()) { i in
//                        VStack{
//                            Text()
//                        }
//                    }
                    
                    Button {
                        magazineVM.insertMagazine(userID: "1", cameraInfo: "2", nickName: "3", image: "4", content: "5", title: "6", lenseInfo: "7", longitude: "8", likedNum: "9", filmInfo: "10", customPlaceName: "11", latitude: "12", comment: "13", roadAddress: "14")
                    } label: {
                        Text("매거진 insert")
                    }
                    Button {
                        magazineVM.fetchMagazine()
                        print(magazineVM.magazines)
                    } label: {
                        Text("매거진 read")
                    }
                    Button {
                        communityVM.insertCommunity(profileImage: "1", nickName: "2", category: "3", image: "4", userID: "5", title: "6", content: "7")
                    } label: {
                        Text("커뮤니티 insert")
                    }
                    Button {
                        communityVM.fetchCommunity()
                        print(communityVM.communities)
                    } label: {
                        Text("커뮤니티 read")
                    }

                }
            } .onAppear {
                print("onAppear 시작")
                magazineVM.fetchMagazine()
                // 0.2부터 가능했음
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
//                    
//                }
                communityVM.fetchCommunity()
            }
        
    }
}

struct MagazineFeedView_Previews: PreviewProvider {
    static var previews: some View {
        MagazineFeedView()
    }
}
