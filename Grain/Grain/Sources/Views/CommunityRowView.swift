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
        VStack{
            HStack{
                Image(systemName: community.image.first ?? "camera")
                    .resizable()
                    .frame(width: 120, height: 100)
                    .padding()
                
                VStack(alignment: .leading){
                    HStack{
                        Image(systemName:community.profileImage)
                            .resizable()
                            .frame(width: 20, height: 20)
                        
                        Text("\(community.nickName)")
                        
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 45, height: 25)
                            .foregroundColor(.green)
                            .overlay{
                                Text("마켓")
                                    .font(.caption)
                            }
                    }
                    
                    Text("\(community.title)")
                        .font(.title)
                    
                    HStack{
                        Text("\(community.location)") //??
                        Text(".")
                        Text("n시간 전")
                    }
                    .font(.caption)
                    
                    Text("\(community.createdDate)")
                        .font(.caption)
                        .padding(.leading, 50)
                        .padding(.top, 10)

                }
            }
        }
    }
}

struct CommunityRowView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityRowView(community: Community(id: "123123", category: 0, userID: "12341234", image: ["camera"], title: "title입니다", profileImage: "person", nickName: "희경 센세", location: "방구석", content: "testing...", createdAt: Date()))
    }
}

