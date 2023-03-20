//
//  EditorView.swift
//  Grain
//
//  Created by 윤소희 on 2023/01/18.
//

import SwiftUI


struct EditorViewCell: View {
    
    let paddingVal = Screen.maxWidth*0.1
    
    var body: some View {
            VStack{
                //에디터픽 이미지
                ZStack{
                Image("editor")
                    .resizable()
                    .frame(width: Screen.maxWidth, height: Screen.maxHeight * 0.5)
                    .aspectRatio(contentMode: .fit)
                    .overlay(
                        LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0), Color.black.opacity(0), Color.black.opacity(0.3), Color.black.opacity(0.6)]), startPoint: .top, endPoint: .bottom)
                    )
                    VStack(alignment: .leading) {
                        Text("GRAIN 에디터가")
                            .foregroundColor(.white)
                            .font(.title)
                            .fontWeight(.medium)
                        Text("필름에 담은 겨울 제주")
                            .foregroundColor(.white)
                            .font(.title)
                            .fontWeight(.medium)
                        Text(": With WONDER ")
                            .foregroundColor(.white)
                            .font(.title)
                            .fontWeight(.medium)
                    }
                    .offset(x: 80 ,y: 60)
            }
        }
    }
}

struct EditorViewCell_Previews: PreviewProvider {
    static var previews: some View {
        EditorViewCell()
    }
}
