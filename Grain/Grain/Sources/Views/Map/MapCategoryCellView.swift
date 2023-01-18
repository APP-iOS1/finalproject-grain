//
//  MapCategoryCellView.swift
//  Grain
//
//  Created by 지정훈 on 2023/01/18.
//

import SwiftUI

struct MapCategoryCellView: View {
    
    // MARK: 카테고리 종류 리스트
    let categoryList : [String] = ["포토스팟", "현상소", "수리점"]
    
    // MARK: 오버레이
    let style = StrokeStyle(lineWidth: 2,
                            lineCap: .round)
    
    var body: some View {
        // MARK: 카테고리 버튼
        ForEach(categoryList, id: \.self){ index in
            Button {
                // 카테고리 버튼 클릭시 액션 넣어주면 될듯
                print("\(index) 클릭됨")
            } label: {
                // categoryList 안에 있는 카테고리를 버튼을 만들어줌
                Text(index)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    
            }.padding(5)    // 글자와 주변 선의 간격을 떨어트림
            .overlay {
                // MARK: 텍스트에 주변에 선 만들기
                RoundedRectangle(cornerRadius: 5)
                    .stroke(style: style)
            }

        }.padding(.trailing)    // 버튼끼리 패딩 값을 주어 서로 사이를 떨어트림
    }
}

//struct MapCategoryCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapCategoryCellView()
//    }
//}
