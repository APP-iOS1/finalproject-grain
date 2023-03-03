//
//  FollowingFollowerView.swift
//  Grain
//
//  Created by 홍수만 on 2023/02/28.
//

import SwiftUI

struct FollowingFollowerView: View {
    let titles: [String] = ["구독자", "구독중"]
    @State private var selectedIndex: Int = 0
    @State private var isShownPickerProgress: Bool = false

    var body: some View {
        VStack{
            SegmentedPicker(
                titles,
                selectedIndex: Binding(
                    get: { selectedIndex },
                    set: { selectedIndex = $0 ?? 0 }),
                content: { item, isSelected in
                    Text(item)
                        .foregroundColor(isSelected ? Color.black : Color.gray )
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        .bold()
                        .frame(width: Screen.maxWidth * 0.48)
                },
                selection: {
                    VStack(spacing: 0) {
                        Spacer()
                        Rectangle()
                            .fill(Color.black)
                            .frame(width: Screen.maxWidth * 0.4, height: 1)
                            .transition(.slide)
                            .animation(.easeInOut, value: selectedIndex)
                    }
                    
                })
            .onChange(of: selectedIndex) { value in
                self.isShownPickerProgress = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.isShownPickerProgress = false
                }
            }
        }
    }
}

struct FollowingFollowerView_Previews: PreviewProvider {
    static var previews: some View {
        FollowingFollowerView()
    }
}
