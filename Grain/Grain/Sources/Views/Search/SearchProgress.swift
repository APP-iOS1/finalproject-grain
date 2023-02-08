//
//  SearchProgress.swift
//  Grain
//
//  Created by 조형구 on 2023/02/08.
//

import SwiftUI

struct SearchProgress: View {
    var body: some View {
        ZStack{
            Color.white
            VStack {
                ProgressView()
                
            }
        }
    }
}

struct SearchProgress_Previews: PreviewProvider {
    static var previews: some View {
        SearchProgress()
    }
}
