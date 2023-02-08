//
//  MagazineViewCell.swift
//  Grain
//
//  Created by 조형구 on 2023/01/20.
//

import SwiftUI
import Kingfisher

struct MagazineViewCell: View {
    var data : MagazineDocument
    var body: some View {
        VStack {
            HStack {
                Circle()
                    .frame(width: 40)
                    .foregroundColor(.black)
                VStack(alignment: .leading) {
                    Text(data.fields.nickName.stringValue)
                        .bold()
                        .foregroundColor(.black)
                    
                    HStack {
                        Text("1분전")
                            .foregroundColor(.black)
                        Spacer()
                        Text(data.fields.customPlaceName.stringValue)
                            .foregroundColor(.black)
                    }
                    .font(.caption)
                }
                
                Spacer()
                
            }
            .padding()
            
            Divider()
                .frame(maxWidth: Screen.maxWidth * 0.9)
                .background(Color.black)
                .padding(.top, -5)
                .padding(.bottom, -10)
            
            //            Image("line")
            //                .resizable()
            //                .frame(width: Screen.maxWidth, height: 0.3)
            TabView{
                ForEach(data.fields.image.arrayValue.values, id: \.self) { item in
                    KFImage(URL(string: item.stringValue) ?? URL(string:"https://cdn.travie.com/news/photo/202108/21951_11971_5847.jpg"))
                       .resizable()
                       .aspectRatio(contentMode: .fit)
                       .frame(width: 100)
                }
            }
            .tabViewStyle(.page)
            .frame(maxHeight: Screen.maxHeight * 0.27)
            .padding()
            Group{
                HStack{
                    Text(data.fields.title.stringValue)
                        .foregroundColor(.black)
                        .font(.title2)
                        .bold()
                    
                    Spacer()
                }
                .padding(.vertical, -30)
                
                Text(data.fields.content.stringValue)
                    .lineLimit(2)
                    .padding(.vertical, -30)
                    .foregroundColor(Color.textGray)
                
            }
            .padding()
            
            Spacer()
        }
        .frame(height: Screen.maxHeight * 0.5)
    }
}

//struct MagazineViewCell_Previews: PreviewProvider {
//    static var previews: some View {
//        MagazineViewCell()
//    }
//}
