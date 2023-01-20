//
//  MagazineBestView.swift
//  Grain
//
//  Created by 윤소희 on 2023/01/18.
//

import SwiftUI

struct MagazineBestView: View {
    
    let titles: [String] = ["Best", "Feed"]
    @State var selectedIndex: Int = 0
    
    var body: some View {
        NavigationStack {
            VStack {
                SegmentedPicker(
                    titles,
                    selectedIndex: Binding(
                        get: { selectedIndex },
                        set: { selectedIndex = $0 ?? 0 }),
                    content: { item, isSelected in
                        Text(item)
                            .foregroundColor(isSelected ? Color.black : Color.gray )
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .font(.title)
                            .bold()
                    },
                    selection: {
                        VStack(spacing: 0) {
                            Spacer()
                            Rectangle()
                                .fill(Color.black)
                                .frame(height: 1)
                        }
                    })
                
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
                    
                    Top10View().padding([.leading, .trailing])
                        .frame(height: Screen.maxWidth * 0.52)
                    
//                    4: 3 비율 -=> 가로 40  세로 30

                    // 4: 3 비율로 올린 사진이 가로일수도 있고, 새로일수도있거든요 ?
                    
                } // scroll view
            } //vstack
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("GRAIN")
                        .font(.title)
                        .bold()
                        .kerning(7)
                    
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        //검색
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.black)
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
