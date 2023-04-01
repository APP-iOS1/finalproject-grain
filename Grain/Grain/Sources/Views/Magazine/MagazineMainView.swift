//
//  MagazineMainView.swift
//  Grain
//
//  Created by 조형구 on 2023/01/20.
//

import SwiftUI

import FirebaseAuth

struct MagazineMainView: View {

    @ObservedObject var communityVM : CommunityViewModel
    @ObservedObject var userVM : UserViewModel
    @ObservedObject var magazineVM : MagazineViewModel
    @ObservedObject var editorVM : EditorViewModel

    @State private var selectedIndex: Int = 0
    @State private var selectedFilter = 0
    
    let titles: [String] = ["인기", "실시간"]
    let feedFilter = ["전체보기", "구독자"]
    
    var body: some View {
        NavigationStack {
            VStack{
                HStack{
                    
                    SegmentControlView(items: titles, selection: $selectedIndex, defaultXSpace: 10)
                        .padding(.leading, 9)
                    
                    if selectedIndex == 1 {
                        
                        Picker(selection: $selectedFilter, label: Text("전체보기").fontWeight(.bold)) {
                            ForEach(0 ..< feedFilter.count , id: \.self) {
                                Text(self.feedFilter[$0])
                            }
                        }
                        
                    }
                }
                switch selectedIndex {
                case 0:
                    MagazineBestView(userVM: userVM, magazineVM: magazineVM, editorVM: editorVM)
                    
                default:
                    MagazineFeedView(magazineVM: magazineVM, userVM: userVM, selectedFilter: $selectedFilter)
                }
            }
           
        }
        .refreshable {
            magazineVM.fetchMagazine()
        }
        .onReceive(userVM.fetchUsersSuccess, perform: { newValue in
            userVM.filterCurrentUsersFollow()
        })
     
    }
}

//struct MagazineMainView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack {
//            MagazineMainView()
//        }
//    }
//}
