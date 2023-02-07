//
//  Ex+View.swift
//  Grain
//
//  Created by 박희경 on 2023/01/18.
//


import SwiftUI

extension View {
    @ViewBuilder
    @inlinable func alignmentGuide(_ alignment: HorizontalAlignment,
                                   isActive: Bool,
                                   computeValue: @escaping (ViewDimensions) -> CGFloat) -> some View {
        if isActive {
            alignmentGuide(alignment, computeValue: computeValue)
        } else {
            self
        }
    }

    @ViewBuilder
    @inlinable func alignmentGuide(_ alignment: VerticalAlignment,
                                   isActive: Bool,
                                   computeValue: @escaping (ViewDimensions) -> CGFloat) -> some View {

        if isActive {
            alignmentGuide(alignment, computeValue: computeValue)
        } else {
            self
        }
    }
    
    func hideKeyboard() {
      UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
            if hidden {
                if !remove {
                    self.hidden()
                }
            } else {
                self
            }
        }
}



extension HorizontalAlignment {
    private enum CenterAlignmentID: AlignmentID {
        static func defaultValue(in dimension: ViewDimensions) -> CGFloat {
            return dimension[HorizontalAlignment.center]
        }
    }
    
    static var horizontalCenterAlignment: HorizontalAlignment {
        HorizontalAlignment(CenterAlignmentID.self)
    }
}
