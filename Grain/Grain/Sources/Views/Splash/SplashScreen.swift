//
//  SplashScremm.swift
//  Grain
//
//  Created by 윤소희 on 2023/02/01.
//

import SwiftUI

struct SplashScreen: View {
    @State private var isActive:Bool = false
    @State private var isActive1:Bool = false
    @State private var isAnimation:Bool = false
    @State private var isAnimation2:Bool = false
    @State private var isAnimation3:Bool = false
    @State private var isAnimation4:Bool = false
    @State private var rotation = -80.0
    var body: some View {
        ZStack {
            
            if !isActive {
                Image("009")
                    .resizable()
                    .scaledToFit()
                    .ignoresSafeArea()
                    .offset(x: rotation)
                
                if isAnimation {
                    Image("009")
                        .resizable()
                        .scaledToFit()
                        .ignoresSafeArea()
                        .offset(x: rotation)
                    
                    if isAnimation {
                        Image("008")
                            .resizable()
                            .scaledToFit()
                            .ignoresSafeArea()
                            .offset(x: rotation)
                        
                        if isAnimation2 {
                            Image("007")
                                .resizable()
                                .scaledToFit()
                                .ignoresSafeArea()
                                .offset(x: rotation)
                            
                            if isAnimation3 {
                                Image("006")
                                    .resizable()
                                    .scaledToFit()
                                    .ignoresSafeArea()
                                    .offset(x: rotation)
                                
                                if isAnimation4 {
                                    Image("005")
                                        .resizable()
                                        .scaledToFit()
                                        .ignoresSafeArea()
                                        .offset(x: rotation)
                                }
                            }
                        }
                    }
                }
            }
        } // ZStack
        .animation(.easeIn(duration: 0.5), value: rotation)
        .onAppear {
            rotation = -20
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation {
                    self.isAnimation = true
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
                withAnimation {
                    self.isAnimation2 = true
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                withAnimation {
                    self.isAnimation3 = true
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                withAnimation {
                    self.isAnimation4 = true
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.6) {
                withAnimation(.easeInOut(duration: 1.0)) {
                    self.isActive = true
                }
            }
        }
//        .onChange(of: isActive) { newValue in
//            if newValue {
//                if let _ = UserDefaults.standard.string(forKey: "userIdToken") {
//                    viewModel.state = .signIn // 로그인 성공 기록이 있을 경우
//                } else {
//                    viewModel.state = .signOut
//                }
//            }
//        }
        .ignoresSafeArea()
    }
}


struct SplashScremm_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
