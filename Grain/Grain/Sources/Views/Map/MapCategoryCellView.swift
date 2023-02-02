//
//  MapCategoryCellView.swift
//  Grain
//
//  Created by 조형구 on 2023/01/18.
//

import SwiftUI

struct MapCategoryCellView: View {
    
    // MARK: 카테고리 종류 리스트
    // category -> 0: 포토스팟 / 1: 현상소 / 2: 수리점
    let categoryList : [String] = ["전체","포토스팟", "현상소", "수리점"]
    @Binding var categoryString : String
    
    // MARK: 오버레이
    let style = StrokeStyle(lineWidth: 2,
                            lineCap: .round)
    var body: some View {
        // MARK: 카테고리 버튼
        ForEach(categoryList, id: \.self){ index in
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.white)
                .frame(width: 69, height: 40)
                .overlay{
                    Button {
                        categoryString = index
                    } label: {
                        // categoryList 안에 있는 카테고리를 버튼을 만들어줌
                        Text(index)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            
                    }
                }
            
        }
    }
}
