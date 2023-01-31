//
//  MagazineViewCell.swift
//  Grain
//
//  Created by 조형구 on 2023/01/20.
//

import SwiftUI

struct MagazineViewCell: View {
    var index : MagazineDTO
    var body: some View {
        VStack {
            HStack {
                Circle()
                    .frame(width: 40)
                    .foregroundColor(.black)
                VStack(alignment: .leading
                ) {
                    Text(index.nickName)
                        .bold()
                        .foregroundColor(.black)
                        
                    HStack {
                        Text("1분전")
                            .foregroundColor(.black)
                        Spacer()
                        Text(index.customPlaceName)
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
                ForEach(1..<4, id: \.self) { i in
                    Image("\(i)")
                        .resizable()
                        .frame(width: Screen.maxWidth, height: Screen.maxWidth * 0.6)
                        .aspectRatio(contentMode: .fit)
                }
            }
            .tabViewStyle(.page)
            .frame(maxHeight: Screen.maxHeight * 0.27)
            .padding()
            Group{
                HStack{
                    Text(index.title)
                        .foregroundColor(.black)
                        .font(.title2)
                        .bold()
                    
                    Spacer()
                }
                .padding(.vertical, -30)
            
                Text(index.content)
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
