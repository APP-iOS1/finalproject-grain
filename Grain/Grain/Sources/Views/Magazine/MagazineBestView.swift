//
//  MagazineBestView.swift
//  Grain
//
//  Created by 윤소희 on 2023/01/18.
//

import SwiftUI

struct MagazineBestView: View {
    @StateObject var magazineVM = MagazineViewModel()
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    ZStack {
                        EditorView()
                        VStack(alignment: .leading) {
                            Text("GRAIN 에디터가")
                                .foregroundColor(.white)
                                .font(.title)
                                .fontWeight(.medium)
                            Text("필름에 담은 겨울 제주")
                                .foregroundColor(.white)
                                .font(.title)
                                .fontWeight(.medium)
                            Text(": With WONDER ")
                                .foregroundColor(.white)
                                .font(.title)
                                .fontWeight(.medium)
                        }
                        .offset(x: 80 ,y: 60)
                    }
                    HStack{
                        Text("Recommend")
                            .font(.title)
                            .fontWeight(.bold)
                        Image("line")
                            .resizable()
                            .frame(width: 203, height: 3.5)
                    }
                    .padding([.leading, .top])
                    ForEach(magazineVM.magazines, id: \.self ){ data in
                        NavigationLink {
                            MagazineDetailView(data: data)
                        } label: {
                            Top10View(data: data)
                                .padding(.vertical, 7)
                                .padding(.horizontal)
                                .frame(height: Screen.maxHeight * 0.6)
                            
                        }


                    }
                    
//                    4: 3 비율 -=> 가로 40  세로 30

                    // 4: 3 비율로 올린 사진이 가로일수도 있고, 새로일수도있거든요 ?
                    
                } // scroll view
            }//vstack
            .onAppear{
                magazineVM.fetchMagazine()
            }
        }
    }
}
struct MagazineBestView_Previews: PreviewProvider {
    static var previews: some View {
        MagazineBestView()
    }
}
