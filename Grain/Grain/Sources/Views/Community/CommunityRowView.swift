//
//  CommunityRowView.swift
//  Grain
//
//  Created by 박희경 on 2023/01/18.
//

import SwiftUI
/*
 id:String
 category: Int
 userId: String
 image: [String]
 title: string
 
 location: String
 content: string
 createdAt: TimeStamp
 */

struct CommunityRowView: View {
    
    var community: CommunityDTO
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Image("sampleImage")
                    .resizable()
                    .frame(width: 130 , height: 100)
                    .padding([.leading], 20)
                    .padding(.trailing)
                
                VStack(alignment: .leading){
                    HStack {
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 45, height: 25)
                            .foregroundColor(Color(hex: "595BB9"))
                            .overlay{
                                Text("\(community.category)")
                                    .foregroundColor(.white)
                                    .bold()
                                    .font(.caption)
                            }
//                        RoundedRectangle(cornerRadius: 20)
//                            .frame(width: 45, height: 25)
//                            .foregroundColor(Color(hex: "459172"))
//                            .overlay{
//                                Text("매칭")
//                                    .foregroundColor(.white)
//                                    .bold()
//                                    .font(.caption)
//                            }
//                        RoundedRectangle(cornerRadius: 20)
//                            .frame(width: 45, height: 25)
//                            .foregroundColor(Color(hex: "7E736F"))
//                            .overlay{
//                                Text("매칭")
//                                    .foregroundColor(.white)
//                                    .bold()
//                                    .font(.caption)
//                            }
//                        RoundedRectangle(cornerRadius: 20)
//                            .frame(width: 45, height: 25)
//                            .foregroundColor(Color(hex: "44909F"))
//                            .overlay{
//                                Text("매칭")
//                                    .foregroundColor(.white)
//                                    .bold()
//                                    .font(.caption)
//                            }
                        
                        
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 45, height: 25)
                            .foregroundColor(.black)
                            .overlay{
                                Text("모집중")
                                    .foregroundColor(.white)
                                    .bold()
                                    .font(.caption)
                            }
                        
                    } // hstack
                    .padding(.leading, -2)
                    
                    
                    Text("\(community.title)")
                        .font(.callout)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
//                        .padding(.bottom, 3)
                    
                    HStack{
//                        Text("\(community.location)") //??
//                        Text(".")
                        Text("1시간 전")
                        
                        Spacer()
                        Image(systemName: "heart")
                        Text("\(50)")
                        Image(systemName: "text.bubble")
                        Text("\(12)")
                        
                    }
                    .foregroundColor(.secondary)
                    .font(.caption)
                    .padding(.trailing)
                    .padding(.top, 1)

                } //vstack
            }
//            Rectangle()
//                .frame(width: Screen.maxWidth * 0.9, height: 0.5)
//                .foregroundColor(.secondary)
//                .padding(.leading, 18)

        }
        .frame(width: Screen.maxWidth, height: Screen.maxHeight * 0.17)
    }
}

//struct CommunityRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommunityRowView()
//    }
//}
//
