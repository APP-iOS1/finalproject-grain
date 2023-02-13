//
//  UserSearchFeedView.swift
//  Grain
//
//  Created by 조형구 on 2023/02/07.
//

import SwiftUI

struct UserSearchFeedView: View {
    @ObservedObject var magazineViewModel: MagazineViewModel = MagazineViewModel()
    @ObservedObject var userViewModel: UserViewModel = UserViewModel()

    var images: [Image] = [Image("1"), Image("2"), Image("3"), Image("test"), Image("sampleImage"), Image("testImage")]
    
    // 나의 피드를 그리드로 보여줄지 리스트로 보여줄지 선택하는 변수
    @State private var showGridOrList: Bool = true
    
    let columns = [
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1)
    ]
    
    let userD: UserDocument
    
    var body: some View {
        VStack{
            HStack{
                Button{
                    showGridOrList.toggle()
                } label: {
                    Image(systemName: "square.grid.2x2")
                }
                Button{
                    showGridOrList.toggle()
                } label:{
                    Image(systemName: "list.bullet")
                }
                Spacer()
                
            }
            .foregroundColor(.black)
            .font(.title3)
            .padding()
            
            if showGridOrList {
                ScrollView{
                    LazyVGrid(columns: columns, spacing: 1) {
                        ForEach(0..<images.count, id: \.self) { idx in
                            NavigationLink {
                                //이미지에 해당하는 게시글로 이동
                            } label: {
                                images[idx]
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: (Screen.maxWidth / 3 - 1), height: (Screen.maxWidth / 3 - 1))
                                    .clipped()
                            }
                            
                        }
                    }
                }
            } else {
                ScrollView{
                    LazyVStack{
                        ForEach(magazineViewModel.magazines.filter{
                            $0.fields.userID.stringValue == userD.fields.id.stringValue
                        }, id: \.self){ data in
                            NavigationLink {
                                // MARK: 피드 뷰 디테일로 넘어가기 index -> fetch해온 데이터
//                                MagazineDetailView(data: data)
                            } label: {
                                // MARK: fetch해온 데이터 cell뷰로 보여주기
                                MagazineViewCell(data: data)
                            }

                        }
                    
                    }
                }.onAppear{
                    // MARK: fetch 데이터 시작
                    magazineViewModel.fetchMagazine()
//                    userViewModel.fetchUser()
                }
            }
            
        }
    }
}

//struct UserSearchFeedView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserSearchFeedView()
//    }
//}
