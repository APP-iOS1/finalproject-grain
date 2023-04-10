//
//  MainRecentSearchView.swift
//  Grain
//
//  Created by 조형구 on 2023/02/09.
//

import SwiftUI
import FirebaseAuth

struct MainRecentSearchView: View {
    @ObservedObject var userVM: UserViewModel
    @Binding var selectedIndex: Int
    @Binding var searchWord: String
    @Binding var isMagazineSearchResultShown: Bool
    @Binding var isCommunitySearchResultShown: Bool
    @Binding var isUserSearchResultShown: Bool
    
    var body: some View {
        VStack{
            HStack {
                Text("최근 검색")
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                Spacer()
                
                Button(action: {
                    let arr: [String] = [""]
                    userVM.updateCurrentUserArray(type: "recentSearch", arr: arr, docID: Auth.auth().currentUser?.uid ?? "")
                }) {
                    Text("전체삭제")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .padding(.bottom, 0)
            if userVM.recentSearch.count > 1 {
                ForEach(1..<userVM.recentSearch.count, id: \.self) { index in
                    HStack {
                        Button {
                            searchWord = "\(userVM.recentSearch[index])"
                            if selectedIndex == 0 {
                                self.isMagazineSearchResultShown.toggle()
                            }else if selectedIndex == 1 {
                                self.isCommunitySearchResultShown.toggle()
                            }else {
                                self.isUserSearchResultShown.toggle()
                            }
                            
                            if let user = userVM.currentUsers {
                                if userVM.recentSearch.contains(where: { $0 == self.searchWord }) {
                                    // 이미 검색한 검색어이면 배열에서 먼저 이미 있는 값 삭제
                                    if let index = userVM.recentSearch.firstIndex(of: self.searchWord) {
                                        userVM.recentSearch.remove(at: index)
                                    }
                                }
                                // 배열의 첫번째 인덱스에 넣어준다.
                                // 1 index 에 넣는 이유는 0번째 인덱스가 "" 로 초기화 되어있기 때문.
                                userVM.recentSearch.insert(self.searchWord, at: 1)
                                userVM.updateCurrentUserArray(type: "recentSearch", arr: userVM.recentSearch, docID: user.id.stringValue)
                            }
                        } label: {
                            Text(userVM.recentSearch[index])
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                        }
                        Spacer()
                        
                        Button(action: {
                            var arr = userVM.recentSearch
                            arr.remove(at: index)
                            userVM.updateCurrentUserArray(type: "recentSearch", arr: arr, docID: Auth.auth().currentUser?.uid ?? "")
                            
                        }) {
                            Image(systemName: "multiply")
                                .foregroundColor(.gray)
                            
                        }
                        .frame(alignment: .trailing )
                        
                    }//hstack
                    .padding()
                }// ForEach
            }
        }
        .onReceive(userVM.updateUsersArraySuccess, perform: { _ in
            userVM.fetchCurrentUser(userID: Auth.auth().currentUser?.uid ?? "")
        })
        .padding()
    }
}

