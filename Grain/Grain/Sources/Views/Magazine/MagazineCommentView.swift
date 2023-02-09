//
//  MagazineCommentView.swift
//  Grain
//
//  Created by 조형구 on 2023/02/08.
//

import SwiftUI

struct MagazineCommentView: View {
    @State var commentText: String = ""
    var body: some View {
        
        VStack {
            ScrollView {
                Text("comment")
            }
            MagazineCommentTextField(commnetText: $commentText)
        }
        .navigationTitle("댓글")
        .navigationBarTitleDisplayMode(.inline)
    }
}
struct MagazineCommentTextField: View {
    @Binding var commnetText: String
    var body: some View {
        VStack {
        RoundedRectangle(cornerRadius: 30)
                .stroke(Color.brightGray)
                .padding(7)
                .overlay{
                    
                    TextField("댓글 달기...", text: $commnetText)
                        .padding()
                }
             
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .frame(height: 56)
      
    }
}
struct MagazineCommentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MagazineCommentView()
        }
    }
}
