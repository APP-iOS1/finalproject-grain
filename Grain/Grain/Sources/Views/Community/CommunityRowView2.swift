//
//  CommunityRowView2.swift
//  Grain
//
//  Created by 홍수만 on 2023/01/30.
//

import SwiftUI

struct CommunityRowView2: View {
    var community: Community
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
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
                    
                    
                    Text("\(community.title)")
                        .font(.callout)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
//                        .padding(.bottom, 3)
                    

                    VStack(alignment: .leading){
                        Text("1시간 전")
                            .foregroundColor(.secondary)
                            .font(.caption)
                            .padding(.trailing)
                            .padding(.top, 1)
                        
                        HStack{
                            Image(systemName: "heart")
                            Text("\(50)")
                            Image(systemName: "text.bubble")
                            Text("\(12)")
                        }
                        .foregroundColor(.secondary)
                        .font(.caption)
                        .padding(.trailing)
                        .padding(.top, 1)
                    }


                } //vstack
                .padding(.leading,1)

                Image("\(community.image[0])")
                    .resizable()
                    .frame(width: 130 , height: 100)
//                    .padding([.leading], 20)
//                    .padding(.trailing)
            }
//            Rectangle()
//                .frame(width: Screen.maxWidth * 0.9, height: 0.5)
//                .foregroundColor(.secondary)
//                .padding(.leading, 18)

        }
        .frame(width: Screen.maxWidth, height: Screen.maxHeight * 0.17)
    }
}

struct CommunityRowView2_Previews: PreviewProvider {
    static var previews: some View {
        CommunityRowView2(community: Community(id: "123123", category: 0, userID: "12341234", image: ["sampleImage","1"], title: "피고 놀이 꽃 것은 피가 못할 힘있다", profileImage: "sampleImage", nickName: "희경 센세", location: "방구석TEST", content: "피고 놀이 꽃 것은 피가 못할 힘있다. 풀밭에 장식하는 풀이 새 충분히 운다. 속에서 굳세게 되는 싶이 그들에게 천고에 바이며, 황금시대다. 끝에 이상, 소리다.이것은 그러므로 소금이라 것이다.보라, 봄바람을 역사를 끓는 황금시대다. 할지라도 인생을 끝에 광야에서 것이다. 있을 사라지지 인생의 일월과 철환하였는가? 없으면 그들에게 천자만홍이 이상은 바이며, 같은 두기 봄바람이다. 속에서 청춘은 튼튼하며, 그들의 있을 사라지지 피부가 이것이다. 이상의 천지는 황금시대의 지혜는 있을 것이다", createdAt: Date()))
    }
}
