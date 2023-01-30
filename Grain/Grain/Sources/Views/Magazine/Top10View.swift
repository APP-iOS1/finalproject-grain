//
//  Top10View.swift
//  Grain
//
//  Created by 윤소희 on 2023/01/18.
//

import SwiftUI

struct Top10View: View {
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
                            Text("형구짱")
                                .font(.title3)
                                .bold()
                                .foregroundColor(.white)
                                .frame(maxWidth:.infinity, alignment:.leading)
                                .padding(.horizontal)
                            Text("감성있는 크리스마스 사진 찍는법")
                                .bold()
                                .foregroundColor(Color.white)
                                .font(.title)
                                .frame(maxWidth:.infinity, alignment:.leading)
                                .padding()
                                .multilineTextAlignment(.leading)
                                .lineLimit(2)
                            
                            Text("피고 놀이 꽃 것은 피가 못할 힘있다. 풀밭에 장식하는 풀이 새 충분히 운다. 속에서 굳세게 되는 싶이 그들에게 천고에 바이며, 황금시대다. 끝에 이상, 소리다.이것은 그러므로 소금이라 것이다.보라, 봄바람을 역사를 끓는 황금시대다. 할지라도 인생을 끝에 광야에서 것이다. 있을 사라지지 인생의 일월과 철환하였는가? 없으면 그들에게 천자만홍이 이상은 바이며, 같은 두기 봄바람이다. 속에서 청춘은 튼튼하며, 그들의 있을 사라지지 피부가 이것이다. 이상의 천지는 황금시대의 지혜는 있을 것이다")
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

//struct Top10Cell: View {
//    var body: some View {
//        VStack {
//            VStack{
//                Image("test")
//                    .resizable()
//                    .frame(width: Screen.maxWidth*0.4, height: Screen.maxWidth*0.3)
//                    .shadow(radius: 10)
//                Text("멋쟁이 사자처럼 앱스쿨 수료식날 한장 ~")
//                    .font(.title3)
//                    .lineLimit(1)
//            }
//            .padding(7)
//        }
//        .frame(width: Screen.maxWidth*0.5, height: Screen.maxWidth*0.5)
//        .border(Color(hue: 1.0, saturation: 0.027, brightness: 0.848))
//    }
//}

struct Top10View_Previews: PreviewProvider {
    static var previews: some View {
        Top10View()
    }
}
