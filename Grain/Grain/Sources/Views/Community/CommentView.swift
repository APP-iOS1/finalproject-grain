//
//  CommentView.swift
//  Grain
//
//  Created by 홍수만 on 2023/01/20.
//

import SwiftUI

struct CommentView: View {
    var comment: CommentFields
    var commentTime : String        //시간 값 넘어오는 것
    var commentText: String
    @StateObject var commentVm = CommentViewModel()
    var collectionDocId : String
    
    var body: some View {
        HStack(alignment: .top) {
            
            ProfileImage(imageName: comment.profileImage.stringValue)
            
            VStack(alignment: .leading) {
                HStack{
                    Text("\(comment.nickName.stringValue)")
                        .bold()
                        .padding(.bottom, 1)
                    Text("-")
                    Text(commentTime.toDate()?.renderTime() ?? "")      //시간 값
                        .font(.caption)
                }
                Text("\(comment.comment.stringValue)")
                    .lineLimit(Int.max)
                
                //MARK: 댓글 에디트
                HStack {
                    Button{
                        
                        commentVm.updateComment(collectionName: "Community", collectionDocId: collectionDocId, docID: comment.id.stringValue, updateComment: commentText,data: comment)
                    } label: {
                        Text("수정")
                    }
                    Button{
                        commentVm.deleteComment(collectionName: "Community", collectionDocId: collectionDocId, docID: comment.id.stringValue)
                    } label: {
                        Text("삭제")
                    }

                }
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.top, 1)
            }
        }.onAppear{
            commentVm.fetchComment(collectionName: "Community", collectionDocId: comment.id.stringValue)
        }
        //            Rectangle()
        //                .frame(width: Screen.maxWidth - 30, height: 0.5)
        //                .foregroundColor(.secondary)
        //                .padding([.leading, .trailing], 20)
    }
}

struct CommentView_Previews: PreviewProvider {
    @StateObject var communityVM = CommunityViewModel()

    static var previews: some View {
        CommentView(comment: CommentFields(comment: CommentString(stringValue: "dfda"), profileImage: CommentString(stringValue: "dfsd"), nickName: CommentString(stringValue: "bldf"), userID: CommentString(stringValue: "sdddu"), id: CommentString(stringValue: "dafdf")), commentTime: "", commentText: "", collectionDocId: "")
    }
}
