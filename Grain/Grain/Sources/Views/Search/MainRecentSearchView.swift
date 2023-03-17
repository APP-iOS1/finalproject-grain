//
//  MainRecentSearchView.swift
//  Grain
//
//  Created by 조형구 on 2023/02/09.
//

import SwiftUI
import FirebaseAuth

struct MainRecentSearchView: View {
    @Binding var searchList: [String]
    @ObservedObject var userVM: UserViewModel
    
    var body: some View {
        VStack{
            HStack {
                Text("최근 검색")
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                Spacer()
                
                Button(action: {
                    searchList.removeAll()
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
                        NavigationLink(destination: {
                            
                        }) {
                            Text(userVM.recentSearch[index])
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                            
                        }
                        Spacer()
                        
                        Button(action: {
                            searchList.remove(at: index)
                            var arr = userVM.recentSearch
                            arr.remove(at: index)
                            userVM.updateCurrentUserArray(type: "recentSearch", arr: arr, docID: Auth.auth().currentUser?.uid ?? "")
                        }) {
                            Image(systemName: "multiply")
                                .foregroundColor(.gray)
                            
                        }
                        .frame(alignment: .trailing )
                        
                    }
                    .padding()
                }
            }
        }
        .padding()
        
    }
}

//struct MainRecentSearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainRecentSearchView(searchList: .constant([""]))
//    }
//}
