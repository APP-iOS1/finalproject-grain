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
    
    func errorImage() -> String{
        var https : String = "https://"
        if let infolist = Bundle.main.infoDictionary {
            if let url = infolist["FailProfileImage"] as? String {
                https += url
            }
        }
        return https
    }
    
    var body: some View {
        KFImage(URL(string: imageName) ?? URL(string: errorImage()))
            .resizable()
            .frame(width: 35, height: 35)
            .cornerRadius(30)
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
