//
//  ProfileImage.swift
//  Grain
//
//  Created by 홍수만 on 2023/01/20.
//

import SwiftUI
import Kingfisher

struct ProfileImage: View {
    var imageName: String
    
    var body: some View {
        KFImage(URL(string: imageName) ?? URL(string:"https://cdn.travie.com/news/photo/202108/21951_11971_5847.jpg"))
            .resizable()
            .frame(width: 35, height: 35)
            .cornerRadius(15)
            .overlay {
                Circle()
                    .stroke(lineWidth: 0.5)
            }
            .padding(.horizontal, 7)
    }
    
    
}

//struct CircleImage_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileImage(imageName: "sampleImage", width: 60, height: 60)
//    }
//}
