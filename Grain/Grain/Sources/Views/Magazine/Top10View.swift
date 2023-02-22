//
//  Top10View.swift
//  Grain
//
//  Created by 윤소희 on 2023/01/18.
//

import SwiftUI
import Kingfisher

struct Top10View: View {
    let data : MagazineDocument

    var body: some View {
        VStack{
            Rectangle()
                .foregroundColor(.black)
                .frame(width: Screen.maxWidth * 0.9, height: Screen.maxHeight * 0.465)
                .overlay(
                    VStack{
                        let url = URL(string: data.fields.image.arrayValue.values[0].stringValue)
                        //MARK: KingFisher를 사용하여 이미지 캐싱 처리
                        //url이 없을때 보여줄 이미지(placeholder) 정해서 지금 스트링값에 주소 넣어주면 될것같습니다
                       Rectangle()
                            .frame(width: Screen.maxWidth * 0.9, height: Screen.maxWidth * 0.6 )
                            .overlay{
                                KFImage.url(url ?? URL(string:"https://cdn.travie.com/news/photo/202108/21951_11971_5847.jpg")!)
                                    .resizable()
                                      .scaledToFill()
                                      .frame(width: Screen.maxWidth * 0.9, height: Screen.maxWidth * 0.6 )
                                      .clipShape(Rectangle())
                                      .overlay{
                                          LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0), Color.black.opacity(0), Color.black.opacity(0),  Color.black.opacity(0.3), Color.black.opacity(1)]), startPoint: .top, endPoint: .bottom)
                                      }
                                 
                            }
                        Text(data.fields.title.stringValue)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .font(.title2)
                            .frame(maxWidth:.infinity, alignment:.leading)
                            .padding(.horizontal)
                            .padding(.bottom, 0)
                            .multilineTextAlignment(.leading)
                            .lineLimit(1)
                        HStack{
                            Text("by")
                                .font(.subheadline)
                                .bold()
                                .foregroundColor(.ultraBrightGray)
                                .frame( alignment:.leading)
                                
                            Divider()
                                .overlay(Color.white)
                                .frame(width: 1.5, height: 16)
                            
                            Text(data.fields.nickName.stringValue)
                                .font(.subheadline)
                                .bold()
                                .foregroundColor(.white)
                                .frame( alignment:.leading)
                               
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.vertical)
                        .frame(height:25)
                        
                        Text(data.fields.content.stringValue)
                            .multilineTextAlignment(.leading)
                            .font(.subheadline)
                            .font(.body)
                            .foregroundColor(.white)
                            .frame(maxWidth:.infinity, alignment:.leading)
                            .padding(.horizontal)
                            .padding(.vertical, 6)
                            .lineLimit(2)
                            .lineSpacing(6)
                        Spacer()
                    },
                    alignment: .top
                )
        }
        .padding(.bottom)
    }
}

//struct Top10View_Previews: PreviewProvider {
//    static var previews: some View {
//        Top10View()
//    }
//}


