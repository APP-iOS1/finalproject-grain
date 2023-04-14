//
//  CommunityPlaceHolderView.swift
//  Grain
//
//  Created by 조형구 on 2023/04/14.
//

import SwiftUI

struct CommunityPlaceHolderView: View {
    var body: some View {
        VStack {
            Image(systemName: "text.bubble")
                .font(.system(size: 70))
                .foregroundColor(.brightGray)
            HStack{
                Text("아직 작성된 글이 없어요")
                    .foregroundColor(.middlebrightGray)
                    .fontWeight(.semibold)
                    .lineLimit(1)
            }
            .padding(.top)
            .padding(.bottom, 4)
            .frame( minWidth: .leastNonzeroMagnitude, maxWidth: Screen.maxWidth * 0.8 )
            Text("글을 업로드 해주세요:)")
                .foregroundColor(.middlebrightGray)
                .fontWeight(.semibold)
        }
        .frame(height: 550)
    }
}

struct CommunityPlaceHolderView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityPlaceHolderView()
    }
}
