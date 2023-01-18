//
//  MagazineBestView.swift
//  Grain
//
//  Created by 윤소희 on 2023/01/18.
//

import SwiftUI

struct MagazineBestView: View {
    var body: some View {
        NavigationView{
            VStack{
                EditorView()
                Top10View()
                    .padding(.horizontal)
            }
            .background(Color(hex: "#fefaf7"))
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
}

struct MagazineBestView_Previews: PreviewProvider {
    static var previews: some View {
        MagazineBestView()
    }
}
