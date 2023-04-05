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
    
    func defaultProfileImage() -> String{
        var https : String = "https://"
        if let infolist = Bundle.main.infoDictionary {
            if let url = infolist["FailProfileImage"] as? String {
                https += url
            }
        }
        return https
    }
    
    var body: some View {
        KFImage(URL(string: imageName) ?? URL(string: defaultProfileImage()))
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
