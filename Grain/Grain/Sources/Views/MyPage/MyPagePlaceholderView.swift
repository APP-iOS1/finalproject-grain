//
//  MyPagePlaceholderView.swift
//  Grain
//
//  Created by 조형구 on 2023/04/02.
//

import SwiftUI

struct MyPagePlaceholderView: View {
    @Binding var presented: Bool

    var body: some View {
        VStack{
            Spacer()
            Text("보관하고 싶은 첫번째 기억을 업로드하세요")
                .foregroundColor(.middlebrightGray)
                .font(.footnote)
            
            Button {
                presented.toggle()
            } label: {
                RoundedRectangle(cornerRadius: 10)
//                    .stroke()
                    .foregroundColor(.black)
                    .frame(width: Screen.maxWidth * 0.8, height: 45 )
                    .overlay{
                        Text("업로드")
                            .bold()
                            .foregroundColor(.white)
                         
                            
                    }
            }
            .padding()
            .padding(.top, 5)
            Spacer()
        }
        .frame(height: 250)

    }
}

struct MyPagePlaceholderView_Previews: PreviewProvider {
    static var previews: some View {
        MyPagePlaceholderView(presented: .constant(false))
    }
}
