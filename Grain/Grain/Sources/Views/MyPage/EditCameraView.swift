//
//  EditCameraView.swift
//  Grain
//
//  Created by 한승수 on 2023/01/31.
//

import SwiftUI

struct EditCameraView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("설정")
                    Spacer()
                }
                .padding(.horizontal)
            })
            .accentColor(.black)
            
            Text("카메라 편집 뷰")
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

struct EditCameraView_Previews: PreviewProvider {
    static var previews: some View {
        EditCameraView()
    }
}
