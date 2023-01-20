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
    var community: Community
    
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
                            .foregroundColor(.black)
                            .overlay{
                                Text("매칭")
                                    .foregroundColor(.white)
                                    .bold()
                                    .font(.caption)
                            }
                        
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
                    
                    
                    Text("광화문 근처 스냅촬영하실 모델 구합니다.")
                        .font(.callout)
                        .foregroundColor(.black)
                        .lineLimit(2)
//                        .padding(.bottom, 3)
                    
                    HStack{
                        Text("\(community.location)") //??
                        Text(".")
                        Text("1시간 전")
                        
                        Spacer()
                        Image(systemName: "heart")
                        Text("\(5)")
                        
                    }
                    .foregroundColor(.secondary)
                    .font(.caption)
                    .padding(.trailing)
                    .padding(.top, 1)

                } //vstack
            }
            Rectangle()
                .frame(width: Screen.maxWidth - 30, height: 0.5)
                .foregroundColor(.secondary)
                .padding([.leading, .trailing], 20)
                .padding(.bottom, 10)
        }
    }
}

struct CommunityRowView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityRowView(community: Community(id: "123123", category: 0, userID: "12341234", image: ["camera"], title: "title입니다", profileImage: "person", nickName: "희경 센세", location: "광화문", content: "testing...", createdAt: Date()))
    }
}

