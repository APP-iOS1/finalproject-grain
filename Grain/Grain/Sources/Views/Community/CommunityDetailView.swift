//
//  CommunityDetailView.swift
//  Grain
//
//  Created by 박희경 on 2023/01/18.
//

import SwiftUI


// image -> systemName image로 임시 처리
struct CommunityDetailView: View {
    let community: Community
    @State private var isBookMarked: Bool = false
    @State private var isliked: Bool = false

    @State private var comment: String = ""
    
    var body: some View {
        VStack{
            ScrollView {
                VStack {
                    HStack {
                        CircleImage(imageName: community.profileImage)
                        Text(community.nickName)
                            .font(.title3)
                            .bold()
                        Spacer()
                        Button {
                            isBookMarked.toggle()
                        } label: {
                            Image(systemName: isBookMarked ? "bookmark.fill" : "bookmark")
                                .font(.title2)
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        
                        Image(systemName: "mappin")
                        Text(community.location)
                        Spacer()
                        Text("\(community.createdDate)")
                    }
                    .font(.caption)
                    .padding(.horizontal, 20)
                    
                    HStack{
                        Text("\(community.title)")
                            .font(.title)
                            .padding()
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    TabView {
                        ForEach(community.image, id: \.self)  { img in
                            Image(img)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 200)
                        }
                    }
                    .tabViewStyle(.page)
                    .frame(height: 200)
                    
                    HStack{
                        Button{
                            isliked.toggle()
                        } label: {
                            Image(systemName: isliked ? "heart.fill" : "heart")
                                .foregroundColor(.red)
                        }
                        Text("50")
                        
                        Image(systemName: "text.bubble")
                        Text("12")
                        
                        Spacer()
                    }
                    .padding(.leading, 30)
                    
                    Text(community.content)
                        .padding(.horizontal, 30)
                        .padding(.top, 10)
                    

                    
                    Rectangle()
                        .frame(width: Screen.maxWidth - 30, height: 0.5)
                        .foregroundColor(.secondary)
                        .padding([.leading, .trailing], 20)
                    
                } // top vstack
            } //scroll view
            
            HStack{
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(UIColor.lightGray))
                    .frame(width: Screen.maxWidth * 0.85, height: 50)
                    .overlay{
                        TextField("댓글을 입력해주세요", text: $comment)
                    }
                
                Button{
                    
                } label: {
                    Image(systemName: "paperplane")
                        .foregroundColor(.black)

                }
                        
            }
            .padding()
        }
    }
}

struct CommunityDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityDetailView(community: Community(id: "123123", category: 0, userID: "12341234", image: ["sampleImage","1"], title: "피고 놀이 꽃 것은 피가 못할 힘있다", profileImage: "sampleImage", nickName: "희경 센세", location: "방구석TEST", content: "피고 놀이 꽃 것은 피가 못할 힘있다. 풀밭에 장식하는 풀이 새 충분히 운다. 속에서 굳세게 되는 싶이 그들에게 천고에 바이며, 황금시대다. 끝에 이상, 소리다.이것은 그러므로 소금이라 것이다.보라, 봄바람을 역사를 끓는 황금시대다. 할지라도 인생을 끝에 광야에서 것이다. 있을 사라지지 인생의 일월과 철환하였는가? 없으면 그들에게 천자만홍이 이상은 바이며, 같은 두기 봄바람이다. 속에서 청춘은 튼튼하며, 그들의 있을 사라지지 피부가 이것이다. 이상의 천지는 황금시대의 지혜는 있을 것이다", createdAt: Date()))
    }
}
