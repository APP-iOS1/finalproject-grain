//
//  MagazineBestView.swift
//  Grain
//
//  Created by 윤소희 on 2023/01/18.
//

import SwiftUI

struct MagazineBestView: View {
    var body: some View {
        VStack{
            EditorView()
            Top10View()
                .padding(.horizontal)
        }
    }
}

struct MagazineBestView_Previews: PreviewProvider {
    static var previews: some View {
        MagazineBestView()
    }
}
