//
//  Top10View.swift
//  Grain
//
//  Created by 윤소희 on 2023/01/18.
//

import SwiftUI

struct Top10View: View {
    var data : MagazineDocument
    
    var body: some View {
            VStack{
                Rectangle()
                    .cornerRadius(15)
                    .foregroundColor(Color.boxGray)
                    .overlay(
                        VStack{
                            Image("1")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                            Text(data.fields.nickName.stringValue)
                                .font(.title3)
                                .bold()
                                .foregroundColor(.white)
                                .frame(maxWidth:.infinity, alignment:.leading)
                                .padding(.horizontal)
                            Text(data.fields.title.stringValue)
                                .bold()
                                .foregroundColor(Color.white)
                                .font(.title)
                                .frame(maxWidth:.infinity, alignment:.leading)
                                .padding()
                                .multilineTextAlignment(.leading)
                                .lineLimit(2)
                            
                            Text(data.fields.content.stringValue)
                                .font(.title3)
                                .bold()
                                .foregroundColor(.white)
                                .frame(maxWidth:.infinity, alignment:.leading)
                                .padding(.horizontal)
                                .lineLimit(1)
                            
                            
                        }.cornerRadius(15),
                        alignment: .top
                    )
            }
    }
}

struct Top10Cell: View {
    var body: some View {
        VStack {
            VStack{
                Image("test")
                    .resizable()
                    .frame(width: Screen.maxWidth*0.4, height: Screen.maxWidth*0.3)
                    .shadow(radius: 10)
                Text("멋쟁이 사자처럼 앱스쿨 수료식날 한장 ~")
                    .font(.title3)
                    .lineLimit(1)
            }
            .padding(7)
        }
        .frame(width: Screen.maxWidth*0.5, height: Screen.maxWidth*0.5)
        .border(Color(hue: 1.0, saturation: 0.027, brightness: 0.848))
    }
}

//struct Top10View_Previews: PreviewProvider {
//    static var previews: some View {
//        Top10View()
//    }
//}
