//
//  MagazineProfileImage.swift
//  Grain
//
//  Created by 조형구 on 2023/02/14.
//

import SwiftUI
import Kingfisher

struct MagazineProfileImage: View {
    var imageName: String
    
    var body: some View {
        KFImage(URL(string: imageName) ?? URL(string:"https://cdn.travie.com/news/photo/202108/21951_11971_5847.jpg"))
            .resizable()
            .frame(width: 35, height: 35)
            .cornerRadius(30)
            .overlay {
                Circle()
                    .stroke(lineWidth: 0.5)
            }
            .padding(.leading, 10)
    }
}
struct MagazineProfileImage_Previews: PreviewProvider {
    static var previews: some View {
        MagazineProfileImage(imageName: "")
    }
}
