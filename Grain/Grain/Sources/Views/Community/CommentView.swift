//
//  CommentView.swift
//  Grain
//
//  Created by 홍수만 on 2023/01/20.
//

import SwiftUI

//MARK: 입력된 댓글 레이아웃
struct CommentView: View {
    var comment: CommentFields
    var commentTime : String        //시간 값 넘어오는 것
    var commentText: String
    @StateObject var commentVm = CommentViewModel()
    var collectionDocId : String
    
    var body: some View {
        VStack(alignment: .leading){
            
            HStack() {
                
                ProfileImage(imageName: comment.profileImage.stringValue)
                
                VStack(alignment: .leading) {
                    HStack{
                        Text("\(comment.nickName.stringValue)")
                            .font(.footnote)
                            .fontWeight(.bold)
                        //                        .bold()
                        //                        .padding(.bottom, 1)
                        HStack{
                            Text("・")
                                .padding(.trailing, -5)
                            Text(commentTime.toDate()?.renderTime() ?? "")      //시간 값
                        }
                        .font(.caption2)
                    }
                    Text("\(comment.comment.stringValue)")
                        .font(.callout)
                        .lineLimit(Int.max)
                        .padding(.top, -7)
                    
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
                    .foregroundColor(.textGray)
                    .padding(.top, -5)
                    .padding(.bottom, -3)
                }
            }.onAppear{
                commentVm.fetchComment(collectionName: "Community", collectionDocId: comment.id.stringValue)
            }
        }
    }
}

//struct CommentView_Previews: PreviewProvider {
//    @StateObject var communityVM = CommunityViewModel()
//
//    static var previews: some View {
//        CommentView(comment: CommentFields(comment: CommentString(stringValue: "dfda"), profileImage: CommentString(stringValue: "dfsd"), nickName: CommentString(stringValue: "bldf"), userID: CommentString(stringValue: "sdddu"), id: CommentString(stringValue: "dafdf")), commentTime: "", commentText: "", collectionDocId: "")
//    }
//}
