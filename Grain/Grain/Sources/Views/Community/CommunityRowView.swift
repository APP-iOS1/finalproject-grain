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
    
    var community: CommunityDocument
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Image("sampleImage")
                    .resizable()
                    .frame(width: 130 , height: 100)
                    .padding(.leading, 10)
                
                VStack(alignment: .leading){
                    
                    //MARK: 게시글 태그
                    HStack {
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 45, height: 25)
                            .foregroundColor(Color(hex: "595BB9"))
                            .overlay{
                                Text("\(community.fields.category.stringValue)")
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
                    
                    Spacer()
                    
                    //MARK: 게시글 제목
                    Text("\(community.fields.title.stringValue)")
                        .font(.callout)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
//                        .padding(.bottom, 3)
                    
                    Spacer()
                    
                    HStack {
                        Text("1시간 전")
                        
                        Spacer()
                        
                        Image(systemName: "heart")
                        Text("\(50)")
                        Image(systemName: "text.bubble")
                        Text("\(12)")
                    }
                    .foregroundColor(.secondary)
                    .font(.caption)
                    .padding(.trailing, 10)
                }
                .frame(height: 100)
                //vstack
            }
        }
        .padding(.vertical, 5)
    }
}

struct CommunityRowView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityRowView(community: CommunityDocument(name: "abc", fields: CommunityFields(title: CommunityCategory(stringValue: "임시 타이틀입니다"), category: CommunityCategory(stringValue: "매칭중"), content: CommunityCategory(stringValue: "content"), profileImage: CommunityCategory(stringValue: "test"), nickName: CommunityCategory(stringValue: "han"), image: CommunityImage(arrayValue: CommunityArrayValue(values: [CommunityCategory(stringValue: "abc")])), userID: CommunityCategory(stringValue: "seungsoo"), id: CommunityCategory(stringValue: "123")), createTime: "2023-02-03", updateTime: "방금"))
    }
}

