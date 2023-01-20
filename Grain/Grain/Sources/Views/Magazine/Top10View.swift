//
//  Top10View.swift
//  Grain
//
//  Created by 윤소희 on 2023/01/18.
//

import SwiftUI

struct Top10View: View {
    @StateObject var viewModel: ContentViewModel = ContentViewModel()
    var body: some View {
        VStack {
            TabView{
                ForEach(1..<4, id: \.self) { i in
                    Image("\(i)")
                        .resizable()
                        .frame(width: Screen.maxWidth, height: Screen.maxWidth * 0.6)
                        .aspectRatio(contentMode: .fit)
                }
            }
            .tabViewStyle(.page)
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
