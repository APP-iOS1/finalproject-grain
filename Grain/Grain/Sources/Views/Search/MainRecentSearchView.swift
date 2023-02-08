//
//  MainRecentSearchView.swift
//  Grain
//
//  Created by 조형구 on 2023/02/09.
//

import SwiftUI

struct MainRecentSearchView: View {
    @Binding var searchList: [String]
    
    var body: some View {
        VStack{
            HStack {
                Text("최근 검색어")
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                Spacer()
                
                Button(action: {
                    searchList.removeAll()
                }) {
                    Text("전체삭제")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .padding(.bottom, 0)
            ForEach(0..<searchList.count, id: \.self) { index in
                HStack {
                    NavigationLink(destination: {
                        
                    }) {
                        Text(searchList[index])
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        
                    }
                    Spacer()
                    
                    Button(action: {
                        searchList.remove(at: index)
                    }) {
                        Image(systemName: "multiply")
                            .foregroundColor(.gray)
                        
                    }
                    .frame(alignment: .trailing )
                    
                }
                .padding()
            }
            
        }
        .padding()
        
    }
}

struct MainRecentSearchView_Previews: PreviewProvider {
    static var previews: some View {
        MainRecentSearchView(searchList: .constant([""]))
    }
}
