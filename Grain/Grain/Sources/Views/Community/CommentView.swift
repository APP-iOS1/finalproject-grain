//
//  CommentView.swift
//  Grain
//
//  Created by 홍수만 on 2023/01/20.
//

import SwiftUI

struct CommentView: View {
    var comment: Comment
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                VStack{
                    ProfileImage(imageName: comment.profileImage, width: 50, height: 50)
                    Spacer()
                }
                VStack(alignment: .leading){
                    Text("\(comment.nickName)")
                        .bold()
                    Text("\(comment.comment)")
                    
                    HStack{
                        Text("1분전")
                        Button{
                            
                        } label: {
                            Text("수정")
                        }
                        Button{
                            
                        } label: {
                            Text("삭제")
                        }
                        Button{
                            
                        } label: {
                            Text("답글쓰기")
                        }
                    }
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.top, 8)
                }
                Spacer()
            }
            .padding(.leading, 10)

            
            Rectangle()
                .frame(width: Screen.maxWidth - 30, height: 0.5)
                .foregroundColor(.secondary)
                .padding([.leading, .trailing], 20)
        }
        .frame(width: Screen.maxWidth - 30, height: Screen.maxHeight * 0.13)
    }
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentView(comment: Comment(id: "ddd", userID: "ddd", profileImage: "1", nickName: "악!", comment: "악!악!악!악!악!악!악!악!", createdAt: Date()))
    }
}
