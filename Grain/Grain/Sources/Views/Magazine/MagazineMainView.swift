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
    @State private var isSearchViewShown: Bool = false
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
            .navigationDestination(isPresented: $isSearchViewShown) {
                MainSearchView(communityViewModel: communityVM, magazineViewModel: magazineVM, userViewModel: userVM)
            }
            .refreshable {
                magazineVM.fetchMagazine()
            }
        }
        .onAppear {
            self.isSearchViewShown = false
         
        }
        .onReceive(userVM.fetchUsersSuccess, perform: { newValue in
            userVM.filterCurrentUsersFollow()
        })
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Text("GRAIN")
                    .font(.title)
                    .bold()
                    .kerning(7)
                
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    self.isSearchViewShown = true
                } label: {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.black)
                }

            }
        }
    }
}

//struct MagazineMainView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack {
//            MagazineMainView()
//        }
//    }
//}
