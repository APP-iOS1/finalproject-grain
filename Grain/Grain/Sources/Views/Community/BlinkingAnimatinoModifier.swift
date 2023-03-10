//
//  BlinkingAnimatinoModifier.swift
//  Grain
//
//  Created by 윤소희 on 2023/03/03.
//

import Foundation
import SwiftUI


//MARK: 반짝이는 스켈레톤 View
struct BlinkingAnimatinoModifier: AnimatableModifier {
    //MARK: Property
    var shouldShow: Bool            // 스켈레톤을 보이게 할 것 인지
    var opacity: Double                // 반짝임의 정도
    var animatableData: Double {
        get { opacity }
        set { opacity = newValue }
    }

    // zIndex: ZStack 우선순위 정하기(stack처럼 쌓이고, 이래야 ZStack끼리 오류가 적게 발생)
    func body(content: Content) -> some View {
        content.overlay(
            ZStack {
                //두개 깜빡깜빡
                Color.white // 밝은거
                    .clipShape(RoundedRectangle(cornerRadius: 0))
                    .zIndex(0)                        // 뒤의 Conent가 보이지 않도록
                RoundedRectangle(cornerRadius: 0) //회색
//                    .fill(Color(hex: "616161").opacity(0.5))
                    .fill(Color.gray.opacity(0.5))
                    .opacity(self.opacity).zIndex(1)            // 우선순위 1
            }.opacity(shouldShow ? 1 : 0)
        )
    }
}

extension View {
    // View Extension을 통해 .modifier를 쓰지 않고 쓸수 있음
    func setSkeletonView(opacity: Double, shouldShow: Bool) -> some View {
        self.modifier(BlinkingAnimatinoModifier(shouldShow: shouldShow, opacity: opacity))
    }
}
