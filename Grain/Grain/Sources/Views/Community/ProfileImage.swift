//
//  ProfileImage.swift
//  Grain
//
//  Created by 홍수만 on 2023/01/20.
//

import SwiftUI

struct CircleImage: View {
    var imageName: String
    
    var body: some View {
        Image("\(imageName)")
            .resizable()
            .scaledToFit()
            .clipShape(Circle())
            .frame(width: 60, height: 60)
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage(imageName: "sampleProfile")
    }
}
