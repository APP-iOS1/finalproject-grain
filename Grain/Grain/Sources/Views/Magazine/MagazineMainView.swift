//
//  MagazineMainView.swift
//  Grain
//
//  Created by 조형구 on 2023/01/20.
//

import SwiftUI

struct MagazineMainView: View {
    let titles: [String] = ["Best", "Feed"]
    @State private var selectedIndex: Int = 0
    
    var body: some View {
        NavigationStack {
            VStack{
                HStack {
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
                                .font(.title3)
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
                 
                    Spacer()
                }
                TabView(selection: $selectedIndex) {
                    MagazineBestView()
                        .tag(0)
                    MagazineFeedView()
                        .tag(1)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
//                if selectedIndex == 0 {
//                    MagazineBestView()
//                }else if selectedIndex == 1 {
//                    MagazineFeedView()
//                }
            }
        }
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

struct MagazineMainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MagazineMainView()
        }
    }
}
