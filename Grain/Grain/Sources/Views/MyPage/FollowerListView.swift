//
//  FollowerListView.swift
//  Grain
//
//  Created by 박희경 on 2023/03/01.
//

import SwiftUI
import Kingfisher

struct FollowerListView: View {
    var userVM: UserViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(userVM.followerList, id: \.self) { item in
                    HStack {
                        KFImage(URL(string: item.fields.profileImage.stringValue) ?? URL(string:"https://cdn.travie.com/news/photo/202108/21951_11971_5847.jpg"))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                            .cornerRadius(64)
                            .overlay {
                                Circle()
                                    .stroke(lineWidth: 0.1)
                            }
                            .padding([.trailing, .leading], 10)
                        
                            Text(item.fields.nickName.stringValue)
                                .font(.callout)
                                .bold()
                                .padding(.leading, 5)
                                .padding(.bottom, 1)
    
                        Spacer()
                    }//hstack
                } // foreach
            } // vstack
        } //scrollview
    }
}

//struct FollowerListView_Previews: PreviewProvider {
//    static var previews: some View {
//        FollowerListView()
//    }
//}
