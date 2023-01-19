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
                    .frame(width: 160, height:110 )
                    .padding()
                    .padding(.leading, -15)
                //                Image(systemName: community.image.first ?? "camera")
                //                    .resizable()
                //                    .frame(width: 120, height: 100)
                //                    .padding()
                
                VStack(alignment: .leading){
                    
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: 45, height: 25)
                        .foregroundColor(.black)
                        .overlay{
                            Text("매칭")
                                .foregroundColor(.white)
                                .bold()
                                .font(.caption)
                        }
                        
            
                    Text("광화문 근처 추천할만한 스팟입니다. 2월 4일 함께 출사나가실 모델분 구합니다 .")
                        .font(.body)
                        .foregroundColor(.black)
                    
                    HStack{
                        Text("\(community.location)") //??
                        Text(".")
                        Text("1시간 전")
                    }
                    .foregroundColor(.black)
                    .font(.caption)
                    .offset(x: 80, y: 15)
                    
                    
                    
                }
                .padding(.leading, -10)
            }
            Rectangle()
                .frame(width: 360, height: 1)
                .foregroundColor(.black)
        }
        
    }
}

struct CommunityRowView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityRowView(community: Community(id: "123123", category: 0, userID: "12341234", image: ["camera"], title: "title입니다", profileImage: "person", nickName: "희경 센세", location: "방구석", content: "testing...", createdAt: Date()))
    }
}

