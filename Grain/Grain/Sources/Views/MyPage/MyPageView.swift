//
//  MyPageView.swift
//  Grain
//
//  Created by 한승수 on 2023/01/31.
//

import SwiftUI

struct MyPageView: View {
    var images: [Image] = [Image("1"), Image("2"), Image("3"), Image("test"), Image("sampleImage"), Image("testImage")]
    let columns = [
        GridItem(.adaptive(minimum: 100))
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                
                //MARK: 프로필 이미지
                Image("2")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .cornerRadius(64)
                    .overlay {
                        Circle()
                            .stroke(lineWidth: 1.5)
                    }
                
                Text("nickname")
                    .font(.title2)
                    .bold()
                Text("자기소개글")
                    .padding(.top, 3)

                MyPageMyFeedView()

//                ScrollView{
//                    LazyVGrid(columns: columns) {
//                        ForEach(0..<images.count, id: \.self) { idx in
//                            NavigationLink {
//                                //이미지에 해당하는 게시글로 이동
//                            } label: {
//                                images[idx]
//                                    .resizable()
//                                    .frame(width: 130, height: 100)
//                            }
//
//                        }
//                    }
//                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        MyPageOptionView()
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
}

struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView()
    }
}
