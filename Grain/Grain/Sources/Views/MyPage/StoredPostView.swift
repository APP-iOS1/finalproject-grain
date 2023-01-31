//
//  StoredPostView.swift
//  Grain
//
//  Created by 한승수 on 2023/01/31.
//

import SwiftUI

struct StoredPostView: View {
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
            
            Text("저장됨 뷰")
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

struct StoredPostView_Previews: PreviewProvider {
    static var previews: some View {
        StoredPostView()
    }
}
