//
//  EditorView.swift
//  Grain
//
//  Created by 윤소희 on 2023/01/18.
//

import SwiftUI
import Kingfisher

struct EditorViewCell: View {
    @ObservedObject var editorVM : EditorViewModel
    
    let paddingVal = Screen.maxWidth*0.1
    
    func errorImage() -> String{
        var https : String = "https://"
        if let infolist = Bundle.main.infoDictionary {
            if let url = infolist["PreparingImage"] as? String {
                https += url
            }
        }
        return https
    }
    
    var body: some View {
            VStack{
                //에디터픽 이미지
                ZStack{
                
                    Rectangle()
                        .fill(.gray)
                        .frame(width: Screen.maxWidth, height: Screen.maxHeight * 0.5)
                    ForEach(editorVM.editorData, id:\.self){ data in
                        KFImage(URL(string: data.fields.postImage4.stringValue) ?? URL(string: errorImage()))
                            .resizable()
                            .frame(width: Screen.maxWidth, height: Screen.maxHeight * 0.5)
                            .aspectRatio(contentMode: .fill)
                            .overlay(
                                LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0), Color.black.opacity(0), Color.black.opacity(0.3), Color.black.opacity(0.6)]), startPoint: .top, endPoint: .bottom)
                            )
                        VStack(alignment: .leading) {
                            Text(data.fields.thumbnailTitle1.stringValue)
                                .foregroundColor(.white)
                                .font(.title)
                                .fontWeight(.medium)
                            Text(data.fields.thumbnailTitle2.stringValue)
                                .foregroundColor(.white)
                                .font(.title)
                                .fontWeight(.medium)
                            Text(data.fields.thumbnailTitle3.stringValue)
                                .foregroundColor(.white)
                                .font(.title)
                                .fontWeight(.medium)
                        }
                        .padding(.leading, 130)
                        .padding(.top, 210)
//                        .offset(x: 80 ,y: 60)
                    }
                
            }
        }
    }
}

//struct EditorViewCell_Previews: PreviewProvider {
//    static var previews: some View {
//        EditorViewCell()
//    }
//}
