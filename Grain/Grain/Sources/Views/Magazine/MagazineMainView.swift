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
   
    let titles: [String] = ["인기", "실시간"]
    
    var body: some View {
        NavigationStack {
            VStack{
                HStack {
                    SegmentedPicker(
                        titles,
                        selectedIndex: Binding(
                            get: { selectedIndex },
                            set: { selectedIndex = $0 ?? 0 }),
                        content: { item, isSelected in
                            Text(item)
                                .foregroundColor(isSelected ? Color.black : Color.gray )
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .font(.title3)
                                .bold()
                        },
                        selection: {
                            VStack(spacing: 0) {
                                Spacer()
                                Rectangle()
                                    .fill(Color.black)
                                    .frame(height: 2)
                                    .transition(.slide)
                                    .animation(.easeInOut, value: selectedIndex)
                            }
                        })
                    Spacer()
                }//HS
                .padding(.leading)
                switch selectedIndex {
                case 0:
                    MagazineBestView(userVM: userVM, magazineVM: magazineVM, editorVM: editorVM)
                    
                default:
                    MagazineFeedView(magazineVM: magazineVM, userVM: userVM)
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
