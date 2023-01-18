//
//  CommunityView.swift
//  Grain
//
//  Created by 박희경 on 2023/01/18.
//

import SwiftUI

struct CommunityView: View {
    let titles: [String] = ["전체", "매칭", "마켓", "수업"]
    @State var selectedIndex: Int = 0
    
    var body: some View {
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
        .animation(.easeInOut(duration: 0.3))
    }
}

struct CommunityView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityView()
    }
}
