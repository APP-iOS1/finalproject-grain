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
    
    @Binding var scrollToTop: Bool
    
    let titles: [String] = ["인기", "실시간"]
    let feedFilter = ["전체보기", "구독자"]
    
    var body: some View {
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
                MagazineBestView(userVM: userVM, magazineVM: magazineVM, editorVM: editorVM, scrollToTop: $scrollToTop)
                
            default:
                MagazineFeedView(magazineVM: magazineVM, userVM: userVM, scrollToTop: $scrollToTop, selectedFilter: $selectedFilter)
            }
        }
        .onAppear {
            userVM.fetchCurrentUser(userID: Auth.auth().currentUser?.uid ?? "")
        }
        .onReceive(userVM.fetchCurrentUsersSuccess, perform: {  _ in
            magazineVM.filteringBlockUserCommunity(blockingUsers: userVM.blockingList, blockedUsers: userVM.blockedList)
        })
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
