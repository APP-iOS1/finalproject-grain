//
//  MagazineBestView.swift
//  Grain
//
//  Created by 윤소희 on 2023/01/18.
//

import SwiftUI
import FirebaseAuth

struct MagazineBestView: View {
    @StateObject var magazineVM = MagazineViewModel()
    var userVM: UserViewModel
    
    var currentUsers : CurrentUserFields?
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    NavigationLink {
                        EditorView()
                    } label: {
                        EditorViewCell()
                    }
                    HStack{
                        Text("인기 게시글")
                            .font(.title)
                            .fontWeight(.bold)
                        Image("line")
                            .resizable()
                            .frame(width: 240, height: 3.5)
                    }
                    .padding([.leading, .top])
                    ForEach(magazineVM.magazines, id: \.self ){ data in
                        NavigationLink {
                            MagazineDetailView(isHeartToggle: userVM.isLikedMagazine(magazine: data), isBookMarked: userVM.isBookMarkedMagazine(magazine: data), data: data)
                        } label: {
                            Top10View(data: data)
                                .padding(.vertical, 7)
                                .padding(.horizontal)
                                .frame(height: Screen.maxHeight * 0.6)
                            
                        }
                    }
                    
//                    4: 3 비율 -=> 가로 40  세로 30

                    // 4: 3 비율로 올린 사진이 가로일수도 있고, 새로일수도있거든요 ?
                    
                } // scroll view
            }//vstack
            .onAppear{
//                userVM.fetchCurrentUser(userID: Auth.auth().currentUser?.uid ?? "")
                magazineVM.fetchMagazine()
            }
        }
    }
}
//struct MagazineBestView_Previews: PreviewProvider {
//    static var previews: some View {
//        MagazineBestView()
//    }
//}
