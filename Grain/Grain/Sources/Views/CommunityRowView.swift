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
        HStack{
            Image(systemName: community.image.first ?? "camera")
                .resizable()
                .frame(width: 100, height: 100)
            
            VStack{
                HStack{
                    Image(systemName:community.profileImage)
                    Text("\(community.nickName)")
//                    Label{
//                        Text("마켓")
//                    } icon: {
//                        Cap
//                    }
                    
                }
            }
        }
    }
}

struct CommunityRowView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityRowView(community: Community(id: "123123", category: 0, userID: "12341234", image: ["camera"], title: "title입니다", profileImage: "person", nickName: "희경 센세", location: "방구석ㅅTEST", content: "testing...", createdAt: Date()))
    }
}
/*
 community: Community(id: "123131", category: 0, userID: "1231334", image: ["camera"], title: "title입니다", locatiprofileImage에서 test 중", content: "Testing nickNamerofileImage: "person", location경 센세" createcontente()))
 */
