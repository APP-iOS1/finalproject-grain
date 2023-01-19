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
            
            HStack{
                Text("에디터 픽")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.horizontal)
            
            EditorView()
            
            HStack{
                Text("Top10")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.horizontal)
            
            Top10View()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Text("Grain")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
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
struct MagazineBestView_Previews: PreviewProvider {
    static var previews: some View {
        MagazineBestView()
    }
}
