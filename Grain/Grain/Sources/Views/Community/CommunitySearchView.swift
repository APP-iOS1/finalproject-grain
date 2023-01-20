//
//  CommunitySearchView.swift
//  Grain
//
//  Created by 박희경 on 2023/01/18.
//

import SwiftUI

struct CommunitySearchView: View {
    @State private var searchWord: String = ""
    
    @State var searchList: [String] =  ["카메라", "명소", " 출사"]
    
    var body: some View {
        VStack{
            VStack{
                HStack{
                    TextField("검색어를 입력하세요", text: $searchWord)
                    
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                }
                .padding()
                
                Rectangle()
                    .frame(width: Screen.maxWidth, height: 1.5)
                    .foregroundColor(.black)
            }
            
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
                                .padding(20)
                        }
                        
                    }
                    .padding(.horizontal)
                }
                
            }
            .padding()
            
            Spacer()
        }
    }
}

struct CommunitySearchView_Previews: PreviewProvider {
    static var previews: some View {
        CommunitySearchView()
    }
}



