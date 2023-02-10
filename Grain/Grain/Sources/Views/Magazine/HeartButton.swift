//
//  HeartButton.swift
//  Grain
//
//  Created by 조형구 on 2023/02/08.
//

import SwiftUI

struct HeartButton: View {
    @State private var lifetime: Float = 0
    @State private var imageScale: CGFloat = 1
    @Binding var isHeartToggle: Bool
    @Binding var isHeartAnimation: Bool
    @Binding var heartOpacity: Double
   
    var body: some View {
        ZStack {
            Image(systemName: isHeartToggle ? "heart.fill" : "heart")
                .font(.title)
                .foregroundColor(isHeartToggle ? .red : .black)
                .scaleEffect(self.imageScale)
                
        }
        .onTapGesture {
           
            withAnimation(.interpolatingSpring(mass: 0.8, stiffness: 100, damping: 10, initialVelocity: 0)) {
                          self.isHeartAnimation.toggle()
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
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    
                    self.heartOpacity = 1
                    
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                    
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
