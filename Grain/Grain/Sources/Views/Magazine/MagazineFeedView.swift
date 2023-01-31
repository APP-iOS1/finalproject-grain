//
//  MagazineFeedView.swift
//  Grain
//
//  Created by 조형구 on 2023/01/20.
//

import SwiftUI

struct MagazineFeedView: View {
    
//    var index : [MagazineDTO]
    
    var body: some View {
        
        ScrollView{
            LazyVStack{
                
                Rectangle()
                    .cornerRadius(15)
                    .foregroundColor(Color.boxGray)
                    .overlay(
                        VStack{
                            ForEach(0..<2) { _ in
                                Image("1")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                Text("1")
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(.white)
                                    .frame(maxWidth:.infinity, alignment:.leading)
                                Text("1")
                                    .bold()
                                    .foregroundColor(Color.white)
                                    .font(.title)
                                    .frame(maxWidth:.infinity, alignment:.leading)
                                    .padding()
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(2)
                                
                                Text("1")
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(.white)
                                    .frame(maxWidth:.infinity, alignment:.leading)
                                    .padding(.horizontal)
                                    .lineLimit(1)
                            }
//                            Image("1")
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                            Text(index.nickName)
//                                .font(.title3)
//                                .bold()
//                                .foregroundColor(.white)
//                                .frame(maxWidth:.infinity, alignment:.leading)
//                                .padding(.horizontal)
//                            Text(index.title)
//                                .bold()
//                                .foregroundColor(Color.white)
//                                .font(.title)
//                                .frame(maxWidth:.infinity, alignment:.leading)
//                                .padding()
//                                .multilineTextAlignment(.leading)
//                                .lineLimit(2)
//
//                            Text(index.content)
//                                .font(.title3)
//                                .bold()
//                                .foregroundColor(.white)
//                                .frame(maxWidth:.infinity, alignment:.leading)
//                                .padding(.horizontal)
//                                .lineLimit(1)
                            
                            
                        }.cornerRadius(15),
                        alignment: .top
                    )
                
            }
            MagazineViewCell()
        }
    }
}
//
//struct MagazineFeedView_Previews: PreviewProvider {
//    static var previews: some View {
//        MagazineFeedView()
//    }
//}
