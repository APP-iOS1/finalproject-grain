//
//  CommunityRowView.swift
//  Grain
//
//  Created by 박희경 on 2023/01/18.
//

import SwiftUI
import FirebaseFirestore
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
    @State private var communityDate: String = ""
    var community: CommunityDocument
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Image("sampleImage")
                    .resizable()
                    .frame(width: 130 , height: 100)
                    .padding(.horizontal, 13)
                    //.padding(.top, 5)
                
                VStack {
                    VStack(alignment: .leading){
                        //MARK: 게시글 태그
                        HStack {
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width: 45, height: 25)
                                .foregroundColor(Color(hex: "F58800"))
                                .overlay{
                                    Text("\(community.fields.category.stringValue)")
                                        .foregroundColor(.white)
                                        .bold()
                                        .font(.caption)
                                }
                                .padding(.leading, -3)
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width: 45, height: 25)
                                .foregroundColor(Color(hex: "F8BC24"))
                                .overlay{
                                    Text("모집중")
                                        .foregroundColor(.black)
                                        .bold()
                                        .font(.caption)
                                }
                                .padding(.leading, 3)
                        } // hstack
                        .padding(.top, 4)
                       // .padding(.vertical, 3)
                        
                       // Spacer()
                        
                        //MARK: 게시글 제목
                        Text("\(community.fields.title.stringValue)")
                            .font(.callout)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                            .frame(height: 45)
                            .padding(.top, -2)
                            
    //                        .padding(.bottom, 3)
                            
                       // Spacer()
                        
                        HStack {
                            
                           // String.toDate(community.createTime)
                            Text("\(communityDate)")
                            Spacer()
                            
                            Image(systemName: "heart")
                            Text("\(50)")
                            Image(systemName: "text.bubble")
                            Text("\(12)")
                        }
                        .padding(.bottom, 4)
                        .foregroundColor(.secondary)
                        .font(.caption)
                        //.padding(.trailing, 10)
                    }
                    .frame(height: 100)
                    .padding(.trailing, 13)
                    .padding(.leading, -3)
                   
                }
                
               
                //vstack
            }
            Divider()
                .padding(.top, 5)
                
        }
        .padding(.top, 5)
        .onAppear {
            // MARK: CleanCode로 고쳐야함
            // renderTime()을 쓰기 위한 노력: Date타입에 쓸 수 있음 Date -> String (ex."n시간 전")
            // 우리가 받아오는 community.createTime은 "2023-02-08T14:13:07.734982Z"형식의 String
            // renderTime()을 쓰려면 "yyyy-MM-dd"의 String에서 .toDate()를 통해 Date타입으로 바꿔야함
            // "2023-02-08T14:13:07.734982Z" 문자열을 잘라줘서 "2023-02-08"(subString)으로 바꾼뒤 String으로 형변환 - communityDateStr
            // toDate() 함수를 써서 String -> Date로 바꿈 - dateTime
            // renderTime() 함수를 써서 n시간 전 String으로 계산
            // communityDate에 최종적으로 넣어줌
            let startIndex = community.createTime.startIndex
            let endIndex = community.createTime.index(community.createTime.startIndex, offsetBy: 9)
            let range = startIndex...endIndex
            let communityDateStr = String(community.createTime[range])
            let dateTime = communityDateStr.toDate()
            let beforeTime = dateTime?.renderTime()
            communityDate = beforeTime ?? ""
        }
    }
}

struct CommunityRowView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityRowView(community: CommunityDocument(name: "abc", fields: CommunityFields(title: CommunityCategory(stringValue: "임시 타이틀입니다 줄을 길게 해볼거에요 라인리미트를 2줄로 할거거덩요"), category: CommunityCategory(stringValue: "매칭중"), content: CommunityCategory(stringValue: "content"), profileImage: CommunityCategory(stringValue: "test"), nickName: CommunityCategory(stringValue: "han"), image: CommunityImage(arrayValue: CommunityArrayValue(values: [CommunityCategory(stringValue: "abc")])), userID: CommunityCategory(stringValue: "seungsoo"), id: CommunityCategory(stringValue: "123")), createTime: "2023-02-03", updateTime: "방금"))
    }
}

