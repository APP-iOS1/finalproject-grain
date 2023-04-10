//
//  MagazineCommentNickNameView.swift
//  Grain
//
//  Created by 지정훈 on 2023/04/05.
//

import SwiftUI

struct MagazineCommentNickNameView: View {
    let user: UserDocument
    
    var body: some View {
        Text(user.fields.nickName.stringValue)
            .font(.caption)
            .fontWeight(.bold)
    }
}
