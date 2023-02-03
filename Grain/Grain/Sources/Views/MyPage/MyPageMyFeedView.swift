//
//  MyPageMyFeedView.swift
//  Grain
//
//  Created by 홍수만 on 2023/02/03.
//

import SwiftUI

struct MyPageMyFeedView: View {
    var images: [Image] = [Image("1"), Image("2"), Image("3"), Image("test"), Image("sampleImage"), Image("testImage")]
    
    let columns = [
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1)
    ]
    
    var body: some View {
        VStack{
            HStack{
                Button{
                    
                } label: {
                    Image(systemName: "square.grid.2x2")
                }
                Button{
                    
                } label:{
                    Image(systemName: "list.bullet")
                }
                Spacer()
                
            }
            .foregroundColor(.black)
            .font(.title3)
            .padding()
            
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
        
    }
}

struct MyPageMyFeedView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageMyFeedView()
    }
}
