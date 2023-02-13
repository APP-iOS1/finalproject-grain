//
//  Top10View.swift
//  Grain
//
//  Created by 윤소희 on 2023/01/18.
//

import SwiftUI
import Kingfisher

struct Top10View: View {
    var data : MagazineDocument
    @State private var colorSet:[Color] = [Color.colorSetOne, Color.colorSetTwo, Color.colorSetThree, Color.colorSetFour, Color.colorSetFive]
    var body: some View {
        VStack{
            Rectangle()
                .foregroundColor(.black)
                .frame(width: Screen.maxWidth * 0.9, height: Screen.maxHeight * 0.53)
//                .cornerRadius(15)
                
                .overlay(
                    VStack{
                        let url = URL(string: data.fields.image.arrayValue.values[0].stringValue)
                        //MARK: KingFisher를 사용하여 이미지 캐싱 처리
                        //url이 없을때 보여줄 이미지(placeholder) 정해서 지금 스트링값에 주소 넣어주면 될것같습니다
                       Rectangle()
                            .frame(width: Screen.maxWidth * 0.9, height: Screen.maxWidth * 0.63 )
                            .overlay{
                                KFImage.url(url ?? URL(string:"https://cdn.travie.com/news/photo/202108/21951_11971_5847.jpg")!)
                                    .resizable()
                                      .scaledToFill()
                                      .frame(width: Screen.maxWidth * 0.9, height: Screen.maxWidth * 0.63 )
                                      .clipShape(Rectangle())
                                      .overlay{
                                          LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0), Color.black.opacity(0), Color.black.opacity(0.3), Color.black.opacity(1)]), startPoint: .top, endPoint: .bottom)
                                      }
                                 
                            }
                        Text(data.fields.title.stringValue)
                            .bold()
                            .foregroundColor(Color.white)
                            .font(.title)
                            .frame(maxWidth:.infinity, alignment:.leading)
                            .padding(.horizontal)
                            .padding(.vertical, -5)
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                        HStack{
                            
                            Text(data.fields.nickName.stringValue)
                                .font(.body)
                                .bold()
                                .foregroundColor(.brightGray)
                                .frame(maxWidth:.infinity, alignment:.leading)
                                .padding(.horizontal)
                                .padding(.vertical, -5)
                            Divider()
                                .background(Color.white)
                        }
                        
                        Text(data.fields.content.stringValue)
                            .bold()
                            .foregroundColor(.white)
                            .frame(maxWidth:.infinity, alignment:.leading)
                            .padding(.bottom, 30)
                            .padding(.horizontal)
                            .lineLimit(1)
                        Spacer()
                    },
                    alignment: .top
                )
        }
        .padding(.bottom)
//        .cornerRadius(15)
        .shadow(radius: 2)
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


