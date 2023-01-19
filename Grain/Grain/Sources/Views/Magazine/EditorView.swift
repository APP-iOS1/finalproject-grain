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
            //다중이라면 여기 포이치문 필요
            
            //에디터픽 이미지
            Image("test")
                .resizable()
                .frame(width: Screen.maxWidth * 0.8, height: Screen.maxWidth * 0.5)
        }
    }
}



struct EditorView_Previews: PreviewProvider {
    static var previews: some View {
        EditorView()
    }
}
