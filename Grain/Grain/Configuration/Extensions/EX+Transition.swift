//
//  EX+Transition.swift
//  Grain
//
//  Created by 조형구 on 2023/03/30.
//

import SwiftUI

extension AnyTransition {
    static var moveAndFade: AnyTransition {
        .asymmetric(
            insertion: .scale.combined(with: .opacity),
            removal: .scale.combined(with: .opacity)
        )
    }
}
