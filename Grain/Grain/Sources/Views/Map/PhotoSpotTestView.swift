//
//  PhotoSpotTestView.swift
//  Grain
//
//  Created by 지정훈 on 2023/02/03.
//

import SwiftUI

struct PhotoSpotTestView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
//                            .stroke(Color(.black),lineWidth: 2)
            .foregroundColor(.white)
            .frame(width: 50, height: 51)
            .overlay{
                Image(systemName: "location.magnifyingglass")
                    .onTapGesture {
                        // 액션
                    }
            }
    }
}

struct PhotoSpotTestView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoSpotTestView()
    }
}
