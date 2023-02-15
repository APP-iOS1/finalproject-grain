//
//  CommunityCommentView.swift
//  Grain
//
//  Created by 윤소희 on 2023/02/15.
//


import SwiftUI
import UIKit
import FirebaseAuth
import Kingfisher

struct CommunityCommentView: View {
    
    let community: CommunityDocument
    @StateObject var communityVM = CommunityViewModel()
    @StateObject var userVM = UserViewModel()
    @StateObject var commentVm = CommentViewModel()
    @State var replyContent: String = ""
    
    var trimContent: String {
        replyContent.trimmingCharacters(in: .whitespaces)
    }
    
    var body: some View {
        HStack {
            TextField("댓글을 작성해주세요", text: $replyContent, axis: .vertical)
            if trimContent.count > 0 {
                Button {
                    commentVm.insertComment(collectionName: "Community", collectionDocId: community.fields.id.stringValue, data: CommentFields(comment: CommentString(stringValue: replyContent), profileImage: CommentString(stringValue: community.fields.profileImage.stringValue), nickName: CommentString(stringValue: community.fields.nickName.stringValue), userID: CommentString(stringValue: Auth.auth().currentUser?.uid ?? ""), id: CommentString(stringValue: UUID().uuidString)))
                } label: {
                    Image(systemName: "paperplane")
                        .foregroundColor(.black)
                        .padding()
                }
            }
        }
        .padding()
    }
}

//struct CommunityCommentView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommunityCommentView()
//    }
//}
