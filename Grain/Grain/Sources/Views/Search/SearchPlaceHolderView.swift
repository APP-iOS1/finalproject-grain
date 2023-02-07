//
//  SearchPlaceHolderView.swift
//  Grain
//
//  Created by 조형구 on 2023/02/07.
//

import SwiftUI

struct SearchPlaceHolderView: View {
    @Binding var searchWord: String
    
    var body: some View {
        VStack {
            Image(systemName: "camera.badge.ellipsis")
                .font(.system(size: 90))
                .foregroundColor(.brightGray)
                .padding(.bottom)
            Text("이런... 필름이 비어있어요!")
                .font(.title)
                .fontWeight(.heavy)
                .foregroundColor(.black)
                .padding(5)
            HStack{
                Text("' \(searchWord)")
                    .foregroundColor(.middleDarkRed)
                    .font(.title3)
                    .lineLimit(1)
                    .fontWeight(.bold)
                    .padding(-5)
                
                Text("'")
                    .foregroundColor(.middleDarkRed)
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(0)
                
                Text("에 대한 검색결과가 없습니다.")
                    .foregroundColor(.middlebrightGray)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .fixedSize()

            }
            .padding(.top)
            .padding(.bottom, 4)
            .frame( minWidth: .leastNonzeroMagnitude, maxWidth: Screen.maxWidth * 0.8 )
            Text("다른 키워드로 검색해 주세요.")
                .foregroundColor(.middlebrightGray)
                .fontWeight(.semibold)
        }
    }
}

struct SearchPlaceHolderView_Previews: PreviewProvider {
    static var previews: some View {
        SearchPlaceHolderView(searchWord: .constant(""))
    }
}
