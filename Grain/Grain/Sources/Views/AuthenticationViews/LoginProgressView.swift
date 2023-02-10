//
//  LoginProgressView.swift
//  Grain
//
//  Created by 조형구 on 2023/02/11.
//

import SwiftUI

struct LoginProgressView: View {
    var body: some View {
        ZStack{
            Color.white
            VStack{
                ProgressView()
            }
        }
    }
}

struct LoginProgressView_Previews: PreviewProvider {
    static var previews: some View {
        LoginProgressView()
    }
}
