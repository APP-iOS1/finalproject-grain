//
//  ProfileImage.swift
//  Grain
//
//  Created by 홍수만 on 2023/01/20.
//

import SwiftUI

struct ProfileImage: View {
    var imageName: String
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        Image("\(imageName)")
            .resizable()
            .frame(width: width, height: height)
            .cornerRadius(48)
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        ProfileImage(imageName: "sampleImage", width: 60, height: 60)
    }
}
