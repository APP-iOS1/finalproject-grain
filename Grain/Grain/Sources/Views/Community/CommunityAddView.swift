//
//  CommunityAddView.swift
//  Grain
//
//  Created by 홍수만 on 2023/01/18.
//

import SwiftUI

enum Category: Int, CaseIterable, Identifiable {
    case 마켓, 매칭, 클래스
    var id: Self { self }
}

struct CommunityAddView: View {
    @State var Image: [String] = []
    @State var title: String = ""
    @State var content: String = ""
    @State var createdAt: Date = Date()
    @State var location: String = ""
    @State var selectedCategory = Category.마켓
    
    
    var createdDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "yyyy-MM-dd" // "yyyy-MM-dd HH:mm:ss"
        
        let dateCreatedAt = createdAt
        
        return dateFormatter.string(from: dateCreatedAt)
    }
    
    var body: some View {
        Form{
            Section("제목"){
                TextField("제목을 입력하세요", text: $title)
            }
            
            Section("날짜") {
                Text("\(createdDate)")
            }
            Section("위치") {
                TextField("위치를 입력하세요", text: $location)

            }
            
            Section("카테고리"){
                HStack{
                    Picker("인기순", selection: $selectedCategory) {
                        Text("마켓").tag(Category.마켓)
                        Text("매칭").tag(Category.매칭)
                        Text("클래스").tag(Category.클래스)
                    }
                    .pickerStyle(.segmented)
                }
            }
            
            Section("사진"){
                
            }
            
            Section("내용"){
                TextField("내용을 입력하세요", text: $content)
            }
        }
    }
}

struct CommunityAddView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityAddView()
    }
}

/*
 Community(id: "123123", category: 0, userID: "12341234", image: ["camera","person"], title: "title입니다", profileImage: "person", nickName: "희경 센세", location: "방구석TEST", content: "피고 놀이 꽃 것은 피가 못할 힘있다. 풀밭에 장식하는 풀이 새 충분히 운다. 속에서 굳세게 되는 싶이 그들에게 천고에 바이며, 황금시대다. 끝에 이상, 소리다.이것은 그러므로 소금이라 것이다.보라, 봄바람을 역사를 끓는 황금시대다. 할지라도 인생을 끝에 광야에서 것이다. 있을 사라지지 인생의 일월과 철환하였는가? 없으면 그들에게 천자만홍이 이상은 바이며, 같은 두기 봄바람이다. 속에서 청춘은 튼튼하며, 그들의 있을 사라지지 피부가 이것이다. 이상의 천지는 황금시대의 지혜는 있을 것이다", createdAt: Date())
 */
/*
 var id: String
 var category: Int
 var userID: String
 var image: [String]
 var title: String
 var profileImage: String
 var nickName: String
 
 var location: String
 var content: String
 var createdAt: Date
 */
