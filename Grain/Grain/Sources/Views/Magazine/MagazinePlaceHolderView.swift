//
//  MagazinePlaceHolderView.swift
//  Grain
//
//  Created by 홍수만 on 2023/04/16.
//

import SwiftUI

struct MagazinePlaceHolderView: View {
    var body: some View {
        VStack {
            Image(systemName: "film")
                .font(.system(size: 70))
                .foregroundColor(.brightGray)
            HStack{
                Text("아직 작성된 피드가 없어요")
                    .foregroundColor(.middlebrightGray)
                    .fontWeight(.semibold)
                    .lineLimit(1)
            }
            .padding(.top)
            .padding(.bottom, 4)
            .frame( minWidth: .leastNonzeroMagnitude, maxWidth: Screen.maxWidth * 0.8 )
            Text("피드를 업로드 해주세요:)")
                .foregroundColor(.middlebrightGray)
                .fontWeight(.semibold)
        }
        .frame(height: 550)
    }
}

struct MagazinePlaceHolderView_Previews: PreviewProvider {
    static var previews: some View {
        MagazinePlaceHolderView()
    }
}
