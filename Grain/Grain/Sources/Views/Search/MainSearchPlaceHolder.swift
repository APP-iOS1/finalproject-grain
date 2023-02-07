//
//  MainSearchPlaceHolder.swift
//  Grain
//
//  Created by 조형구 on 2023/02/08.
//

import SwiftUI

struct MainSearchPlaceHolder: View {
    @Binding var searchWord: String
    
    var body: some View {
        
        ScrollView{
            HStack{
                Text(Image(systemName: "magnifyingglass"))
                    .padding(.leading)
                
                Text("\(searchWord)")
            }
            .padding(.top)
            .frame(width: Screen.maxWidth, alignment: .leading)
            
            Divider()
            
            Text("일치하는 검색어가 없습니다.")
                .bold()
                .foregroundColor(.middleDarkGray)
                .padding()
        }
        .listStyle(.plain)
        
    }
}

struct MainSearchPlaceHolder_Previews: PreviewProvider {
    static var previews: some View {
        MainSearchPlaceHolder(searchWord: .constant(""))
    }
}
