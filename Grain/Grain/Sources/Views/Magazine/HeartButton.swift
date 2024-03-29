//
//  HeartButton.swift
//  Grain
//
//  Created by 조형구 on 2023/02/08.
//

import SwiftUI

struct HeartButton: View {
    @Binding var lifetime: Float
    @Binding var imageScale: CGFloat
    @Binding var isHeartToggle: Bool
    @Binding var isHeartAnimation: Bool
    @Binding var heartOpacity: Double
    
    var body: some View {
        ZStack {
            Image(systemName: isHeartToggle ? "heart.fill" : "heart")
                .font(.system(size: 24))
                .foregroundColor(isHeartToggle ? .red : .black)
                .scaleEffect(self.imageScale)
            
        }
        .onTapGesture {
            if isHeartToggle == false {
                HapticManager.instance.impact(style: .medium)

            }
            withAnimation(.interpolatingSpring(mass: 0.35, stiffness: 100, damping: 4.5, initialVelocity: 25)) {
                if isHeartToggle == true {
                    self.isHeartAnimation = false
                } else if isHeartToggle == false {
                    self.isHeartAnimation = true
                }
            }
            self.isHeartToggle.toggle()
            withAnimation(Animation.linear(duration: 0.1)) {
                if isHeartToggle == true {
                    self.imageScale = 0.8
                } else {
                    self.imageScale = 0.8
                }
            }
            if isHeartAnimation == false{
                self.heartOpacity = 0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(Animation.linear(duration: 0.17)) {
                    self.imageScale = 1
                    self.lifetime = 1
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                withAnimation {
                    self.lifetime = 0
                }
            }
            if isHeartAnimation == true {
                
                
                self.heartOpacity = 1
                
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    
                    self.heartOpacity = 0
                    
                }
            }
        }
    }
}

//struct HeartButton_Previews: PreviewProvider {
//    static var previews: some View {
//        HeartButton(isHeartAnimation: .constant(false), heartOpacity: .constant(0))
//    }
//}
