//
//  PhotoSpotTestView.swift
//  Grain
//
//  Created by 지정훈 on 2023/02/03.
//

import SwiftUI

struct PhotoSpotTestView: View {
    @State var isliked : Bool = false
    var body: some View {
//        VStack{
//            RoundedRectangle(cornerRadius: 10)
//                .stroke(Color(.black),lineWidth: 2)
//                .foregroundColor(.black)
//                .frame(width: Screen.maxWidth * 0.75, height: Screen.maxWidth * 0.3)
//                .overlay{
//                    HStack{
//                        Image("test")
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width:Screen.maxWidth * 0.20 ,height: Screen.maxWidth * 0.20)
//                            .cornerRadius(10)
//
//                    }
//                    VStack{
//                        Text("여기에는 제목이 들어갈")
//                    }
//
//                }
//        }
        VStack{
            HStack{
                Image("test")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width:Screen.maxWidth * 0.20 ,height: Screen.maxWidth * 0.20)
                    .cornerRadius(10)
                VStack(alignment: .leading){
                    Text("여기에는 제목이 들어갈")
                    Text("커스텀 플레이스")
                    HStack{
                        Button{
                            isliked.toggle()
                        } label: {
                            if isliked {
                                Image(systemName: "heart.fill")
                                    .foregroundColor(.red)
                                    .font(.title2)
                            } else {
                                Image(systemName: "heart")
                                    .foregroundColor(.black)
                                    .font(.title2)
                            }
                        }
                        Text("1")
                        
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(.black),lineWidth: 2)
                            .foregroundColor(.black)
                            .frame(width: 80,height: 25)
                            .overlay{
                                Image(systemName:"pin.fill")
                                    .foregroundColor(.black)
                                    .font(.system(size: 13))
                                    .offset(x: -27)
                                Text("보러가기")
                                    .foregroundColor(.black)
                                    .font(.system(size: 13))
                                    .offset(x: 6)
                                
                            }

                    }
                }
            }
        }
    }
}

struct PhotoSpotTestView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoSpotTestView()
    }
}
