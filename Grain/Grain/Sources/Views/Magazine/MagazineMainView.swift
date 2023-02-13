//
//  MagazineMainView.swift
//  Grain
//
//  Created by 조형구 on 2023/01/20.
//

import SwiftUI

import FirebaseAuth

struct MagazineMainView: View {
    @ObservedObject var userViewModel: UserViewModel = UserViewModel()
    @ObservedObject var magazineVM: MagazineViewModel = MagazineViewModel()
    
    @State private var selectedIndex: Int = 0
    @State private var isSearchViewShown: Bool = false
   
    let titles: [String] = ["인기", "피드"]
    
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
                                    .frame(height: 1)
                            }
                        })
                    Spacer()
                }//HS
                switch selectedIndex {
                case 0:
                    MagazineBestView(magazineVM: magazineVM, userVM: userViewModel, currentUsers: userViewModel.currentUsers)
                default:
                    MagazineFeedView(currentUsers: userViewModel.currentUsers, userVM: userViewModel)
                }
            }
            .navigationDestination(isPresented: $isSearchViewShown) {
                MainSearchView()
            }
        }
        .onAppear {
            self.isSearchViewShown = false
            print("메인 뷰 ")
            userViewModel.fetchCurrentUser(userID: Auth.auth().currentUser?.uid ?? "")
            //            magazineVM.fetchMagazine()
        }
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
