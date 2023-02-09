//
//  BookmarkedMagazine.swift
//  Grain
//
//  Created by 홍수만 on 2023/02/06.
//

import SwiftUI

struct BookmarkedMagazine: View {
    @Environment(\.presentationMode) var presentationMode

    // 테스트 이미지 배열
    var images: [Image] = [Image("1"), Image("2"), Image("3"), Image("test"), Image("sampleImage"), Image("testImage")]
    
    let columns = [
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1)
    ]
    
    var body: some View {
        VStack{
            ScrollView{
                LazyVGrid(columns: columns, spacing: 1) {
                    ForEach(0..<images.count, id: \.self) { idx in
                        NavigationLink {
                            //이미지에 해당하는 게시글로 이동
                        } label: {
                            images[idx]
                                .resizable()
                                .scaledToFill()
                                .frame(width: (Screen.maxWidth / 3 - 1), height: (Screen.maxWidth / 3 - 1))
                                .clipped()
                        }
                        
                    }
                }
            }
        }
        .navigationTitle("저장된 매거진")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct BookmarkedMagazine_Previews: PreviewProvider {
    static var previews: some View {
        BookmarkedMagazine()
    }
}
