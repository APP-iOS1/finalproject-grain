//
//  EditorView.swift
//  Grain
//
//  Created by 윤소희 on 2023/01/18.
//

import SwiftUI


struct EditorView: View {
    
    let paddingVal = Screen.maxWidth*0.1
    
    var body: some View {
        VStack{
            HStack{
                Text("작성자 자리")
                Spacer()
            }
            .padding(.horizontal, paddingVal)
            //다중이라면 여기 포이치문 필요
            Image("test")
                .resizable()
                .frame(width: Screen.maxWidth*0.8, height: Screen.maxWidth*0.6)
            HStack{
                Button {
                    
                } label: {
                    Image(systemName: "heart")
                }
                
                Button {
                    
                } label: {
                    Image(systemName: "bubble.right")
                }
                Spacer()
            }
            .padding(.horizontal, paddingVal)
            
            Text("에디터픽의 테스트용 텍스트")
                .font(.title3)
        }
    }
}



struct EditorView_Previews: PreviewProvider {
    static var previews: some View {
        EditorView()
    }
}
